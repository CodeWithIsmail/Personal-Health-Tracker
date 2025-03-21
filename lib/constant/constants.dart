import '../ImportAll.dart';


final gradientMain = LinearGradient(
  // colors: [
  //   Color(0xFFA1FFCE),
  //   Color(0xFFFAFFD1),
  // ],
  colors: [
    Color(0xFF1D976C),
    Color(0xFF93F9B9),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final appNameTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(
      blurRadius: 10.0,
      color: Colors.black26,
      offset: Offset(3.0, 3.0),
    ),
  ],
);

final promptTextFieldDecoration = InputDecoration(
  contentPadding: const EdgeInsets.all(15),
  hintText: 'Enter prompt',
  border: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      Radius.circular(14),
    ),
    borderSide: BorderSide(
      color: Color(0xFF355C7D),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      Radius.circular(14),
    ),
    borderSide: BorderSide(
      color: Color(0xFF355C7D),
    ),
  ),
);

const kAppBarTextStyle = TextStyle(
  fontSize: 25,
  color: Colors.white,
  letterSpacing: 2,
  fontWeight: FontWeight.bold,
);

final visualizationDropdownDecoration=InputDecoration(
  labelText: 'Select Date Range',
  labelStyle: const TextStyle(color: Colors.teal),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(color: Colors.teal),
  ),
);

final visualizationDropdownDecorationTest=InputDecoration(
  labelText: 'Select Test Name',
  labelStyle: const TextStyle(color: Colors.teal),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(color: Colors.teal),
  ),
);
