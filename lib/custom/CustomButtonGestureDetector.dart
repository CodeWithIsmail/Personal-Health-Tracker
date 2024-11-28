import '../ImportAll.dart';

class CustomButtonGestureDetector extends StatelessWidget {
  String text;
  double width;
  double height;
  Color bgColor;
  Color textColor;
  double fontsize;
  void Function()? function;

  CustomButtonGestureDetector(this.text, this.width, this.height, this.bgColor,
      this.textColor, this.fontsize, this.function);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: fontsize,
            color: textColor,

          ),
        ),
      ),
    );
  }
}
