import '../ImportAll.dart';

class CustomTextGestureDetector extends StatelessWidget {
  void Function()? function;
  String text;
  Color textcolor;
  double fontsize;
  bool bold;

  CustomTextGestureDetector(
      this.text, this.textcolor, this.fontsize, this.bold, this.function);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Text(
        text,
        style: TextStyle(
          color: textcolor,
          fontSize: fontsize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
