from app import app
from flask import render_template

from app.db_connect import DB, CURSOR
@app.route('/')
def login():
	return render_template("page-login.html", title='Login')

#TEMPLATING ROUTES
################################
@app.route('/dashboard_temp')
def dashboard():
	return render_template("dashboard.html", title='Home')

@app.route('/charts')
def charts():
	return render_template("charts.html", title='Home')

@app.route('/elements')
def elements():
	return render_template("elements.html", title='Home')

@app.route('/icons')
def icons():
	return render_template("icons.html", title='Home')

@app.route('/notifications')
def notifications():
	return render_template("notifications.html", title='Home')

@app.route('/panels')
def panels():
	return render_template("panels.html", title='Home')

@app.route('/tables')
def tables():
	return render_template("tables.html", title='Home')

###################################

@app.route('/coords_input')
def simple_coords_check_form():
	return	'''
	<form method="get" action="/get_ward_name">
		<input type="text" name="lat" />
		<input type="text" name="lng" />
		<input type="submit" name="submit" value="submit"/>
	</form> 
	'''

from app import restful_routes

