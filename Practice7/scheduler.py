import schedule
import time
from batch_predict import run_batch_prediction

INTERVAL_MINUTES = 1

# Run immediately on startup so you don't have to wait 5 minutes
print(f"Scheduler started. Running batch prediction every {INTERVAL_MINUTES} minutes.")
print("Press Ctrl+C to stop.\n")
run_batch_prediction()

# Schedule recurring runs
schedule.every(INTERVAL_MINUTES).minutes.do(run_batch_prediction)

# Loop forever, checking every second if it's time to run
while True:
    schedule.run_pending()
    time.sleep(1)