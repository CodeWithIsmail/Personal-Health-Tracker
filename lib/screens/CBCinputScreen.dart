import '../ImportAll.dart';

class CBCinputScreen extends StatefulWidget {
  CBC cbc;

  CBCinputScreen(this.cbc);

  @override
  State<CBCinputScreen> createState() => _CBCinputScreenState();
}

class _CBCinputScreenState extends State<CBCinputScreen> {
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
