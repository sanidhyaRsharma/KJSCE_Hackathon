from flask import Flask
from app.config import Config
import json

mumbai_wards_polygons = ''

with open('regions_polygons.json') as f:
    mumbai_wards_polygons = json.load(f)


app=Flask(__name__)
app.config['SECRET_KEY']=Config.SECRET_KEY

from app import db_connect
from app import routes
