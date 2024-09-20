from datetime import datetime
from src.db import db_conn


cursor, conn = db_conn()


def log_interaction(user_question, answer):
    try:
        interaction_timestamp = datetime.now()
        cursor.execute("""
            INSERT INTO user_interactions (interaction_timestamp, user_question, answer)
            VALUES (%s, %s, %s);
        """, (interaction_timestamp, user_question, answer))
        conn.commit()
    except Exception as e:
        conn.rollback()
        print(f"Error logging interaction: {e}")
