import joblib
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import LabelEncoder
import pandas as pd
import os

# Get the directory of the current script
current_dir = os.path.dirname(os.path.abspath(__file__))

# Load your data
data = pd.read_csv(os.path.join(current_dir, 'inteldf.csv'))

# Prepare your data
le = LabelEncoder()
data['treeSpecies'] = le.fit_transform(data['treeSpecies'])

feature_names = ['treeSpecies', 'treeAge', 'landSize']
X = data[feature_names]
y = data['credit_points']

# Train your model
model = LinearRegression()
model.fit(X, y)

# Save the model
joblib.dump(model, os.path.join(current_dir, 'credit_prediction_model.joblib'))

# Save the label encoder
joblib.dump(le, os.path.join(current_dir, 'species_label_encoder.joblib'))

# Save the feature names
joblib.dump(feature_names, os.path.join(current_dir, 'feature_names.joblib'))

print("Model and required files saved successfully.")