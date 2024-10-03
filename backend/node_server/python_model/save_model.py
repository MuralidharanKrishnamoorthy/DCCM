# Script 1: Save the trained model and required files

import joblib
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import LabelEncoder
import pandas as pd

# Assuming you've already trained your model and have your data

# Load your data
data = pd.read_csv(r"D:\DCCM\backend\node_server\python_model\inteldf.csv")

# Prepare your data
le = LabelEncoder()
data['species'] = le.fit_transform(data['species'])

feature_names = ['species', 'age', 'acres']
X = data[feature_names]
y = data['credit_points']

# Train your model
model = LinearRegression()
model.fit(X, y)

# Save the model
joblib.dump(model, 'credit_prediction_model.joblib')

# Save the label encoder
joblib.dump(le, 'species_label_encoder.joblib')

# Save the feature names
joblib.dump(feature_names, 'feature_names.joblib')

print("Model and required files saved successfully.")

# Script 2: Load the model and make predictions

import joblib
import sys

def predict_credits(species, age, acres):
    # Load the model and required files
    model = joblib.load('credit_prediction_model.joblib')
    le = joblib.load('species_label_encoder.joblib')
    feature_names = joblib.load('feature_names.joblib')

    # Encode the species
    species_encoded = le.transform([species])[0]

    # Prepare the input data
    input_data = [[species_encoded, float(age), float(acres)]]

    # Make prediction
    prediction = model.predict(input_data)

    return prediction[0]

if __name__ == "__main__":
    # Check if correct number of arguments is provided
    if len(sys.argv) != 4:
        print("Usage: python predict.py <species> <age> <acres>")
        sys.exit(1)

    # Get input from command line arguments
    species = sys.argv[1]
    age = sys.argv[2]
    acres = sys.argv[3]

    # Make prediction
    predicted_credits = predict_credits(species, age, acres)

    # Print the result
    print(f"{predicted_credits:.2f}")