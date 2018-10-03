import os

class Config(object):
	SECRET_KEY = os.environ.get('SECRET_KEY') or 'This_is_a_key'