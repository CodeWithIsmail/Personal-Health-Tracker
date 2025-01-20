import 'package:flutter/material.dart';
import 'package:personal_health_tracker/custom/CustomRadioSelectionTextField.dart';
import 'package:personal_health_tracker/custom/CustomTextField.dart';

class Manualreport extends StatefulWidget {
  @override
  State<Manualreport> createState() => _ManualreportState();
}

class _ManualreportState extends State<Manualreport> {
  List<Map<String, TextEditingController>> attributeControllers = [
    {
      'attribute': TextEditingController(), // Attribute Name
      'value': TextEditingController(), // Attribute Value
    },
  ];

  DateTime? reportDate;
  DateTime? reportCollectionDate;

  final TextEditingController reportDateController = TextEditingController();
  final TextEditingController reportCollectionDateController = TextEditingController();

  void addNewTextFields() {
    setState(() {
      attributeControllers.add({
        'attribute': TextEditingController(),
        'value': TextEditingController(),
      });
    });
  }

  void removeTextFields(int index) {
    setState(() {
      attributeControllers.removeAt(index);
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HealthTracker',
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xffaa4b6b),
            Color(0xff6b6b83),
            Color(0xff3b8d99),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    reportDateController.text = "${reportDate!.day}/${reportDate!.month}/${reportDate!.year}";
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
                          color: Colors.purple,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                          maxWidth: 40,
                          maxHeight: 24
                      ),
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
                    reportCollectionDateController.text =  "${reportCollectionDate!.day}/${reportCollectionDate!.month}/${reportCollectionDate!.year}";
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
                          color: Colors.deepPurple,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        maxWidth: 40,
                        maxHeight: 24
                      ),
                      labelText: 'Report Collection Date',
                      hintText: reportCollectionDate != null
                          ? "${reportCollectionDate!.day}/${reportCollectionDate!.month}/${reportCollectionDate!.year}"
                          : 'Select Collection Date',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Report Attributes'),
              SizedBox(height: 16),
               ...attributeControllers.map((pair) {
                int index = attributeControllers.indexOf(pair);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      // Attribute Name TextField
                      Expanded(
                          child: CustomTextField('Attribute Name', false,
                              pair['attribute']!, TextInputType.text)),
                      SizedBox(width: 10),
                      // Attribute Value TextField
                      Expanded(
                          child: CustomTextField('Value', false, pair['value']!,
                              TextInputType.number)),
                      // Delete Button
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.purple),
                        onPressed: () => removeTextFields(
                            index), // Remove the text fields at this index
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewTextFields, // Add a new pair of text fields
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    for (var pair in attributeControllers) {
      pair['attribute']?.dispose();
      pair['value']?.dispose();
    }
    super.dispose();
  }
}
