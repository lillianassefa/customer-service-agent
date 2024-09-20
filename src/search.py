from src.db import db_conn


cursor, conn = db_conn()

def search_inventory(question):
    try:
        # Fetch all unique product names from the inventory_data table
        cursor.execute("SELECT DISTINCT \"productname\" FROM inventory_data;")
        products = cursor.fetchall()
        product_names = [p[0] for p in products if p[0] is not None]

        # Find if any product name is mentioned in the question
        for product_name in product_names:
            if product_name.lower() in question.lower():
                # Fetch all relevant data from the table
                cursor.execute("""
                    SELECT *
                    FROM inventory_data
                    WHERE LOWER("productname") = %s
                    LIMIT 1;
                """, (product_name.lower(),))
                result = cursor.fetchone()
                if result:
                    columns = [desc[0] for desc in cursor.description]
                    product_info = dict(zip(columns, result))
                    return product_info
        return None
    except Exception as e:
        print(f"Error searching inventory: {e}")
        conn.rollback()
        return None
