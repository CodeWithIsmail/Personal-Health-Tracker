from flask import Flask, request, jsonify
import cv2
import pytesseract
import numpy as np

app = Flask(__name__)

# Set the Tesseract executable path (if needed)
# pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

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

    # print(text)

    return jsonify({'extracted_text': text})

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0',port=5000)
