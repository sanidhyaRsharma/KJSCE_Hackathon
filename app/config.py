import os

class Config(object):
	SECRET_KEY = os.environ.get('SECRET_KEY') or 'This_is_a_key'
	DB_HOST    = '127.0.0.1'
	DB_USER    = 'root'
	DB_PWD     = 'c1o0l0d8'
	DATABASE   = 'm_xpress'
