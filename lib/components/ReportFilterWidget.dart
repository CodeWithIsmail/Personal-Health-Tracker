import 'package:flutter/material.dart';

import '../ImportAll.dart';

class Reportfilterwidget extends StatefulWidget {
  Reportfilterwidget({super.key});

  @override
  State<Reportfilterwidget> createState() => _ReportfilterwidgetState();
}

class _ReportfilterwidgetState extends State<Reportfilterwidget> {
  DateTime? startDate;

  DateTime? endDate;

  final DateFormat dateFormat = DateFormat('dd-MMM-yyyy');

  void _showDateRangeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime? tempStartDate = startDate;
        DateTime? tempEndDate = endDate;

        return AlertDialog(
          title: Text("Select Date Range"),
          content: Container(
            width: 350, // Adjust the width as needed
            height: 250, // Adjust the height as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Start Date TextField with Icon as the label
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: tempStartDate != null
                          ? dateFormat.format(tempStartDate)
                          : "Pick Start Date"),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.black), // Icon at the start
                    hintText: "Pick Start Date", // Placeholder text
                    border: InputBorder.none, // Removes the default border
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Bottom border
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Bottom border
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
                      });
                    }
                  },
                ),
                SizedBox(height: 10),
                // End Date TextField with Icon as the label
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: tempEndDate != null
                          ? dateFormat.format(tempEndDate)
                          : "Pick End Date"),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.black), // Icon at the start
                    hintText: "Pick End Date", // Placeholder text
                    border: InputBorder.none, // Removes the default border
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Bottom border
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Bottom border
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
            ),
            // Apply Button
            TextButton(
              onPressed: () {
                setState(() {
                  startDate = tempStartDate;
                  endDate = tempEndDate;
                });
                Navigator.pop(context);

                // Optionally fetch data for the selected range here
                if (startDate != null && endDate != null) {
                  print("Selected Range: ${dateFormat.format(startDate!)} - ${dateFormat.format(endDate!)}");
                  // Add your logic for filtering test values by date range
                }
              },
              child: Text("Apply"),
            ),
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
      onTap:  _showDateRangeDialog,
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
              Icon(
                Icons.filter_alt,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Filter',
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          )),
    );
  }
}
