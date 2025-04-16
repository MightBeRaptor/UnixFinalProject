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
        c = conn.cursor(dictionary=True)

        # Drop all tables
        c.execute("DROP TABLE IF EXISTS user_roles")  # Clear existing table
        c.execute("DROP TABLE IF EXISTS users")  # Clear existing table
        c.execute("DROP TABLE IF EXISTS roles")

        # CREATE & INSERT
        # users
        c.execute("""
            CREATE TABLE IF NOT EXISTS users (
                user_id INT AUTO_INCREMENT PRIMARY KEY,
                first_name VARCHAR(100),
                last_name VARCHAR(100)
            )
        """)
        c.execute("INSERT INTO users (first_name, last_name) VALUES ('Hunter', 'Doe')")  # 1
        c.execute("INSERT INTO users (first_name, last_name) VALUES ('Ethan', 'Doe')")   # 2
        c.execute("INSERT INTO users (first_name, last_name) VALUES ('Eli', 'Doe')")     # 3
        c.execute("INSERT INTO users (first_name, last_name) VALUES ('Jill', 'Doe')")    # 4

        # roles
        c.execute("DROP TABLE IF EXISTS roles")
        c.execute("""
            CREATE TABLE IF NOT EXISTS roles (
                role_id INT AUTO_INCREMENT PRIMARY KEY,
                role VARCHAR(255)
            )
        """)
        c.execute("INSERT INTO roles (role) VALUES ('admin')")   # 1
        c.execute("INSERT INTO roles (role) VALUES ('agent')")   # 2
        c.execute("INSERT INTO roles (role) VALUES ('janitor')") # 3

        # user_roles (many-to-many)
        c.execute("DROP TABLE IF EXISTS user_roles")
        c.execute("""
            CREATE TABLE IF NOT EXISTS user_roles (
                user_id INT,
                role_id INT,
                PRIMARY KEY (user_id, role_id),
                FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
            )
        """)

        c.execute("INSERT INTO user_roles (user_id, role_id) VALUES (1, 1)")  # hunter, admin
        c.execute("INSERT INTO user_roles (user_id, role_id) VALUES (1, 2)")  # hunter, agent
        c.execute("INSERT INTO user_roles (user_id, role_id) VALUES (2, 3)")  # ethan, janitor
        c.execute("INSERT INTO user_roles (user_id, role_id) VALUES (3, 2)")  # eli, agent
        c.execute("INSERT INTO user_roles (user_id, role_id) VALUES (4, 1)")  # jill, admin
        c.execute("INSERT INTO user_roles (user_id, role_id) VALUES (4, 2)")  # jill, agent

        c.execute("SELECT * FROM users")
        users = c.fetchall()

        c.execute("SELECT * FROM roles")
        roles = c.fetchall()

        c.execute("SELECT * FROM user_roles")
        user_roles = c.fetchall()

        c.execute("""
                    SELECT 
                        u.first_name, 
                        u.last_name, 
                        GROUP_CONCAT(r.role SEPARATOR ', ') AS roles
                    FROM 
                        users u
                    JOIN 
                        user_roles ur ON u.user_id = ur.user_id
                    JOIN 
                        roles r ON r.role_id = ur.role_id
                    GROUP BY 
                        u.user_id, u.first_name, u.last_name
        """)
        user_roles_agg = c.fetchall()

        conn.commit()
        conn.close()

        # Pass data to index.html
        return render_template(
            "index.html", 
            users=users, 
            roles=roles, 
            user_roles=user_roles, 
            user_roles_agg=user_roles_agg
            )
    
    except Exception as e:
        print("ERROR:", e)
        return "Internal Server Error", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)