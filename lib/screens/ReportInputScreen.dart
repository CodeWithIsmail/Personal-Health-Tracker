import '../ImportAll.dart';

class ReportInputScreen extends StatefulWidget {
  final Map<String, String> testData;

  ReportInputScreen({required this.testData});

  @override
  _ReportInputScreenState createState() => _ReportInputScreenState();
}

class _ReportInputScreenState extends State<ReportInputScreen> {
  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = {};
    widget.testData.forEach((testName, value) {
      controllers[testName] = TextEditingController(text: value);
    });
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report Input")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: controllers.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 20,
                      ),
                      labelText: entry.key, // Test name
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16),
          CustomButtonGestureDetector(
            "Submit",
            100,
            50,
            Color(0xFF355C7D),
            Colors.white,
            20,
            () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
