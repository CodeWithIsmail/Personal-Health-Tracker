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
| F) Delta Health Care,
i Rampura Limited

~ Delivery Date: 1 09- 2024 Age: 59 Years

patient Name: Md.Iman Ali Date: 11-09-2024 Sex: Male

Ref. By: Dr.Md.Rubayet Siraj, MBBS, DTCD. Specimen: Blood |

— we ee en meee

(patient ID: 103239

/

Haematology Report !

Estimations are carried out bj by SYSMEX XN-350 Automated Haematology Analyzer

Result Reference Values y
M: 13 - 17, F: 11.5 - 16 g/dL :   
M: 0-10, F:0- 15 mm in ist hr     

Test

Haemoglobin 11.8 g/dL

ESR (Westergren Method) 20 mm in Ist hr
Total Count

Total WBC Count
Differential Count

14.00 X 1049/uL 4.5 - 11.0 X 1049/uL

Neutrophils 70 % Child ( 25 - 66 %), Adult (40 - 75 %)
Lymphocytes 22% Child ( 25 - 62 %), Adult (20 - 50 %)
Monocytes 06 % Child (02 - 07 %), Adult (02 - 10 %)
Eosinophils 02 % Child (00 - 03 %), Adult (01 - 06 %)
Basophils 00 % 00 - 01%
RBC Panel
Total RBC Count 04 X 10412/uL 4.5 -5.5 X 10412/uL
HCT/PCV 33.8 % 40-54%
Mcv 84.5 fL 80 - 96 fL
MCH 29.5 pg 27 - 32 pg
MCHC 34.9 g/dL 31-35 g/dL
RDW-CV 13 % 11.6 - 14.0%
RDW-SD 40.2 fL 39 - 46 fL
PLT Panel
Total Platelet Count 285 X 1049/uL 150 - 450 X 1049/uL
MPV 9.4 fl 9-13 fL
PDW 9.7 fL 9-17 FL
Comm : Mi : . .
ents: Mild normocytic normochromic anaemia with neutrophilic leukocytosis.


By
Checked By ; pay Consul 1p

Me. Shakhawat Hossain DR. NASRIN JAHAN
PS (Brac hs aa ot AT (Lab) MBBS, DCP, MD (Lab. Medicine)

5 In-Cha
Delta Heal Cc Assistant Professor
we. Rampur Ltd Department of Laboratory Medicine

BSMMU, Shahbag Dhaka.
i CRL
altararoramnitra @amail com. www.tacebook.com/DH

VA, West Rampura, DIT Road, Dhaka-1219, Phone: 02-58315965.kR NITZERROAIAE Enna

"""

# Parse the extracted text
structured_data = parse_ocr_text(extracted_text)

# Convert to JSON format
json_data = json.dumps(structured_data, indent=4)
print(json_data)


