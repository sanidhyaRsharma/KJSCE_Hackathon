from flask import Flask
app=Flask(__name__)
app.config['SECRET_KEY']='This_is_a_key'	

from app import routes
