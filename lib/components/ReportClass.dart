import '../ImportAll.dart';

class CBC {
  String Haemoglobin;
  String ESR;
  String WBC;
  String Neutrophils;
  String Lymphocytes;
  String Monocytes;
  String Eosinophils;
  String Basophils;
  String RBC;
  String HCT_PCV;
  String MCV;
  String MCH;
  String MCHC;
  String RDW_CV;
  String RDW_SD;
  String Platelet;
  String MPV;
  String PDW;
  String P_LCR;
  String PCT;

  CBC(
      this.Haemoglobin,
      this.ESR,
      this.WBC,
      this.Neutrophils,
      this.Lymphocytes,
      this.Monocytes,
      this.Eosinophils,
      this.Basophils,
      this.RBC,
      this.HCT_PCV,
      this.MCV,
      this.MCH,
      this.MCHC,
      this.RDW_CV,
      this.RDW_SD,
      this.Platelet,
      this.MPV,
      this.PDW,
      this.P_LCR,
      this.PCT);

  factory CBC.fromMap(Map<String, dynamic> map) {
    return CBC(
      map['Haemoglobin'] ?? '',
      map['ESR'] ?? '',
      map['WBC'] ?? '',
      map['Neutrophils'] ?? '',
      map['Lymphocytes'] ?? '',
      map['Monocytes'] ?? '',
      map['Eosinophils'] ?? '',
      map['Basophils'] ?? '',
      map['RBC'] ?? '',
      map['HCT_PCV'] ?? '',
      map['MCV'] ?? '',
      map['MCH'] ?? '',
      map['MCHC'] ?? '',
      map['RDW_CV'] ?? '',
      map['RDW_SD'] ?? '',
      map['Platelet'] ?? '',
      map['MPV'] ?? '',
      map['PDW'] ?? '',
      map['P_LCR'] ?? '',
      map['PCT'] ?? '',
    );
  }

  @override
  String toString() {
    return 'CBC{Haemoglobin: $Haemoglobin, ESR: $ESR, WBC: $WBC, Neutrophils: $Neutrophils, Lymphocytes: $Lymphocytes, Monocytes: $Monocytes, Eosinophils: $Eosinophils, Basophils: $Basophils, RBC: $RBC, HCT_PCV: $HCT_PCV, MCV: $MCV, MCH: $MCH, MCHC: $MCHC, RDW_CV: $RDW_CV, RDW_SD: $RDW_SD, Platelet: $Platelet, MPV: $MPV, PDW: $PDW, P_LCR: $P_LCR, PCT: $PCT}';
  }

  Map<String, String> toMap() {
    return {
      "Haemoglobin": Haemoglobin,
      "ESR": ESR,
      "WBC": WBC,
      "Neutrophils": Neutrophils,
      "Lymphocytes": Lymphocytes,
      "Monocytes": Monocytes,
      "Eosinophils": Eosinophils,
      "Basophils": Basophils,
      "RBC": RBC,
      "HCT_PCV": HCT_PCV,
      "MCV": MCV,
      "MCH": MCH,
      "MCHC": MCHC,
      "RDW_CV": RDW_CV,
      "RDW_SD": RDW_SD,
      "Platelet": Platelet,
      "MPV": MPV,
      "PDW": PDW,
      "P_LCR": P_LCR,
      "PCT": PCT,
    };
  }
}
