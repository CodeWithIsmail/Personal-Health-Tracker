import '../ImportAll.dart';

class ReportInputScreen extends StatefulWidget {
  final Map<String, String> testData;

  ReportInputScreen({required this.testData});

  @override
  _ReportInputScreenState createState() => _ReportInputScreenState();
}

class _ReportInputScreenState extends State<ReportInputScreen> {
  Timestamp? timestamp;
  late DateTime selected;
  late Map<String, TextEditingController> controllers;
  TextEditingController dayController = new TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selected = DateTime.now();
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

  Future<void> saveTestDataToDB() async {
    setState(() {
      isLoading = true;
    });
    String? uemail = await FirebaseAuth.instance.currentUser?.email;
    String? uname = uemail?.substring(0, uemail.indexOf('@'));

    if (uname != null) {
      try {
        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('report_data').doc(uname);
        DocumentSnapshot snapshot = await documentRef.get();

        if (!snapshot.exists) {
          await documentRef.set(<String, dynamic>{});
        }

        for (var entry in controllers.entries) {
          String testName = entry.key;
          TextEditingController valueController = entry.value;

          Map<String, dynamic> newEntry = {
            "value": valueController.text,
            "timestamp": timestamp,
          };

          print("newentry: ${newEntry}");
          if (snapshot.exists &&
              (snapshot.data() as Map<String, dynamic>).containsKey(testName)) {
            await documentRef.update({
              testName: FieldValue.arrayUnion([newEntry]),
            });
          } else {
            await documentRef.set({
              testName: [newEntry],
            }, SetOptions(merge: true));
          }
        }
      } on Exception catch (e) {
        print("Failed to save data: $e");
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report Input")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: dayController,
              textAlignVertical: TextAlignVertical.center,
              readOnly: true,
              onTap: () async {
                DateTime? current = await showDatePicker(
                  context: context,
                  initialDate: selected,
                  firstDate: DateTime.now().subtract(Duration(days: 36500)),
                  // 100 years ago
                  lastDate: DateTime.now(),
                );

                if (current != null) {
                  selected = current;
                  timestamp = Timestamp.fromDate(selected);
                  dayController.text = DateFormat('dd-MMM-yy').format(current);
                  print('Timestamp: $timestamp');
                }
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                hintText: 'Test date',
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.deepPurple, width: 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.purpleAccent, width: 1),
                ),
              ),
            ),
          ),
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
          isLoading
              ? SpinKitFadingCircle(
                  color: Colors.deepPurple,
                  size: 50,
                )
              : CustomButtonGestureDetector(
                  "Submit",
                  100,
                  50,
                  Color(0xFF355C7D),
                  Colors.white,
                  20,
                  () async {
                    await saveTestDataToDB();
                    Navigator.pop(context);
                  },
                ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}