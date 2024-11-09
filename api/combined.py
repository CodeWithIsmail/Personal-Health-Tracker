from flask import Flask, request, jsonify
import cv2
import pytesseract
import numpy as np
import re
import requests  # For making requests between APIs

app = Flask(__name__)

# Set the Tesseract executable path (if needed)
# pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

# Function to parse the OCR text and extract key-value pairs
def parse_ocr_text(text):
    # Define regex patterns to capture various metrics
    patterns = {
        "haemoglobin": r"Haemoglobin\s*:\s*([\d.,]+)\s*g/dL",
        "esr": r"ESR \(Westergren Method\)\s*:\s*(\d+)\s*mm in 1st hr",
        "wbc_total": r"Total WBC Count\s*:\s*([\d.,]+(?:\s*X\s*10\^?\d+)?)/uL",
        "neutrophils": r"Neutrophils\s*:\s*(\d+)\s?%",
        "lymphocytes": r"Lymphocytes\s*:\s*(\d+)\s?%",
        "monocytes": r"Monocytes\s*:\s*(\d+)\s?%",
        "eosinophils": r"Eosinophils\s*:\s*(\d+)\s?%",
        "basophils": r"Basophils\s*:\s*(\d+)\s?%",
        "rbc_total": r"Total RBC Count\s*:\s*([\d.,]+(?:\s*X\s*10\^?\d+)?)/uL",
        "hct_pcv": r"HCT/PCV\s*:\s*([\d.,]+)\s?%",
        "mcv": r"MCV\s*:\s*([\d.,]+)\s?fL",
        "mch": r"MCH\s*:\s*([\d.,]+)\s?pg",
        "mchc": r"MCHC\s*:\s*([\d.,]+)\s?g/dL",
        "rdw_cv": r"RDW-CV\s*:\s*([\d.,]+)\s?%",
        "rdw_sd": r"RDW-SD\s*:\s*([\d.,]+)\s?fL",
        "platelet_total": r"Total Platelet Count\s*:\s*([\d.,]+(?:\s*X\s*10\^?\d+)?)/uL",
        "mpv": r"MPV\s*:\s*([\d.,]+)\s?fL",
        "pdw": r"PDW\s*:\s*([\d.,]+)\s?fL",
        "p_lcr": r"P-LCR\s*:\s*([\d.,]+)\s?%",
        "pct": r"PCT\s*:\s*([\d.,]+)\s?%"
    }

    # Initialize the result dictionary
    result = {}

    # Apply each regex pattern to the text and add matches to the result dictionary
    for key, pattern in patterns.items():
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            value = match.group(1).strip()
            result[key] = value

    return result

# API to extract text from an image using Tesseract
@app.route('/extract_text', methods=['POST'])
def extract_text():
    # Get image from the request
    file = request.files['image'].read()
    np_img = np.frombuffer(file, np.uint8)
    img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

    # Convert the image to grayscale for better OCR accuracy
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    gray = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]

    # Extract text using Tesseract
    text = pytesseract.image_to_string(gray)

    # Send the extracted text to the second API for parsing
    ner_api_url = 'http://127.0.0.1:5001/extract_test_data'  # Adjust to the correct IP and port of the second API
    response = requests.post(ner_api_url, json={"extracted_text": text})

    # Check for successful response
    if response.status_code == 200:
        return jsonify({"extracted_data": response.json()})
    else:
        return jsonify({"error": "Error in extracting test data"}), 400


# API to extract structured test data from the OCR text
@app.route('/extract_test_data', methods=['POST'])
def extract_test_data():
    # Get extracted text from the request
    extracted_text = request.json.get('extracted_text', '')

    if not extracted_text:
        return jsonify({'error': 'No extracted text provided'}), 400

    # Parse the extracted text and get the structured data
    structured_data = parse_ocr_text(extracted_text)

    # Return the structured data as JSON
    return jsonify(structured_data)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
