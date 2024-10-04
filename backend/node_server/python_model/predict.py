import joblib
import sys
import pandas as pd
import os

# Get the directory of the current script
current_dir = os.path.dirname(os.path.abspath(__file__))

def predict_credits(treeSpecies, treeAge, landSize):
    # Load the model and required files using absolute paths
    model = joblib.load(os.path.join(current_dir, 'credit_prediction_model.joblib'))
    le = joblib.load(os.path.join(current_dir, 'species_label_encoder.joblib'))
    feature_names = joblib.load(os.path.join(current_dir, 'feature_names.joblib'))

    # Encode the species
    species_encoded = le.transform([treeSpecies])[0]

    # Prepare the input data as a DataFrame with feature names
    input_data = pd.DataFrame([[species_encoded, float(treeAge), float(landSize)]], columns=feature_names)

    # Make prediction
    prediction = model.predict(input_data)

    return prediction[0]

if __name__ == "__main__":
    # Check if correct number of arguments is provided
    if len(sys.argv) != 4:
        print("Usage: python predict.py <treeSpecies> <treeAge> <landSize>")
        sys.exit(1)

    # Get input from command line arguments
    treeSpecies = sys.argv[1]
    treeAge = sys.argv[2]
    landSize = sys.argv[3]

    # Make prediction
    predicted_credits = predict_credits(treeSpecies, treeAge, landSize)

    # Print the result
    print(f"{predicted_credits:.2f}")