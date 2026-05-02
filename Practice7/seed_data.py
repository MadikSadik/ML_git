import sqlite3
import random

DB_PATH = "database.db"

# Create database and tables
conn = sqlite3.connect(DB_PATH)
cursor = conn.cursor()

# Create input_data table (5 features matching our trained model)
cursor.execute("""
CREATE TABLE IF NOT EXISTS input_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    alcohol REAL,
    flavanoids REAL,
    color_intensity REAL,
    od280 REAL,
    proline REAL
)
""")

# Create predictions table
cursor.execute("""
CREATE TABLE IF NOT EXISTS predictions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    input_id INTEGER,
    prediction INTEGER,
    prediction_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (input_id) REFERENCES input_data(id)
)
""")

# Sample wines that span all 3 classes (using realistic ranges)
sample_wines = [
    # Class 0 examples (high alcohol, high proline)
    (13.7, 3.0, 5.5, 3.15, 1115.0),
    (14.2, 2.8, 6.0, 3.0, 1200.0),
    (13.5, 3.2, 5.0, 3.3, 1050.0),
    # Class 1 examples (lighter, lower proline)
    (12.3, 2.1, 3.0, 2.8, 520.0),
    (11.8, 1.9, 2.5, 3.1, 480.0),
    (12.5, 2.3, 3.5, 2.7, 600.0),
    # Class 2 examples (low flavanoids, high color)
    (13.15, 0.8, 7.4, 1.7, 630.0),
    (13.4, 0.6, 8.0, 1.5, 700.0),
    (12.9, 1.0, 6.8, 1.9, 580.0),
]

# Insert
cursor.executemany("""
INSERT INTO input_data (alcohol, flavanoids, color_intensity, od280, proline)
VALUES (?, ?, ?, ?, ?)
""", sample_wines)

conn.commit()
print(f"Inserted {len(sample_wines)} sample wines into input_data table.")

# Show what's in the database
cursor.execute("SELECT COUNT(*) FROM input_data")
total = cursor.fetchone()[0]
print(f"Total rows in input_data: {total}")

conn.close()