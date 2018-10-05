from app import app
from app.db_connect import DB, CURSOR
import json

@app.route('/get_cards', methods=['GET','POST'])
def get_cards():
    get_cards_query = "SELECT card.card_id AS card_id, timestamp, title, lat, lng, description, image, category, ward, \
                        COUNT(upvote.card_id) AS upvotes FROM card \
                        LEFT JOIN upvote ON card.card_id = upvote.card_id \
                        GROUP BY card.card_id"
    CURSOR.execute(get_cards_query)
    result = CURSOR.fetchone()

    if result is None:
        result = []
    return json.dumps(result, indent=4, sort_keys=True, default=str)