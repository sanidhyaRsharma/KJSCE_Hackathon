from app import app
from app.db_connect import DB, CURSOR
import json
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

def get_ward_name(lat, lng):
    lat = float(request.args.get('lat'))
    lng = float(request.args.get('lng'))

    ward_list = [z for z in WARD_NAMES]

    ward_list.sort(key=lambda w_name : sqrt( (lat - WARD_POLYGONS[w_name]['centroid'][0])**2 + (lng - WARD_POLYGONS[w_name]['centroid'][1])**2 ))

    ward_list = ward_list[:5]

    for ward in ward_list:
        if check_loc_in_poly((lat, lng), ward):
            return ward
    
    return 'Error'


@app.route('/api/cards', methods=['GET','POST'])
def get_cards():
    get_cards_query = "SELECT card.card_id AS card_id, card.timestamp AS timestamp, title, lat, lng, image, category, ward.ward_region AS ward, \
                        COUNT(upvote.card_id) AS upvotes, COUNT(comment.comment_id) AS comment_count FROM card \
                        LEFT JOIN upvote ON card.card_id = upvote.card_id \
                        LEFT JOIN comment ON card.card_id = comment.card_id \
                        INNER JOIN ward ON card.ward = ward.ward_name\
                        GROUP BY card.card_id"

    CURSOR.execute(get_cards_query)
    result = CURSOR.fetchall()

    DB.commit()

    if result is None:
        result = []
    return json.dumps(result, indent=4, sort_keys=True, default=str)

@app.route('/api/cards/<int:card_id>', methods=['GET'])
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

@app.route('/api/loc', methods=['GET'])
def send_ward_name():

        lat = float(request.args.get('lat'))
        lng = float(request.args.get('lng'))

        return json.dumps({'ward' : get_ward_name(lat, lng)})
        print(e)
        return json.dumps({'ward':'Error'})

@app.route('/api/uploads/')
def return_files_tut():
    try:
        return send_file('/var/www/PythonProgramming/PythonProgramming/static/images/python.jpg', attachment_filename='python.jpg')
    except Exception as e:
        return str(e)