from flask import Flask
from app.config import Config


app=Flask(__name__)
app.config['SECRET_KEY']=Config.SECRET_KEY

from app import db_connect
from app import routes
