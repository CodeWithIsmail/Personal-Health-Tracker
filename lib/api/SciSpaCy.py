import re
import json

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

# Example usage
extracted_text = """
Delta Health Care,
Rampura Limited
Patient ID: 103239 Delivery Date: 11-08-2024 Age: 59 Years
Patient Name: Md.Iman Ali Date: 22-09-2024 Sex: Male
Ref. By: Dr.Md. Aubayet Siraj, MBBS, DTCD Specimen: Blood
Haematology Report
Estimations are carried out by SYSMEX XN-350 Automated Haematology Analyzer
Test Result Reference Values
Haemoglobin: 11.8 g/dL M: 13 - 17, F: 11.5 - 16 g/dL
ESR (Westergren Method): 20 mm in 1st hr M: 0 - 10, F: 0 - 15 mm in 1st hr
Total Count
Total WBC Count: 14.00 X 10^9/uL 4.5 - 11.0 X 10^9/uL
Differential Count
Neutrophils: 70 % Child ( 25 - 66 %), Adult (40 - 75 %)
Lymphocytes: 22 % Child ( 25 - 62 %), Adult (20 - 50 %)
Monocytes: 06 % Child (02 - 07 %), Adult (02 - 10 %)
Eosinophils: 02 % Child (00 - 03 %), Adult (01 - 06 %)
Basophils: 00 % 00 - 01%
RBC Panel
Total RBC Count: 4 X 10^12/uL 4.5 - 5.5 X 10^12/uL
HCT/PCV: 33.8 % 40 - 54 %
MCV: 84.5 fL 80 - 96 fL
MCH: 29.5 pg 27 - 32 pg
MCHC: 34.9 g/dL 31 - 35 g/dL
RDW-CV: 13 % 11.6 - 14.0 %
RDW-SD: 40.2 fL 39 - 46 fL
PLT Panel
Total Platelet Count: 285 X 10^9/uL 150 - 450 X 10^9/uL
MPV: 9.4 fL 9 - 13 fL
PDW: 9.7 fL 9 - 17 fL
P-LCR: 19.4 % 13 - 43 %
PCT: 0.26 % <= 09 %
Blood Film: RBC: Normocytic normochromic.
WBC: Mature with increased total count and normal distribution.
Platelet: Adequate.
Comments: Mild normocytic normochromic anaemia with neutrophilic leukocytosis.
Checked By: Md. Shakawat Hossain, B.Sc (Biochemistry), D.M.T (Lab)
"""

# Parse the extracted text
structured_data = parse_ocr_text(extracted_text)

# Convert to JSON format
json_data = json.dumps(structured_data, indent=4)
print(json_data)
