from flask import Flask, render_template
import mysql.connector
import os
import time

app = Flask(__name__)

# Read environment variables
DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_PORT = int(os.environ.get("DB_PORT", 3306))
DB_NAME = os.environ.get("DB_NAME", "mydb")
DB_USER = os.environ.get("DB_USER", "user")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "userpass")

def get_db_connection():
    retries = 10
    while retries > 0:
        try:
            conn = mysql.connector.connect(
                host=DB_HOST,
                port=DB_PORT,
                user=DB_USER,
                password=DB_PASSWORD,
                database=DB_NAME
            )
            return conn
        except mysql.connector.Error as err:
            print(f"MySQL connection failed: {err}")
            retries -= 1
            time.sleep(2)
    raise Exception("Could not connect to MySQL.")

@app.route("/")
def index():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Create table if it doesn't exist
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS greetings (
                id INT AUTO_INCREMENT PRIMARY KEY,
                message TEXT
            )
        """)

        # Insert a default message if table is empty
        cursor.execute("SELECT COUNT(*) FROM greetings")
        count = cursor.fetchone()[0]
        if count == 0:
            cursor.execute("INSERT INTO greetings (message) VALUES ('Hello from MySQL!')")
            conn.commit()

        # Now fetch the message
        cursor.execute("SELECT message FROM greetings LIMIT 1")
        row = cursor.fetchone()
        message = row[0] if row else "No message found."

        conn.close()
        return render_template("index.html", message=message)
    except Exception as e:
        print("ERROR:", e)
        return "Internal Server Error", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)