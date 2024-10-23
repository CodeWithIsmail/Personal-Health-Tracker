# Personal Health Tracker using Automated Report Scanning

## Motivation: 
In today’s busy world, being regularly updated about personal health is a challenge for most people. But currently the ability to understand, enable early detection and preventative health care and track personal health information is more important than ever. The motivation behind developing this system stems from the realization that people often ignore to maintain their medical records, and this habit can have serious consequences for their health. Unfortunately, people often lose their reports, which can cause delays in the detection of major health issues. Additionally, individuals miss out on the opportunity to track their own health trends and become aware about their health condition. Besides using this application in personal 
health monitoring, this application can also be used to efficiently manage health care systems globally and locally.

## Project Description:
The Personal Health Tracker is a comprehensive mobile application designed to help users actively manage and monitor their health with ease and efficiency. The app allows users to upload images of their medical diagnostic reports (text and numeric value based test report e.g., blood test), which are then automatically processed to extract important health data such as test names, values, and results by using Optical Character Recognition (OCR) technology. This automation reduces the need for manual data entry, ensuring more accurate and better user experience for users.

Once the data is extracted, the app provides personalized health insights, summarizing the report in a simple, understandable format. It helps users interpret their diagnostic results, identify health trends over time and provides visual analysis of health records over time. Thus the Personal Health Tracker empowers users to stay updated about their health status and make data-driven decisions.

In addition, the app serves as a personal health assistant by rapidly reminding users to update their health data on a regular basis. The app will notify users to seek treatment from a healthcare professional to improve their condition if unexpected values or patterns are detected in a report. Regular interaction on the application encourages users to develop a proactive approach towards maintaining their health, raising awareness about personal health conditions, facilitating early detection and avoidance of potential health issues.

Along with monitoring an individual's health, the app provides a news and recommendation section where users may get updates on healthier lifestyle techniques, healthcare news, and general health advice.

## Technology and Tools:
o Image Processing: Use some Image processing libraries (e.g., OpenCV) to make the data extraction process more accurate.

o OCR Module: Integrate a reliable OCR library (e.g., Google ML Kit, Tesseract) for text extraction from medical reports.

o Database: Use Firebase for real-time, scalable data storage, handling both extracted data and historical medical records.

o Back-end deploy: Deploy back-end functionalities on a cloud server (e.g., Render).

o Statistical Analysis: Implement algorithms or integrate libraries (e.g. NumPy) to perform statistical comparisons and generate health insights.

o Mobile Development Framework: Use Flutter for cross-platform app development, ensuring seamless image capturing from camera or gallery using Flutter package (e.g., Image Picker)