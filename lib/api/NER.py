from flask import Flask, request, jsonify
import re
import json

app = Flask(__name__)

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
