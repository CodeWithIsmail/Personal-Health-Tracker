from flask import Flask, request, jsonify
import cv2
import pytesseract
import numpy as np

app = Flask(__name__)


@app.route('/extract_text', methods=['POST'])
def extract_text():
    file = request.files['image'].read()
    np_img = np.frombuffer(file, np.uint8)
    img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    gray = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]

    text = pytesseract.image_to_string(gray)

    return jsonify({'extracted_text': text})

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0',port=5000)
