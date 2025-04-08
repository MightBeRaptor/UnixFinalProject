from flask import Flask, render_template
import sqlite3
import os

app = Flask(__name__)
DB_PATH = os.environ.get("DB_PATH", "/data/mydatabase.db")

def get_db_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

@app.route("/")
def index():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT message FROM greetings LIMIT 1")
    result = cursor.fetchone()
    conn.close()
    return render_template("index.html", message=result["message"])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)