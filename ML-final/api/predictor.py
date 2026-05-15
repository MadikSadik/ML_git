import joblib
import pandas as pd
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent.parent

model = joblib.load(BASE_DIR / "model.pkl")
features = joblib.load(BASE_DIR / "features.pkl")
city_mapping = joblib.load(BASE_DIR / "city_mapping.pkl")


DEFAULT_CITY_PRICES = {
    "Almaty": 750000,
    "Astana": 680000,
    "Shymkent": 430000,
    "Aktau": 390000,
    "Aktobe": 360000,
    "Karaganda": 370000,
    "Atyrau": 480000,
    "Kostanay": 340000,
    "Pavlodar": 330000,
    "Semey": 310000,
}


class PredictorService:

    def predict(self, data: dict):

        city = data.get("city", "Almaty")

        if city not in city_mapping:
            return {
                "error": f"Unknown city: {city}"
            }

        horizon = int(data.get("horizon_months", 1))

        if horizon < 1:
            horizon = 1

        if horizon > 3:
            horizon = 3

        user_price = data.get("my_property_price_per_sqm")

        if user_price is None:
            current_price = DEFAULT_CITY_PRICES.get(city, 500000)
            used_default_price = True
        else:
            current_price = float(user_price)
            used_default_price = False

        row = {
            "city_encoded": city_mapping[city],
            "usd_kzt_avg": float(data.get("usd_kzt_avg", 500)),
            "base_rate": float(data.get("base_rate", 16)),
            "population_growth": float(data.get("population_growth", 2000)),
            "growth_rate_pct": float(data.get("growth_rate_pct", 1.5)),
            "cpi_yoy": float(data.get("cpi_yoy", 10)),
            "idx_yoy_new": float(data.get("idx_yoy_new", 15)),
        }

        df = pd.DataFrame([row])
        df = df.reindex(columns=features, fill_value=0)

        model_price = float(model.predict(df)[0])

        predicted_change_pct = ((model_price - current_price) / current_price) * 100

        if horizon == 1:
            limit = 10
            confidence = "high"
        elif horizon == 2:
            limit = 18
            confidence = "medium"
        else:
            limit = 25
            confidence = "low"

        predicted_change_pct = max(-limit, min(limit, predicted_change_pct))

        forecast_price = current_price * (1 + predicted_change_pct / 100)

        if predicted_change_pct > 0:
            direction_probability_up = 0.75
        elif predicted_change_pct < 0:
            direction_probability_up = 0.25
        else:
            direction_probability_up = 0.5

        reasons = []

        if row["base_rate"] < 15:
            reasons.append("Lower interest rate may support housing prices")

        if row["usd_kzt_avg"] > 520:
            reasons.append("Weak tenge may increase real estate prices")

        if row["population_growth"] > 3000:
            reasons.append("Population growth increases housing demand")

        if row["cpi_yoy"] > 12:
            reasons.append("High inflation may affect property prices")

        if predicted_change_pct > 0:
            reasons.append("Model expects positive market movement")
        else:
            reasons.append("Model expects weak or negative market movement")

        return {
            "city": city,
            "horizon_months": horizon,
            "current_price_per_sqm": round(current_price, 2),
            "used_default_price": used_default_price,
            "model_predicted_market_price": round(model_price, 2),
            "forecast_price_per_sqm": round(forecast_price, 2),
            "predicted_change_pct": round(predicted_change_pct, 2),
            "direction_probability_up": round(direction_probability_up, 2),
            "confidence": confidence,
            "reasons": reasons,
        }