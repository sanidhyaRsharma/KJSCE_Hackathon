import pymysql
from app.config import Config

DB     = pymysql.connect(Config.DB_HOST,Config.DB_USER,Config.DB_PWD,Config.DATABASE)
CURSOR = DB.cursor(pymysql.cursors.DictCursor)

