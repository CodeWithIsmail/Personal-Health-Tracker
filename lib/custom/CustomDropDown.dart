import 'package:flutter/material.dart';

// Custom Dropdown Widget
class CustomDropdown<T> extends StatelessWidget {
  final List<T> options;
  final T? selectedItem;
  final Function(T?) onChanged;
  final String hint;

  CustomDropdown({
    required this.options,
    required this.selectedItem,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: selectedItem,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
      items: options.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      hint: Text(hint),
    );
  }
}
