# DilProtek 🩺❤️

DilProtek is an advanced, AI-powered healthcare ecosystem designed to bridge the gap between predictive cardiac risk assessment and real-time doctor-patient connectivity. By leveraging machine learning models alongside a seamless mobile interface, DilProtek empowers users with early heart health insights and provides instantaneous communication channels with medical professionals when they matter most.

## 🚀 Core Features

- **AI Heart Risk Assessment:** Input vital health metrics to receive an instant, machine learning-driven cardiac risk evaluation.
- **Real-Time Doctor-Patient Bridge:** Integrated communication channels connecting users directly to verified medical professionals for immediate guidance.
- **Comprehensive Health Dashboard:** Track and visualize vital cardiovascular trends over time.
- **Secure Data Sync:** Frontend-to-backend data architecture ensuring patient medical metrics are handled safely and efficiently.

---

## 🛠️ Architecture & Tech Stack

DilProtek is built using a decoupled architecture, ensuring high performance, scalability, and seamless model deployment.

### Frontend
- **Framework:** Flutter (Dart)
- **State Management:** Provider / BLoC
- **Features:** Clean, intuitive UI/UX tailored for accessible health tracking.

### Backend & Machine Learning
- **Core API & Server:** Python-based backend (Flask / FastAPI)
- **ML Engine:** Custom-trained machine learning model optimized for cardiovascular risk stratification.
- **Data Integration:** Robust RESTful API endpoints enabling smooth communication between the Flutter client and the Python ML environment.

---

## ⚙️ Project Structure

```text
├── dilprotek_mobile/       # Flutter Frontend Application
│   ├── lib/
│   │   ├── models/         # Data models for patients, metrics, and risk reports
│   │   ├── screens/        # UI dashboards, input forms, and chat screens
│   │   ├── services/       # API clients for communication with the ML backend
│   │   └── main.dart       # Application entry point
│   └── pubspec.yaml
│
└── dilprotek_backend/      # Python Backend & ML Pipeline
    ├── app/
    │   ├── api/            # API routing and request handling
    │   └── models/         # Trained ML model weights and serialization files
    ├── notebooks/          # Exploratory Data Analysis (EDA) and model training
    ├── main.py             # Server entry point
    └── requirements.txt
