from fastapi import FastAPI
from fastapi.responses import HTMLResponse

from api.predictor import PredictorService


app = FastAPI()
service = PredictorService()


@app.get("/", response_class=HTMLResponse)
def home():

    return """
<!DOCTYPE html>
<html>
<head>
    <title>Real Estate Forecast System</title>

    <style>
        body {
            font-family: Arial;
            background: #f4f4f4;
            padding: 40px;
        }

        .container {
            background: white;
            max-width: 720px;
            margin: auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }

        h1 {
            margin-bottom: 25px;
        }

        label {
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            margin-bottom: 20px;
            box-sizing: border-box;
        }

        button {
            padding: 12px 22px;
            cursor: pointer;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
        }

        button:hover {
            background: #1d4ed8;
        }

        .result {
            margin-top: 30px;
            padding: 20px;
            background: #eeeeee;
            border-radius: 10px;
            line-height: 1.6;
        }

        .hint {
            color: #666;
            font-size: 14px;
            margin-top: -12px;
            margin-bottom: 15px;
        }
    </style>
</head>

<body>

<div class="container">

    <h1>Real Estate Forecast</h1>

    <label>City</label>
    <select id="city" onchange="updateDefaultPrice()">
        <option value="Almaty">Almaty</option>
        <option value="Astana">Astana</option>
        <option value="Shymkent">Shymkent</option>
        <option value="Aktau">Aktau</option>
        <option value="Aktobe">Aktobe</option>
        <option value="Karaganda">Karaganda</option>
        <option value="Atyrau">Atyrau</option>
        <option value="Kostanay">Kostanay</option>
        <option value="Pavlodar">Pavlodar</option>
        <option value="Semey">Semey</option>
    </select>

    <label>Forecast Horizon</label>
    <input id="horizon" type="number" value="1" min="1" max="3">
    <div class="hint">Allowed range: 1–3 months</div>

    <label>Property Price Per m²</label>
    <input id="property_price" type="number">
    <div class="hint">
        Default price is selected automatically by city, but you can change it.
    </div>

    <button onclick="predict()">Predict</button>

    <div class="result" id="result"></div>

</div>

<script>

const defaultPrices = {
    "Almaty": 750000,
    "Astana": 680000,
    "Shymkent": 430000,
    "Aktau": 390000,
    "Aktobe": 360000,
    "Karaganda": 370000,
    "Atyrau": 480000,
    "Kostanay": 340000,
    "Pavlodar": 330000,
    "Semey": 310000
};

function updateDefaultPrice() {
    const city = document.getElementById("city").value;
    document.getElementById("property_price").value = defaultPrices[city];
}

async function predict() {

    const data = {
        city: document.getElementById("city").value,

        horizon_months: parseInt(
            document.getElementById("horizon").value
        ),

        my_property_price_per_sqm: parseFloat(
            document.getElementById("property_price").value
        )
    };

    const response = await fetch("/predict", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(data)
    });

    const result = await response.json();

    let html = "";

    if (result.error) {
        html = "<h3>" + result.error + "</h3>";
    } else {
        html += `
            <h2>Forecast Result</h2>

            <p><b>City:</b> ${result.city}</p>

            <p><b>Horizon:</b> ${result.horizon_months} month(s)</p>

            <p><b>Current Price Per m²:</b> ${result.current_price_per_sqm} KZT</p>

            <p><b>Forecast Price Per m²:</b> ${result.forecast_price_per_sqm} KZT</p>

            <p><b>Predicted Change:</b> ${result.predicted_change_pct}%</p>

            <p><b>Direction Probability Up:</b> ${result.direction_probability_up}</p>

            <p><b>Confidence:</b> ${result.confidence}</p>

            <h3>Reasons</h3>
            <ul>
        `;

        result.reasons.forEach(reason => {
            html += "<li>" + reason + "</li>";
        });

        html += "</ul>";
    }

    document.getElementById("result").innerHTML = html;
}

window.onload = updateDefaultPrice;

</script>

</body>
</html>
"""


@app.post("/predict")
def predict(data: dict):
    return service.predict(data)