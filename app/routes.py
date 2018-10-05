from app import app
from flask import render_template

from app.db_connect import DB, CURSOR
@app.route('/')
def login():
	CURSOR.execute('SELECT * FROM user WHERE user_id = 1')

	result = CURSOR.fetchone()

	return render_template("page-login.html", title='Login')

@app.route('/index')
def index():
	return render_template("index.html", title='Home')

from app import restful_routes
