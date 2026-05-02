import sqlite3

conn = sqlite3.connect("database.db")

# A new wine to predict (you can change these values)
new_wine = (13.5, 2.5, 5.0, 2.9, 900.0)

conn.execute("""
    INSERT INTO input_data (alcohol, flavanoids, color_intensity, od280, proline)
    VALUES (?, ?, ?, ?, ?)
""", new_wine)

conn.commit()
conn.close()

print(f"Added new wine: {new_wine}")