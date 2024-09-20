import psycopg2

def db_conn():
    conn = psycopg2.connect(
        dbname='inventory',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )
    cursor = conn.cursor()
    return cursor, conn
