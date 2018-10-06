from app import app
from app.db_connect import DB, CURSOR
import json
import requests
from math import sqrt
from shapely.geometry import Polygon, Point
from app import mumbai_wards_polygons
import numpy as np
from flask import request, send_file

WARD_NAMES = [x['properties']['name'] \
                for x in mumbai_wards_polygons['features']]

WARD_POLYGONS = {x : {} for x in WARD_NAMES}

for x in mumbai_wards_polygons['features']:
    flattened_points = [ (y[1],y[0]) for y in x['geometry']['coordinates'][0][0]]
    ward_name = x['properties']['name']

    WARD_POLYGONS[ward_name]['points']   = Polygon(flattened_points)
    centroid = WARD_POLYGONS[ward_name]['points'].centroid
    WARD_POLYGONS[ward_name]['centroid'] = (centroid.x, centroid.y)

def format_ward_name(ward_name):
    ward_name_split = ward_name.split(' ')
    ward_name = ward_name_split[1]
    
    if len(ward_name_split) > 2:
        ward_name += ('\/' + ward_name_split[2][0])

    return ward_name

def reformat_ward_name(ward_name):
    n_ward = ward_name[0]

    if len(ward_name) > 1:
        direc = ward_name[-1]

        if direc == 'E':
            n_ward += 'East'
        elif direc == 'W':
            n_ward += 'West'
        elif direc == 'N':
            n_ward += 'North'
        elif direc == 'S':
            n_ward += 'South'
        elif direc == 'C':
            n_ward += 'Central'
    
    return n_ward

def check_loc_in_poly(coords, ward_name):
    if ward_name not in WARD_NAMES:
        ward_name = format_ward_name(ward_name)

    return WARD_POLYGONS[ward_name]['points'].contains(Point(coords[0], coords[1]))

def get_location_ward(lat, lng):
    lat = float(request.args.get('lat'))
    lng = float(request.args.get('lng'))

    ward_list = [z for z in WARD_NAMES]

    ward_list.sort(key=lambda w_name : sqrt( (lat - WARD_POLYGONS[w_name]['centroid'][0])**2 + (lng - WARD_POLYGONS[w_name]['centroid'][1])**2 ))

    ward_list = ward_list[:5]

    for ward in ward_list:
        if check_loc_in_poly((lat, lng), ward):
            return ward
    
    return 'A' # Default ward


@app.route('/api/cards', methods=['GET','POST'])
def get_cards():

    filter = request.args.get('filter')
    get_cards_query = ''
    result = ''

    if filter is None:
        get_cards_query = "SELECT card.card_id AS card_id, card.timestamp AS timestamp, title, lat, lng, image, category, ward.ward_region AS ward, \
                        COUNT(upvote.card_id) AS upvotes, COUNT(comment.comment_id) AS comment_count FROM card \
                        LEFT JOIN upvote ON card.card_id = upvote.card_id \
                        LEFT JOIN comment ON card.card_id = comment.card_id \
                        INNER JOIN ward ON card.ward = ward.ward_name\
                        GROUP BY card.card_id"
        CURSOR.execute(get_cards_query)
        result = CURSOR.fetchall()

        DB.commit()

    elif filter == 'nearby':
        lat = request.args.get('lat')
        lng = request.args.get('lng')

        ward = get_location_ward(lat, lng)
        ward = reformat_ward_name(ward)

        get_cards_query = "SELECT card.card_id AS card_id, card.timestamp AS timestamp, title, lat, lng, image, category, ward.ward_region AS ward, \
                        COUNT(upvote.card_id) AS upvotes, COUNT(comment.comment_id) AS comment_count FROM card \
                        LEFT JOIN upvote ON card.card_id = upvote.card_id \
                        LEFT JOIN comment ON card.card_id = comment.card_id \
                        INNER JOIN ward ON card.ward = ward.ward_name\
                        GROUP BY card.card_id \
                        WHERE card.ward = '%s'" % (ward)

        CURSOR.execute(get_cards_query)
        result = CURSOR.fetchall()

        DB.commit()

        result.sort(key = lambda x : sqrt( (lat - x['lat'])**2 + (lng - x['lng'])**2 ))

        if len(result) > 25:
            result = result[:25]

        result.sort(key = lambda x : x['upvotes'], reverse = True)

    elif filter == 'upvotes':
        get_cards_query = "SELECT card.card_id AS card_id, card.timestamp AS timestamp, title, lat, lng, image, category, ward.ward_region AS ward, \
                        COUNT(upvote.card_id) AS upvotes, COUNT(comment.comment_id) AS comment_count FROM card \
                        LEFT JOIN upvote ON card.card_id = upvote.card_id \
                        LEFT JOIN comment ON card.card_id = comment.card_id \
                        INNER JOIN ward ON card.ward = ward.ward_name\
                        WHERE card.ward='%s'\
                        GROUP BY card.card_id\
                        ORDER BY upvotes DESC " % (ward)

        CURSOR.execute(get_cards_query)
        result = CURSOR.fetchall()

        DB.commit()

    elif filter == 'time':
        get_cards_query = "SELECT card.card_id AS card_id, card.timestamp AS timestamp, title, lat, lng, image, category, ward.ward_region AS ward, \
                        COUNT(upvote.card_id) AS upvotes, COUNT(comment.comment_id) AS comment_count FROM card \
                        LEFT JOIN upvote ON card.card_id = upvote.card_id \
                        LEFT JOIN comment ON card.card_id = comment.card_id \
                        INNER JOIN ward ON card.ward = ward.ward_name\
                        WHERE card.ward='%s'\
                        GROUP BY card.card_id\
                        ORDER BY timestamp DESC " % (ward)

        CURSOR.execute(get_cards_query)
        result = CURSOR.fetchall()

        DB.commit()


    if result is None:
        result = []
    return json.dumps(result, indent=4, sort_keys=True, default=str)

@app.route('/api/card/<int:card_id>', methods=['GET'])
def get_card_details(card_id):
    
    get_comments_query = "SELECT description AS text, timestamp FROM comment WHERE card_id=%d" % (card_id)
    CURSOR.execute(get_comments_query)

    comments = CURSOR.fetchall()
    DB.commit()

    if comments is None:
        comments = []
    
    get_additional_details_query = "SELECT description, category, status FROM card WHERE card_id=%s" % (card_id)
    CURSOR.execute(get_additional_details_query)

    additional_details = CURSOR.fetchone()
    DB.commit()
    
    if additional_details is None:
        return json.dumps([])
    
    additional_details['comments'] = comments

    return json.dumps(additional_details, indent=4, sort_keys=True, default=str)


@app.route('/api/wards')
def get_ward_suggestions():
    wards_query = 'SELECT ward_name AS w_name, ward_region AS w_regn FROM ward'
    CURSOR.execute(wards_query)
    wards = CURSOR.fetchall()
    
    return json.dumps(wards, indent=4, sort_keys=True, default=str)

@app.route('/api/ward', methods=['GET'])
def send_ward_name():

    ward_name = ''
    filter = request.args.get('filter')

    if filter == 'name':
        ward_name = request.args.get('val')

    elif filter == 'loc':
        lat = float(request.args.get('lat'))
        lng = float(request.args.get('lng'))

        ward_name = get_location_ward((lat, lng))
        ward_name = reformat_ward_name(ward)

    ward_query = "SELECT ward_name AS w_name, ward_region AS w_regn FROM ward WHERE ward_name = '%s'" % (ward_name)
    CURSOR.execute(ward_query)
    DB.commit()

    ward_details = CURSOR.fetchone()


    return json.dumps(ward_details)

@app.route('/api/img/uploads/get/<filename>')
def return_files_tut(filename):
    try:
        return send_file(app.config['UPLOAD_FOLDER'] + filename)
    except Exception as e:
        return 'Invalid Image'

@app.route('/api/card/upload', methods=['POST'])
def upload_card():
    pass
    # up_file = request.form['file']
    title   = request.form['title']

    lat     = request.form['lat']
    lng     = request.form['lng']
    description = request.form['description']
    # image = 
    user_id = request.form['user_id']
    category = request.form['category']

    ward = reformat_ward_name(get_location_ward(lat,lng))

    add_card_query = "INSERT INTO card (title, lat, lng, description,category,ward, user_id)\
                    VALUES ('%s', %s, %s, '%s', '%s', '%s')" % (title, lat, lng, description, category, ward, user_id)
    
    CURSOR.execute(add_card_query)
    DB.commit()
    
    return json.dumps({'success':True}), 200, {'ContentType':'application/json'}

@app.route('/api/comment', methods=['GET'])
def add_comment():
    card_id = request.args.get('card_id')
    user_id = request.args.get('user_id')
    comment = request.args.get('text')

    add_comment_query = "INSERT INTO comment (card_id, user_id, description, timestamp) VALUES (%s, '%s', '%s', CURRENT_TIMESTAMP)" %(card_id, user_id, comment)
    CURSOR.execute(add_comment_query)
    DB.commit()

    return json.dumps({'success':True}), 200, {'ContentType':'application/json'}

@app.route('/api/login', methods=['GET'])
def user_login():
    user_id = request.args.get('user_id')

    if user_id is None:
        return json.dumps({'success':False}), 401, {'ContentType':'application/json'}

    add_user_query = "INSERT IGNORE INTO user (user_id) VALUES ('%s')" % (user_id)

    CURSOR.execute(add_user_query)
    DB.commit()

    return json.dumps({'success':True}), 200, {'ContentType':'application/json'}

    