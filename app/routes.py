from app import app
from flask import render_template

@app.route('/')
def login():
	return render_template("page-login.html", title='Login')

@app.route('/index')
def index():
	return render_template("index.html", title='Home')
