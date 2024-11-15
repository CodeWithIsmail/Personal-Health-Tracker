import '../ImportAll.dart';

class CBCinputScreen extends StatefulWidget {
  CBC cbc;

  CBCinputScreen(this.cbc);

  @override
  State<CBCinputScreen> createState() => _CBCinputScreenState();
}

class _CBCinputScreenState extends State<CBCinputScreen> {
  // TextEditingController HaemoglobinController = new TextEditingController();
  // TextEditingController ESRController = new TextEditingController();
  // TextEditingController WBCController = new TextEditingController();
  // TextEditingController NeutrophilsController = new TextEditingController();
  // TextEditingController LymphocytesController = new TextEditingController();
  // TextEditingController MonocytesController = new TextEditingController();
  // TextEditingController EosinophilsController = new TextEditingController();
  // TextEditingController BasophilsController = new TextEditingController();
  // TextEditingController RBCController = new TextEditingController();
  // TextEditingController HCT_PCVController = new TextEditingController();
  // TextEditingController MCVController = new TextEditingController();
  // TextEditingController MCHController = new TextEditingController();
  // TextEditingController MCHCController = new TextEditingController();
  // TextEditingController RDW_CVController = new TextEditingController();
  // TextEditingController RDW_SDController = new TextEditingController();
  // TextEditingController PlateletController = new TextEditingController();
  // TextEditingController MPVController = new TextEditingController();
  // TextEditingController PDWController = new TextEditingController();
  // TextEditingController P_LCRController = new TextEditingController();
  // TextEditingController PCTController = new TextEditingController();

  final Map<String, TextEditingController> controllers = {};
  final List<String> testNames = [
    "Haemoglobin",
    "ESR",
    "WBC",
    "Neutrophils",
    "Lymphocytes",
    "Monocytes",
    "Eosinophils",
    "Basophils",
    "RBC",
    "HCT_PCV",
    "MCV",
    "MCH",
    "MCHC",
    "RDW_CV",
    "RDW_SD",
    "Platelet",
    "MPV",
    "PDW",
    "P_LCR",
    "PCT",
  ];

  @override
  void initState() {
    // TODO: implement initState
    // HaemoglobinController.text = widget.cbc.Haemoglobin;
    // ESRController.text = widget.cbc.ESR;
    // WBCController.text = widget.cbc.WBC;
    // NeutrophilsController.text = widget.cbc.Neutrophils;
    // LymphocytesController.text = widget.cbc.Lymphocytes;
    // MonocytesController.text = widget.cbc.Monocytes;
    // EosinophilsController.text = widget.cbc.Eosinophils;
    // BasophilsController.text = widget.cbc.Neutrophils;
    // RBCController.text = widget.cbc.Neutrophils;
    // HCT_PCVController.text = widget.cbc.Neutrophils;
    // MCVController.text = widget.cbc.MCV;
    // MCHController.text = widget.cbc.MCH;
    // MCHCController.text = widget.cbc.MCHC;
    // RDW_CVController.text = widget.cbc.RDW_CV;
    // RDW_SDController.text = widget.cbc.RDW_SD;
    // PlateletController.text = widget.cbc.Platelet;
    // MPVController.text = widget.cbc.MPV;
    // PDWController.text = widget.cbc.PDW;
    // P_LCRController.text = widget.cbc.P_LCR;
    // PCTController.text = widget.cbc.PCT;
    super.initState();

    final cbcMap = widget.cbc.toMap();
    for (var testName in testNames) {
      controllers[testName] = TextEditingController(
        text: cbcMap[testName] ?? "",
      );
    }
  }

  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: testNames.map((testName) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: InputBox(testName, controllers[testName]!),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
    //   Scaffold(
    //   body: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: [
    //             InputBox("Haemoglobin", HaemoglobinController),
    //             SizedBox(height: 10),
    //             InputBox("ESR", ESRController),
    //             SizedBox(height: 10),
    //             InputBox("WBC", WBCController),
    //             SizedBox(height: 10),
    //             InputBox("Neutrophils", NeutrophilsController),
    //             SizedBox(height: 10),
    //             InputBox("Lymphocytes", LymphocytesController),
    //             SizedBox(height: 10),
    //             InputBox("Monocytes", MonocytesController),
    //             SizedBox(height: 10),
    //             InputBox("Eosinophils", EosinophilsController),
    //             SizedBox(height: 10),
    //             InputBox("Basophils", BasophilsController),
    //             SizedBox(height: 10),
    //             InputBox("RBC", RBCController),
    //             SizedBox(height: 10),
    //             InputBox("HCT_PCV", HCT_PCVController),
    //             SizedBox(height: 10),
    //             InputBox("MCV", MCVController),
    //             SizedBox(height: 10),
    //             InputBox("MCH", MCHController),
    //             SizedBox(height: 10),
    //             InputBox("MCHC", MCHCController),
    //             SizedBox(height: 10),
    //             InputBox("RDW_CV", RDW_CVController),
    //             SizedBox(height: 10),
    //             InputBox("RDW_SD", RDW_SDController),
    //             SizedBox(height: 10),
    //             InputBox("Platelet", PlateletController),
    //             SizedBox(height: 10),
    //             InputBox("MPV", MPVController),
    //             SizedBox(height: 10),
    //             InputBox("PDW", PDWController),
    //             SizedBox(height: 10),
    //             InputBox("P_LCR", P_LCRController),
    //             SizedBox(height: 10),
    //             InputBox("PCT", PCTController),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class InputBox extends StatelessWidget {
  String testName;
  TextEditingController controller;

  InputBox(this.testName, this.controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          testName,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10),
        Expanded(
          child: CustomTextField(
              testName, false, controller, TextInputType.number),
        ),
      ],
    );
  }
}
