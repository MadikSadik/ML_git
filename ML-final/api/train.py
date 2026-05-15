import pandas as pd
import joblib

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error

df = pd.read_csv("processed_data.csv")

df = df.fillna(0)

df["city_encoded"] = df["city"].astype("category").cat.codes

FEATURES = [
    "city_encoded",
    "usd_kzt_avg",
    "base_rate",
    "population_growth",
    "growth_rate_pct",
    "cpi_yoy",
    "idx_yoy_new"
]

TARGET = "price_new"

X = df[FEATURES]
y = df[TARGET]

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)

model = RandomForestRegressor(
    n_estimators=200,
    random_state=42
)

model.fit(X_train, y_train)

preds = model.predict(X_test)

mae = mean_absolute_error(y_test, preds)

print("MAE:", mae)

joblib.dump(model, "model.pkl")

joblib.dump(FEATURES, "features.pkl")

city_mapping = dict(
    enumerate(
        df["city"].astype("category").cat.categories
    )
)

reverse_mapping = {
    v: k for k, v in city_mapping.items()
}

joblib.dump(reverse_mapping, "city_mapping.pkl")

print("Training completed")