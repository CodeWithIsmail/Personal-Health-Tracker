import '../ImportAll.dart';

class CustomAlert extends StatelessWidget {
  String text;
  Color bgColor;
  Color textColor;

  CustomAlert(this.text, this.bgColor, this.textColor);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: bgColor,
      title: Text(
        textAlign: TextAlign.center,
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
