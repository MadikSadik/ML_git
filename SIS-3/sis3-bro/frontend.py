import streamlit as st
import requests

st.set_page_config(page_title="Wine Classifier", page_icon="🍷")
st.title("🍷 Wine Classifier")
st.write("Enter 5 key chemical features to predict the wine cultivar.")

feature_names = ["alcohol", "flavanoids", "color_intensity", "od280/od315", "proline"]
default_values = [13.0, 2.0, 5.0, 2.6, 750.0]

# --- Demo presets ---
st.subheader("Quick Demo Presets")
preset_col1, preset_col2, preset_col3 = st.columns(3)

if preset_col1.button("Load Class 0 example"):
    st.session_state.update({
        "alcohol": 13.7, "flavanoids": 3.0, "color_intensity": 5.5,
        "od280/od315": 3.15, "proline": 1115.0,
    })
if preset_col2.button("Load Class 1 example"):
    st.session_state.update({
        "alcohol": 12.3, "flavanoids": 2.1, "color_intensity": 3.0,
        "od280/od315": 2.8, "proline": 520.0,
    })
if preset_col3.button("Load Class 2 example"):
    st.session_state.update({
        "alcohol": 13.15, "flavanoids": 0.8, "color_intensity": 7.4,
        "od280/od315": 1.7, "proline": 630.0,
    })

# --- Feature inputs ---
st.subheader("Input Features")
features = []
col1, col2 = st.columns(2)
for i, name in enumerate(feature_names):
    target_col = col1 if i % 2 == 0 else col2
    value = target_col.number_input(
        label=name,
        value=st.session_state.get(name, default_values[i]),
        format="%.2f",
        key=name,
    )
    features.append(value)

# --- Predict ---
if st.button("Predict", type="primary"):
    try:
        response = requests.post(
            "http://localhost:8000/predict",
            json={"features": features},
            timeout=5,
        )
        if response.status_code == 200:
            st.success(f"🍷 Predicted Wine Class: **{response.json()['predict']}**")
        else:
            st.error(f"API error: {response.text}")
    except Exception as e:
        st.error(f"Error: {e}")