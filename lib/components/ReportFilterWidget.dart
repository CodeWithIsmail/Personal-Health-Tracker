import 'package:flutter/material.dart';

import '../ImportAll.dart';

class Reportfilterwidget extends StatefulWidget {

 // Reportfilterwidget({super.key});

  final Function(DateTime? , DateTime?) onDateRangeSelected;

  Reportfilterwidget({Key? key, required this.onDateRangeSelected}) : super(key: key);

  @override
  State<Reportfilterwidget> createState() => _ReportfilterwidgetState();
}

class _ReportfilterwidgetState extends State<Reportfilterwidget> {
  DateTime? startDate;
  DateTime? endDate;
  final DateFormat dateFormat = DateFormat('dd-MMM-yyyy');

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  void _showDateRangeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime? tempStartDate = startDate;
        DateTime? tempEndDate = endDate;

        return AlertDialog(
          title: Text("Select Date Range"),
          content: Container(
            width: 350,
            height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20,),
                // Start Date TextField with Icon as the label
                TextFormField(
                  readOnly: true,
                  controller: startDateController
                    ..text = tempStartDate != null
                        ? dateFormat.format(tempStartDate)
                        : "Start Date",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today,
                        color: Colors.black),
                    hintText: "Start Date",
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  onTap: () async {
                    DateTime? pickedStartDate = await showDatePicker(
                      context: context,
                      initialDate: tempStartDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedStartDate != null) {
                      setState(() {
                        tempStartDate = pickedStartDate;
                        startDateController.text = dateFormat.format(tempStartDate!); // Update text
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                // End Date TextField with Icon as the label
                TextFormField(
                  readOnly: true,
                  controller: endDateController
                    ..text = tempEndDate != null
                        ? dateFormat.format(tempEndDate)
                        : "End Date",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today,
                        color: Colors.black), // Icon at the start
                    hintText: "End Date", // Placeholder text
                    border: InputBorder.none, // Removes the default border
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black), // Bottom border
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black), // Bottom border
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  onTap: () async {
                    DateTime? pickedEndDate = await showDatePicker(
                      context: context,
                      initialDate: tempEndDate ?? DateTime.now(),
                      firstDate: tempStartDate ?? DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedEndDate != null) {
                      setState(() {
                        tempEndDate = pickedEndDate;
                        endDateController.text = dateFormat.format(tempEndDate!); // Update text
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white)),

            // Apply Button
            TextButton(
                onPressed: () {
                  setState(() {
                    startDate = tempStartDate;
                    endDate = tempEndDate;
                  });
                  Navigator.pop(context);
                  if (startDate != null && endDate != null) {
                    print("Date time gotten from report filter");
                    print("Selected Range: ${dateFormat.format(startDate!)} - ${dateFormat.format(endDate!)}");

                    widget.onDateRangeSelected(startDate, endDate);
                  }
                },
                child: Text("Apply"),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerWidth = screenWidth * 0.92; // 90% of screen width
    double containerHeight = screenHeight * 0.07; // 12% of screen height

    return GestureDetector(
      onTap: _showDateRangeDialog,
      child: Container(
        height: containerHeight,
        width: containerWidth,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.indigo.shade300,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.filter_alt),
            SizedBox(width: 20),
            Text(
              'Filter',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
