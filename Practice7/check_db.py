import sqlite3

conn = sqlite3.connect("database.db")
cursor = conn.cursor()

print("=== input_data ===")
cursor.execute("SELECT * FROM input_data")
for row in cursor.fetchall():
    print(row)

print("\n=== predictions ===")
cursor.execute("SELECT * FROM predictions")
for row in cursor.fetchall():
    print(row)

conn.close()