import 'package:flutter/material.dart';

class Customradioselectiontextfield extends StatefulWidget {
  const Customradioselectiontextfield({super.key});

  @override
  State<Customradioselectiontextfield> createState() =>
      _CustomradioselectiontextfieldState();
}

class _CustomradioselectiontextfieldState
    extends State<Customradioselectiontextfield> {
  int selectedIndex = 0;

  final List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
  ];

  Widget RadioOptions(index) {
    return Row(
      children: [
        Radio(
            value: index,
            groupValue: selectedIndex,
            onChanged: (value) {
              setState(() {
                selectedIndex = index;
              });
            }),
        Text(
          genderOptions[index],
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8,
        ),
        ...List.generate(
          genderOptions.length,
          RadioOptions
        )
      ],
    );
  }
}
