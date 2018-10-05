from app import app
from app.db_connect import DB, CURSOR
import json

@app.route('/get_cards', methods=['GET','POST'])
def get_cards():
    CURSOR.execute('SELECT * FROM card')
    result = CURSOR.fetchone()
    return json.dumps(result, indent=4, sort_keys=True, default=str)