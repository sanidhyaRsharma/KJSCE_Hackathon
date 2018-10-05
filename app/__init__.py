from flask import Flask
from app.config import Config
import json

from werkzeug.utils import secure_filename

UPLOAD_FOLDER = 'static/uploads/'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])

mumbai_wards_polygons = ''

with open('regions_polygons.json') as f:
    mumbai_wards_polygons = json.load(f)


app=Flask(__name__)
app.config['SECRET_KEY']=Config.SECRET_KEY
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

from app import db_connect
from app import routes
