from app import app
from functools import wraps
from flask import render_template, request, session, flash, redirect, url_for

from app.db_connect import DB, CURSOR

def login_required(f):
	@wraps(f)
	def decorated_function(*args, **kwargs):
		if 'admin_id' not in session:
			flash('Login to access the admin pages')
			return redirect(url_for('login_page', next=request.url))
		return f(*args, **kwargs)
	return decorated_function

from app import restful_routes


@app.route('/')
def login_page():
	return render_template("page-login.html", title='Login M-XPRESS')


@app.route('/dashboard')
@login_required
def dashboard():

	data = {}
	
	total_issues_query = "SELECT COUNT(card_id) AS card_id_c FROM card"
	CURSOR.execute(total_issues_query)
	data['total_issues'] = CURSOR.fetchone()['card_id_c']
	if data['total_issues'] is None:
		data['total_issues'] = 0
	DB.commit()
	urgent_issues_query = "SELECT COUNT(card_id) AS card_id_c FROM card"
	CURSOR.execute(urgent_issues_query)
	data['urgent_issues'] = CURSOR.fetchone()['card_id_c']
	if data['urgent_issues'] is None:
		data['urgent_issues'] = 0
	DB.commit()

	total_comment_query = "SELECT COUNT(comment_id)  AS comm_id_c FROM comment"
	CURSOR.execute(total_comment_query)

	data['activity'] = CURSOR.fetchone()['comm_id_c']
	if data['activity'] is None:
		data['activity'] = 0
	data['activity'] = data['total_issues'] + data['activity']
	DB.commit()

	recent_issues_query = "SELECT card_id, category, timestamp, status FROM card ORDER BY timestamp DESC"
	CURSOR.execute(recent_issues_query)
	data['recent'] = CURSOR.fetchall()
	DB.commit()

	if data['recent'] is None:
		data['recent'] = []

	markers_query = "SELECT lat,lng FROM card"
	CURSOR.execute(markers_query)
	data['markers'] = CURSOR.fetchall()

	if data['markers'] is None:
		data['markers'] = []
	DB.commit()

	return render_template("dashboard.html", title='Dashboard', data=data)


@app.route('/issues')
@login_required
def issues_page():
	return render_template("cards.html", title='Issues')

@app.route('/logout')
@login_required
def logout():
   session.pop('admin_id', None)
   return redirect(url_for('login_page'))


#TEMPLATING ROUTES
################################
@app.route('/dashboard_temp')
def dashboard_temp():
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

@app.route('/page-profile')
def page_profile():
	return render_template("page-profile.html", title='Home')

@app.route('/panels')
def panels():
	return render_template("panels.html", title='Home')

@app.route('/tables')
def tables():
	return render_template("tables.html", title='Home')

@app.route('/typography')
def typography():
	return render_template("typography.html", title='Home')
###################################

@app.route('/login', methods = ['POST'])
def login():
	admin_id = request.form['admin_id']
	password = request.form['password']

	check_admin_validity = "SELECT admin_id, ward FROM admin WHERE admin_id = '%s' AND password = SHA('%s')" % (admin_id, password)

	CURSOR.execute(check_admin_validity)

	if CURSOR.rowcount == 0:
		flash('Invalid Login')
		DB.commit()
		return redirect(url_for('login_page'))
	else:
		session['admin_id'] = admin_id
		session['ward']     = CURSOR.fetchone()['ward']

		DB.commit()
		return redirect(url_for('dashboard'))
	

@app.route('/coords_input')
def simple_coords_check_form():
	return	'''
	<form method="get" action="/get_ward_name">
		<input type="text" name="lat" />
		<input type="text" name="lng" />
		<input type="submit" name="submit" value="submit"/>
	</form> 
	'''


