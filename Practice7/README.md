# Practical Task 7: Batch Prediction Pipeline

A batch ML prediction pipeline that simulates a real-world ML system. Reads input data from a SQLite database, runs predictions using a trained Random Forest model on the Wine dataset, writes results back to the database, and runs automatically on a schedule.

## Project Overview

This project builds on the model trained in Practical Task 6 / SIS-3 (a Random Forest classifier on scikit-learn's Wine dataset). Instead of serving predictions through an API, this version runs them as scheduled batch jobs against a database.

## Project Structure

```
Practice7/
├── train.py                  # Trains the model and saves model.joblib
├── model.joblib              # Trained Random Forest model
├── seed_data.py              # Creates database and seeds it with sample wines
├── add_wine.py               # Adds a single wine to input_data (simulates new data)
├── batch_predict.py          # The pipeline: reads DB → predicts → writes results
├── scheduler.py              # Runs batch_predict.py on a schedule
├── check_db.py               # Utility to inspect database contents
├── database.db               # SQLite database (auto-generated)
├── requirements.txt          # Python dependencies
└── README.md
```

## Database Schema

Two tables in `database.db`:

**`input_data`** — wines waiting to be classified

| Column | Type | Description |
|---|---|---|
| id | INTEGER PRIMARY KEY | Auto-incrementing row id |
| alcohol | REAL | Alcohol percentage |
| flavanoids | REAL | Flavanoid content |
| color_intensity | REAL | Color intensity |
| od280 | REAL | OD280/OD315 ratio |
| proline | REAL | Proline content |

**`predictions`** — model outputs

| Column | Type | Description |
|---|---|---|
| id | INTEGER PRIMARY KEY | Auto-incrementing row id |
| input_id | INTEGER | References input_data.id |
| prediction | INTEGER | Predicted Wine class (0, 1, or 2) |
| prediction_timestamp | DATETIME | When the prediction was made |

## Pipeline Architecture

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│  scheduler.py  ─── triggers every N minutes ───→     │
│                                                      │
│                                                      │
│        ┌─────────────────────────────────────┐       │
│        │      batch_predict.py               │       │
│        │                                     │       │
│        │  1. Connect to database.db          │       │
│        │  2. SELECT unpredicted rows         │       │
│        │     from input_data                 │       │
│        │  3. Load model.joblib               │       │
│        │  4. model.predict(features)         │       │
│        │  5. INSERT into predictions         │       │
│        │     (with timestamp)                │       │
│        └─────────────────────────────────────┘       │
│                                                      │
└──────────────────────────────────────────────────────┘
```

The pipeline only predicts rows that don't yet have a matching entry in the `predictions` table — preventing duplicate work.

## Setup

```bash
# Create virtual environment
python -m venv .venv
source .venv/bin/activate       # macOS/Linux
# .venv\Scripts\activate         # Windows

# Install dependencies
pip install -r requirements.txt
```

## How to Run

### 1. Train the model

```bash
python train.py
```

Trains the Random Forest classifier and saves `model.joblib`.

### 2. Seed the database

```bash
python seed_data.py
```

Creates `database.db`, sets up both tables, and inserts 9 sample wines (3 per class) into `input_data`.

### 3. Start the scheduler

```bash
python scheduler.py
```

Runs `batch_predict.py` immediately, then every 5 minutes after that. Leave this running.

Output looks like:
```
Scheduler started. Running batch prediction every 5 minutes.
Press Ctrl+C to stop.

[2026-05-02 21:37:10] Starting batch prediction...
Found 9 new rows to predict.
  Input ID 1: features=[13.7, 3.0, 5.5, 3.15, 1115.0] → predicted Class 0
  ...
Wrote 9 predictions to database.
```

### 4. Simulate new data arriving (in a separate terminal)

```bash
python add_wine.py
```

Adds one new wine to the `input_data` table. Within the next scheduler interval, `batch_predict.py` will detect and predict it automatically.

### 5. Inspect the database

```bash
python check_db.py
```

Prints both tables. You'll see all input rows and their corresponding predictions with timestamps.

## Demo Workflow

To show the full pipeline working end-to-end:

```bash
# Terminal 1
python scheduler.py
# (predicts the 9 seeded wines on its first run)

# Terminal 2 — wait a minute, then run:
python add_wine.py
# (adds wine #10)

# Terminal 1 will pick it up at the next interval and predict it.

# Terminal 2 — verify:
python check_db.py
# Shows 10 inputs and 10 predictions, with the 10th having a later timestamp.
```

The differing timestamps prove the scheduler triggered the prediction autonomously, not by manual invocation.

## Configuration

To change the schedule interval, edit `scheduler.py`:

```python
INTERVAL_MINUTES = 5    # change to whatever you want
```

For a faster demo, you can use seconds instead:

```python
schedule.every(30).seconds.do(run_batch_prediction)
```

## Dataset

scikit-learn's Wine dataset — 178 samples, 3 cultivar classes. The model uses 5 features selected by Random Forest feature importance:
`alcohol`, `flavanoids`, `color_intensity`, `od280/od315`, `proline`.

## Model

- **Algorithm:** RandomForestClassifier
- **Hyperparameters:** `n_estimators=100`, `max_depth=5`, `random_state=42`
- **Test accuracy:** ~97%

## Requirements

```
scikit-learn
joblib
numpy
pandas
schedule
```