import joblib
import numpy as np
from flask import Flask, request, jsonify
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app) 
try:
    model = joblib.load('heart_model.pkl')
    scaler = joblib.load('scaler.pkl')
    print("✅ AI Models Loaded Successfully")
except Exception as e:
    print(f"❌ Error Loading Models: {e}")
    model = None
    scaler = None

@app.route('/', methods=['GET'])
def home():
    return "DilProtek Backend is Running!"

@app.route('/predict', methods=['POST'])
def predict():
    if not model:
        return jsonify({"error": "AI Model not active"}), 500

    try:
        data = request.json
        
        # 1. Extract features in the exact order model expects
        features = np.array([[
            float(data.get('age', 0)),
            float(data.get('sex', 0)),
            float(data.get('cp', 0)),
            float(data.get('trtbps', 0)),
            float(data.get('chol', 0)),
            float(data.get('fbs', 0)),
            float(data.get('restecg', 0)),
            float(data.get('thalachh', 0)),
            float(data.get('exng', 0)),
            float(data.get('caa', 0)),
            # These last 3 might be optional depending on your specific pkl version,
            # but we include defaults just in case
            float(data.get('oldpeak', 0.0)), 
            float(data.get('slp', 0.0)),
            float(data.get('thall', 0.0))
        ]])

        # 2. Scale features
        scaled = scaler.transform(features)
        
        # 3. Predict probability
        probability = model.predict_proba(scaled)[0][1]
        risk_score = round(probability * 100, 2)

        return jsonify({
            "risk_score": risk_score,
            "status": "success"
        })

    except Exception as e:
        print(f"Prediction Error: {e}")
        return jsonify({"error": str(e)}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)