from flask import Flask, request, jsonify
import cv2
import pytesseract
import numpy as np
import re
from rapidfuzz import process, fuzz
app = Flask(__name__)


def parse_ocr_text(text):

    patterns = {
        "Haemoglobin": r"Haemoglobin\s*[:\-]?\s*([\d.,]+)\s*g/dL",
        "ESR": r"ESR\s*\(Westergren Method\)\s*[:\-]?\s*(\d+)\s*mm",
        "WBC": r"Total WBC Count\s*(?:Differential Count\s*)?([\d.,]+(?:\s*[xX]\s*\d+)?(?:\s*10\^?\d+)?)\/uL",
        "Neutrophils": r"Neutrophils\s*[:\-]?\s*(\d+)\s?%",
        "Lymphocytes": r"Lymphocytes\s*[:\-]?\s*(\d+)\s?%",
        "Monocytes": r"Monocytes\s*[:\-]?\s*(\d+)\s?%",
        "Eosinophils": r"Eosinophils\s*[:\-]?\s*(\d+)\s?%",
        "Basophils": r"Basophils\s*[:\-]?\s*(\d+)\s?%",
        "RBC": r"Total RBC Count\s*[:\-]?\s*([\d.,]+(?:\s*[xX]\s*\d+)?(?:\s*10\^?\d+)?)\/uL",
        "HCT_PCV": r"HCT\/PCV\s*[:\-]?\s*([\d.,]+)\s?%",
        "MCV": r"MCV\s*[:\-]?\s*([\d.,]+)\s?fL",
        "MCH": r"MCH\s*[:\-]?\s*([\d.,]+)\s?pg",
        "MCHC": r"MCHC\s*[:\-]?\s*([\d.,]+)\s?g/dL",
        "RDW_CV": r"RDW-CV\s*[:\-]?\s*([\d.,]+)\s?%",
        "RDW_SD": r"RDW-SD\s*[:\-]?\s*([\d.,]+)\s?fL",
        "Platelet": r"Total Platelet Count\s*[:\-]?\s*([\d.,]+(?:\s*[xX]\s*\d+)?(?:\s*10\^?\d+)?)\/uL",
        "MPV": r"MPV\s*[:\-]?\s*([\d.,]+)\s?fL",
        "PDW": r"PDW\s*[:\-]?\s*([\d.,]+)\s?fL",
        "P_LCR": r"P-LCR\s*[:\-]?\s*([\d.,]+)\s?%",
        "PCT": r"PCT\s*[:\-]?\s*([\d.,]+)\s?%"
    }

    result = {}
    cleaned_text = re.sub(r'\s+', ' ', text)  # Normalize whitespace

    # Apply each pattern to the cleaned text
    for key, pattern in patterns.items():
        match = re.search(pattern, cleaned_text, re.IGNORECASE)

        if match:
            value = match.group(1).strip()

            # Check for scientific notation misread (e.g., X 1049)
            if re.search(r'\b[xX]\s*(\d{4,})\b', value):
                base, exponent_part = re.split(r'\s*[xX]\s*', value)
                # Ignore first 3 digits and convert the rest to an integer
                exponent = int(exponent_part[3:])
                value = str(int(float(base) * (10 ** exponent)))
            elif 'x' in value.lower():
                # Handles standard scientific format like "285 x 10^9"
                base, exponent = re.split(r'\s*[xX]\s*10\^?', value)
                value = str(int(float(base) * (10 ** int(exponent))))

            result[key] = value
            print(f"Match found for {key}: {value}")
        else:
            print(f"No match for {key}")

    print("Structured Data Result:", result)
    return result


# Combined endpoint to perform OCR and NER

@app.route('/process_image', methods=['POST'])
def process_image():
    # Step 1: Receive the image and perform OCR
    file = request.files['image'].read()
    np_img = np.frombuffer(file, np.uint8)
    img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    gray = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
    text = pytesseract.image_to_string(gray)

    # Step 2: Perform NER on the extracted text

    text = re.sub(r'\s+', ' ', text)  # Remove excessive whitespace
    text = text.replace('\n', ' ')    # Remove line breaks
    # Convert to ASCII, ignore special chars
    text = text.encode("ascii", "ignore").decode()

    print("OCR Extracted Text:", text)
    structured_data = parse_ocr_text(text)

    # Return both extracted text and structured data
    return jsonify({
        'extracted_text': text,
        'structured_data': structured_data
    })


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
