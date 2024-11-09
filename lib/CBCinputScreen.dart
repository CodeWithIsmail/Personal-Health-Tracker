import 'dart:convert';

Map<String, String> parseOcrText(String text) {
  // Define regex patterns to capture various metrics
  final Map<String, String> patterns = {
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
    "mchc": r"MCHC\s*:\s*([\d.,]+)\s*g/dL",
    "rdw_cv": r"RDW-CV\s*:\s*([\d.,]+)\s?%",
    "rdw_sd": r"RDW-SD\s*:\s*([\d.,]+)\s?fL",
    "platelet_total":
        r"Total Platelet Count\s*:\s*([\d.,]+(?:\s*X\s*10\^?\d+)?)/uL",
    "mpv": r"MPV\s*:\s*([\d.,]+)\s?fL",
    "pdw": r"PDW\s*:\s*([\d.,]+)\s?fL",
    "p_lcr": r"P-LCR\s*:\s*([\d.,]+)\s?%",
    "pct": r"PCT\s*:\s*([\d.,]+)\s?%"
  };

  // Initialize the result map
  final Map<String, String> result = {};

  // Apply each regex pattern to the text and add matches to the result map
  patterns.forEach((key, pattern) {
    final regExp = RegExp(pattern, caseSensitive: false);
    final match = regExp.firstMatch(text);
    if (match != null) {
      result[key] = match.group(1)!.trim();
    }
  });

  return result;
}

void CBC(String extractedText) {
  // Example OCR extracted text

  Map<String, String> structuredData = parseOcrText(extractedText);

  // Convert to JSON format
  String jsonData = jsonEncode(structuredData);
  print(jsonData);
}
