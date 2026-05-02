import sqlite3
import joblib
from datetime import datetime

DB_PATH = "database.db"
MODEL_PATH = "model.joblib"


def run_batch_prediction():
    print(f"\n[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] Starting batch prediction...")

    # Load the trained model
    model = joblib.load(MODEL_PATH)

    # Connect to database
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Find rows in input_data that haven't been predicted yet
    cursor.execute("""
        SELECT id, alcohol, flavanoids, color_intensity, od280, proline
        FROM input_data
        WHERE id NOT IN (SELECT input_id FROM predictions)
    """)
    rows = cursor.fetchall()

    if not rows:
        print("No new rows to predict. Skipping.")
        conn.close()
        return

    print(f"Found {len(rows)} new rows to predict.")

    # Run predictions
    predictions_to_insert = []
    for row in rows:
        input_id = row[0]
        features = list(row[1:])  # 5 features
        prediction = int(model.predict([features])[0])
        predictions_to_insert.append((input_id, prediction))
        print(f"  Input ID {input_id}: features={features} → predicted Class {prediction}")

    # Write all predictions to the predictions table
    cursor.executemany("""
        INSERT INTO predictions (input_id, prediction)
        VALUES (?, ?)
    """, predictions_to_insert)

    conn.commit()
    print(f"Wrote {len(predictions_to_insert)} predictions to database.")
    conn.close()


if __name__ == "__main__":
    run_batch_prediction()