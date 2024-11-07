import '../ImportAll.dart';

class CustomToast {
  String text;
  Color bgColor;
  Color textColor;
  double textSize;

  CustomToast(this.text, this.bgColor, this.textColor, this.textSize);

  void showToast() {
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: textSize,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
