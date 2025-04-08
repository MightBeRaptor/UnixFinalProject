import sqlite3

conn = sqlite3.connect("/data/mydatabase.db")
c = conn.cursor()
c.execute("CREATE TABLE IF NOT EXISTS greetings (message TEXT)")
c.execute("INSERT INTO greetings (message) VALUES ('Hello from SQLite in a separate container!')")
conn.commit()
conn.close()