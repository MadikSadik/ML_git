import joblib
import mlflow
import mlflow.sklearn
from sklearn.datasets import load_wine
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, f1_score

wine = load_wine()

# 5 most important features (indices in sklearn's Wine dataset)
# 0=alcohol, 6=flavanoids, 9=color_intensity, 11=od280, 12=proline
selected_idx = [0, 6, 9, 11, 12]
X = wine.data[:, selected_idx]
y = wine.target

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

mlflow.set_experiment("wine-classifier")

with mlflow.start_run():
    model = RandomForestClassifier(n_estimators=100, max_depth=5, random_state=42)
    model.fit(X_train, y_train)

    preds = model.predict(X_test)
    acc = accuracy_score(y_test, preds)
    f1 = f1_score(y_test, preds, average="weighted")
    print(f"Accuracy: {acc:.4f} | F1: {f1:.4f}")

    mlflow.log_param("n_estimators", 100)
    mlflow.log_param("max_depth", 5)
    mlflow.log_param("num_features", 5)

    mlflow.log_metric("accuracy", acc)
    mlflow.log_metric("f1_score", f1)

    mlflow.sklearn.log_model(model, name="model", registered_model_name="WineClassifier")
    joblib.dump(model, "model.joblib")