import json
from pathlib import Path

import pandas as pd
from scipy.stats import ks_2samp


BASE_DIR = Path(__file__).resolve().parent.parent

REFERENCE_PATH = BASE_DIR / "data"  / "reference.csv"
CURRENT_PATH = BASE_DIR / "data" / "current.csv"
OUTPUT_PATH = BASE_DIR / "metrics" / "drift_report.json"

NUMERIC_FEATURES = [
    "price_new",
    "price_resale",
    "rent",
    "idx_mom_new",
    "idx_mom_rent",
    "idx_mom_resale",
    "idx_yoy_new",
    "idx_yoy_rent",
    "idx_yoy_resale",
    "usd_kzt_avg",
    "base_rate",
    "cpi_mom",
    "cpi_ytd_dec",
    "cpi_yoy",
    "ipi_mom",
    "construction_mom",
    "population_start",
    "population_growth",
    "natural_increase",
    "net_migration",
    "population_end",
    "growth_rate_pct"
]


def run_drift():

    reference_df = pd.read_csv(REFERENCE_PATH)
    current_df = pd.read_csv(CURRENT_PATH)

    report = {
        "drift_detected": False,
        "features": {}
    }

    for feature in NUMERIC_FEATURES:

        if feature not in reference_df.columns or feature not in current_df.columns:
            continue

        reference = reference_df[feature].dropna()
        current = current_df[feature].dropna()

        if len(reference) == 0 or len(current) == 0:
            continue

        stat, p_value = ks_2samp(reference, current)

        drift = p_value < 0.05

        report["features"][feature] = {
            "ks_statistic": float(stat),
            "p_value": float(p_value),
            "drift": bool(drift)
        }

        if drift:
            report["drift_detected"] = True

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)

    with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
        json.dump(report, f, indent=4)

    return report


if __name__ == "__main__":
    result = run_drift()
    print(json.dumps(result, indent=4))