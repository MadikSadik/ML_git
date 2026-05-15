import pandas as pd
import joblib
import mlflow
import mlflow.sklearn

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import numpy as np


df = pd.read_csv("processed_data.csv")
df = df.fillna(0)

df["city_encoded"] = df["city"].astype("category").cat.codes
print("SOMETHING")
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

mlflow.set_experiment("Real_Estate_Forecast_Project")

with mlflow.start_run():

    model = RandomForestRegressor(
        n_estimators=200,
        random_state=42
    )

    model.fit(X_train, y_train)

    preds = model.predict(X_test)

    mae = mean_absolute_error(y_test, preds)
    rmse = np.sqrt(mean_squared_error(y_test, preds))
    r2 = r2_score(y_test, preds)

    mlflow.log_param("model_type", "RandomForestRegressor")
    mlflow.log_param("n_estimators", 200)
    mlflow.log_param("random_state", 42)
    mlflow.log_param("target", TARGET)
    mlflow.log_param("features", FEATURES)

    mlflow.log_metric("mae", mae)
    mlflow.log_metric("rmse", rmse)
    mlflow.log_metric("r2_score", r2)

    mlflow.sklearn.log_model(
        model,
        "real_estate_price_model"
    )

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

    print("MLflow training completed")
    print("MAE:", mae)
    print("RMSE:", rmse)
    print("R2:", r2)