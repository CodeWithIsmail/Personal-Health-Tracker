import 'package:flutter/material.dart';
import 'package:personal_health_tracker/ImportAll.dart';
import 'package:personal_health_tracker/custom/CustomRadioSelectionTextField.dart';
import 'package:personal_health_tracker/custom/CustomTextField.dart';

class Manualreport extends StatefulWidget {
  @override
  State<Manualreport> createState() => _ManualreportState();
}

class _ManualreportState extends State<Manualreport> {

  DateTime? reportDate;
  DateTime? reportCollectionDate;

  final TextEditingController reportDateController = TextEditingController();
  final TextEditingController reportCollectionDateController = TextEditingController();
  final TextEditingController testController = TextEditingController();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<String> testNames = [];
  String? selectedTest;
  List<String> filteredTestNames = [];
  OverlayEntry? dropdownOverlay;

  @override
  void initState() {
    super.initState();
    fetchTestNames();
    print("Fetching Test Names...");
  }

  Future<void> fetchTestNames() async {
    List fetchedTestNames = await getTestNames();
    setState(() {
      testNames = List<String>.from(fetchedTestNames); // Ensure the data is a List<String>
      filteredTestNames = List.from(testNames); // Initialize filtered list
    });
  }

  Future<List> getTestNames() async {
    QuerySnapshot snapshot =
    await firebaseFirestore.collection('test_collection').get();

    List<String> testNames = [];

    for (var doc in snapshot.docs) {
      // Ensure test_names is a List and flatten its contents
      if (doc['test_names'] is List<dynamic>) {
        testNames.addAll(List<String>.from(doc['test_names'])); // Add individual strings to the list
      } else if (doc['test_names'] is String) {
        testNames.add(doc['test_names']); // Handle case where test_names is a single string
      }
    }

    for(var doc in testNames){
      print(doc);
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
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Patient's Name",
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Age',
                        ),
                      ),
                      SizedBox(height: 16),
                      Customradioselectiontextfield(),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => selectDate(context, (pickedDate) {
                          setState(() {
                            reportDate = pickedDate;
                            reportDateController.text =
                            "${reportDate!.day}/${reportDate!.month}/${reportDate!.year}";
                          });
                        }),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: reportDateController,
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
                              labelText: 'Report Date',
                              hintText: reportDate != null
                                  ? "${reportDate!.day}/${reportDate!.month}/${reportDate!.year}"
                                  : 'Select Report Date',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
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
                      SizedBox(height: 16),
                      // Dropdown Selector
                      DropdownButtonFormField<String>(
                        value: selectedTest,
                        hint: Text('Select a test'),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTest = newValue;
                          });
                        },
                        items: testNames.map((String testName) {
                          return DropdownMenuItem<String>(
                            value: testName,
                            child: Text(testName),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: fetchTestNames,
                              child: Text('Add',style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal),),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: Size(120, 40)
                            )
                          ),
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
