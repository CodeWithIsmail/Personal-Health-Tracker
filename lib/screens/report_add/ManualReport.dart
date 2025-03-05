import 'package:personal_health_tracker/ImportAll.dart';
import '../../custom/CustomDropDown.dart';
import 'package:http/http.dart' as http;

class Manualreport extends StatefulWidget {
  @override
  State<Manualreport> createState() => _ManualreportState();
}

class _ManualreportState extends State<Manualreport> {
  DateTime? reportDate;
  DateTime? reportCollectionDate;

  final IP = "10.100.202.129:5000";//ip:5000

  final TextEditingController reportDateController = TextEditingController();
  final TextEditingController reportCollectionDateController = TextEditingController();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController patientAgeController = TextEditingController();
  Map<int, TextEditingController> testValueControllers = {};

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<String> testNames = [];
  List<String> filteredTestNames = [];
  String? selectedTest;
  List<Widget> testTextFields = [];
  List<Widget> additionalTestDropdowns = [];
  List<String?> selectedTests = [null];


  @override
  void initState() {
    super.initState();
    fetchTestNames();
    print("Fetching Test Names...");
  }

  Future<void> fetchTestNames() async {
    List fetchedTestNames = await getTestNames();
    setState(() {
      testNames = List<String>.from(
          fetchedTestNames); // Ensure the data is a List<String>
      filteredTestNames = List.from(testNames); // Initialize filtered list
    });
  }

  Future<List> getTestNames() async {
    QuerySnapshot snapshot =
    await firebaseFirestore.collection('test_collection').get();

    List<String> testNames = [];

    for (var doc in snapshot.docs) {
      if (doc['test_names'] is List<dynamic>) {
        testNames.addAll(List<String>.from(doc['test_names']));
      } else if (doc['test_names'] is String) {
        testNames.add(doc['test_names']);
      }
    }

    return testNames;
  }

  Future<void> selectDate(
      BuildContext context, Function(DateTime?) DatePicker) async {
    final DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null && picked != reportDate) {
      DatePicker(picked);
    }
  }

  Widget DropDownSelector(int index) {
    return CustomDropdown<String>(
      options: testNames, // Pass the list of test names
      selectedItem: selectedTests[index], // The currently selected test
      onChanged: (String? newValue) {
        setState(() {
          selectedTests[index] = newValue; // Update the selected test
        });
      },
      hint: 'Select a test', // Hint text for the dropdown
    );
  }


  Widget SelectedTestInput(int index) {

    testValueControllers.putIfAbsent(index, () => TextEditingController());

    return Column(
      children: [
        Row(
          children: [
            Text(
              //selectedTest!,
              selectedTests[index]!,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
            ),
            SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedTests[index] = null;
                  testValueControllers.remove(index);
                });
              },
              child: Text('Change'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[400],
                foregroundColor: Colors.black87,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: TextField(
                controller: testValueControllers[index],
                keyboardType: TextInputType.number,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  hintText: '0.0',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green,width: 2),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedTests.removeAt(index);
                    testValueControllers.remove(index);
                    if (selectedTests.isEmpty) {
                      selectedTests.add(null);
                    }
                  });
                },
                icon: Icon(
                  Icons.cancel,
                  size: 40,
                ))
          ],
        ),
      ],
    );
  }

  Future<void> saveManualReport() async {
    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
    final username = authProvider.currentUserName ?? "";
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not logged in');
      return;
    }

    final String userId = user.uid; // Get the logged-in user's UID
    //final String reportId = firebaseFirestore.collection('manual_report').doc().id; // Generate a unique report ID

    // Prepare the data to be stored
    Map<String, dynamic> reportData = {
      'userId': username,
      'reportCollectionDate': reportCollectionDate?.toIso8601String(),
      'tests': selectedTests
          .where((test) => test != null) // Exclude null entries
          .map((test){
        int index = selectedTests.indexOf(test);
        double testValue = double.tryParse(testValueControllers[index]?.text ?? '0.0') ?? 0.0;
        return {
          'testName': test,
          'value': testValue,
        };
      })
          .toList(),
    };

    try {
      // Save the report data in the manual_report collection
      // await firebaseFirestore.collection('manual_report').doc(reportId).set(reportData);
      final response = await http.post(
        Uri.parse('http://${IP}/api/reports/store-report'), // Replace with your server's IP or domain
        headers: {'Content-Type': 'application/json'},
        body: json.encode(reportData),
      );
      print(json.encode(reportData));

      if(response != null){
        print("Response received");
        print(response.body);
      }
      if (response.statusCode == 200) {
        print('Report saved successfully!');
        resetScreen();
      } else {
        print('Failed to save report: ${response.statusCode}');
      }

    } catch (e) {
      print('Error saving report: $e');
    }
  }


  void resetScreen() {
    setState(() {
      reportCollectionDateController.clear();
      reportCollectionDate = null;
      selectedTests = [null];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'HealthTracker',
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.check),
              ),
            )
          ],
          backgroundColor: Colors.green[300],
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => selectDate(context, (pickedDate) {
                          setState(() {
                            reportCollectionDate = pickedDate;
                            reportCollectionDateController.text =
                            "${reportCollectionDate!.day}/${reportCollectionDate!.month}/${reportCollectionDate!.year}";
                          });
                        }),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: reportCollectionDateController,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.green,
                                ),
                              ),
                              prefixIconConstraints:
                              BoxConstraints(maxWidth: 40, maxHeight: 24),
                              labelText: 'Report Collection Date',
                              hintText: reportCollectionDate != null
                                  ? "${reportCollectionDate!.day}/${reportCollectionDate!.month}/${reportCollectionDate!.year}"
                                  : 'Select Collection Date',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Select Test'),
                      Column(
                        children: List.generate(selectedTests.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0), // Add spacing here
                            child: selectedTests[index] == null
                                ? DropDownSelector(index)
                                : SelectedTestInput(index),
                          );
                        }),
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              selectedTests.add(null);
                            });
                          },
                          child: Text(
                            '+ Add Another Test',
                            style: TextStyle(color: Colors.green),
                          ),
                          style: TextButton.styleFrom(
                            side: BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed:  () async {
                                await saveManualReport();
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(120, 40))),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}