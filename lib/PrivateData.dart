import 'ImportAll.dart';

final GenerativeModel GeminiModel = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: GeminiApiKey,
);

const analyzeReportPrompt =
    "Analyze the following medical report in detail. Summarize the key findings, focusing on any abnormal test results that may require further investigation or medical attention. Identify any patterns or trends in the data that could indicate potential health concerns. Additionally, highlight any specific instructions, recommendations, or advice to the patient for follow-up care or lifestyle changes. Be thorough and ensure nothing important is overlooked.";

const String ocrPrompt = '''
You are analyzing a haematology report image. Extract all test names and their corresponding values, ensuring the values match the units used in the provided sample report. For scientific notation (e.g., \`14.00 x 10^9/uL\`), convert it to its full numeric form (e.g., \`14000000000\`).

**Predefined Test Names and Examples**:
- Haemoglobin
- ESR
- Total WBC Count
- Total RBC Count (Map from: "RBC" or "Total RBC")
- Platelet Count (Map from: "Platelet" or "Total Platelet Count")
- Neutrophils
- Lymphocytes
- Monocytes
- Eosinophils
- Basophils
- HCT/PCV
- MCV
- MCH
- MCHC
- RDW-CV
- RDW-SD
- MPV
- PDW
- P-LCR
- PCT

**Guidelines**:
1. Extract numeric values from the report and match them to the correct predefined test names.
2. Convert all values to the predefined units. If the input uses different units (e.g., g/ml vs g/dl), calculate and provide the value in the required unit. Use standard conversion formulas when needed.
3. Use the following units for each test:
   - Haemoglobin: g/dL
   - ESR: mm in 1st hr
   - WBC, RBC, Platelet Count: cells/uL
   - Neutrophils, Lymphocytes, Monocytes, Eosinophils, Basophils: %
   - HCT/PCV: %
   - MCV: fl
   - MCH: pg
   - MCHC: g/dL
   - RDW-CV: %
   - RDW-SD: fl
   - MPV, PDW: fl 
   - P-LCR, PCT: %
4. Convert values when necessary and exclude unit symbols in the output. For scientific notation (e.g., `4 x 10^12`), convert the value to its full numeric form (e.g., `4000000000000`).
5. Ignore any extra information such as comments or reference ranges.
6. If a value is missing for a test, output " ".
7. Ensure the output matches the exact format and structure shown in the **Sample Output** section.

**Sample Output**:
Haemoglobin: 11.8  
ESR: 20  
WBC: 14000000000  
Neutrophils: 70  
Lymphocytes: 22  
Monocytes: 6  
Eosinophils: 2  
Basophils: 0  
RBC: 4000000000000  
HCT/PCV: 33.8  
MCV: 84.5  
MCH: 29.5  
MCHC: 34.9  
RDW-CV: 13  
RDW-SD: 40.2  
Platelet: 285000000000  
MPV: 9.4  
PDW: 9.7  
P-LCR: 19.4  
PCT: 0.26
''';

const st="Haemoglobin";

const String generalPrompt = '''
You are analyzing a medical diagnostic report image. Extract all test names and their corresponding values (consider only these test which gives numerical value). For scientific notation (e.g., \`14.00 x 10^9/uL\`), convert it to its full numeric form (e.g., \`14000000000\`).

**Guidelines**:
1. Extract numeric values from the report and match them to the correct test names.
2. Convert values when necessary and exclude unit symbols in the output. For scientific notation (e.g., `4 x 10^12`), convert the value to its full numeric form (e.g., `4000000000000`).
5. Ignore any extra information such as comments or reference ranges.
6. If a value is missing for a test, just output " ".
7. Ensure the output matches the exact format and structure shown in the **Sample Output** section.

**Sample Output**:
$st: 11.8  

''';

String matchChecker='''
Here are two comma-separated string:

    Predefined Test Names: [insert your predefined names here]
    User Input Test Names: [insert user-inputted names here]

Your task is to:

    Map each user-input test name to the most relevant predefined test name based on similarity and context.
    If a user-input test name cannot be matched to any predefined test name, map it to itself.

Output Format:
[User Input Test Name] : [Mapped Predefined Test Name]

Example:
ESR (Westergren method) : ESR
CBC (Complete Blood Count) : CBC (Complete Blood Count)

Provide the mappings for all user-input test names in the specified format.

''';