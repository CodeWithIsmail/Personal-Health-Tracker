import re
import json

def parse_ocr_text(text):
    # Define regex patterns to capture various metrics
    patterns = {
        "haemoglobin": r"Haemoglobin\s+([\d.]+)\s+g/dL",
        "esr": r"ESR \(Westergren Method\)\s+(\d+)\s+mm in Ist hr",
        "wbc_total": r"Total WBC Count\s+([\d.]+)\s+X 10\^9/uL",
        "neutrophils": r"Neutrophils\s+(\d+)\s?%",
        "lymphocytes": r"Lymphocytes\s+(\d+)\s?%",
        "monocytes": r"Monocytes\s+(\d+)\s?%",
        "eosinophils": r"Eosinophils\s+(\d+)\s?%",
        "basophils": r"Basophils\s+(\d+)\s?%",
        "rbc_total": r"Total RBC Count\s+([\d.]+)\s+X 10\^12/uL",
        "hct_pcv": r"HCT/PCV\s+([\d.]+)\s?%",
        "mcv": r"MCV\s+([\d.]+)\s?fL",
        "mch": r"MCH\s+([\d.]+)\s?pg",
        "mchc": r"MCHC\s+([\d.]+)\s?g/dL",
        "rdw_cv": r"RDW-CV\s+([\d.]+)\s?%",
    }

    # Initialize the result dictionary
    result = {}

    # Apply each regex pattern to the text and add matches to the result dictionary
    for key, pattern in patterns.items():
        match = re.search(pattern, text)
        if match:
            result[key] = match.group(1)

    return result

# Example usage
extracted_text = """
Delta Health Care,
Rampura Limited
Delivery Date: 11-09-2024 Age: 59 Years
Patient Name: Md. Iman Ali Date: 11-09-2024 Sex: Male
Ref. By: Dr. Md. Rubayet Siraj, MBBS, DTCD. Specimen: Blood
Patient ID: 103239
Haematology Report
Estimations are carried out by SYSMEX XN-350 Automated Haematology Analyzer
Haemoglobin 11.8 g/dL
ESR (Westergren Method) 20 mm in Ist hr
Total WBC Count 14.00 X 10^9/uL
Neutrophils 70 %
Lymphocytes 22%
Monocytes 06 %
Eosinophils 02 %
Basophils 00 %
Total RBC Count 4.8 X 10^12/uL
HCT/PCV 33.8 %
MCV 84.5 fL
MCH 29.5 pg
MCHC 34.9 g/dL
RDW-CV 13 %
"""

# Parse the extracted text
structured_data = parse_ocr_text(extracted_text)

# Convert to JSON format
json_data = json.dumps(structured_data, indent=4)
print(json_data)


