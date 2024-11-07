import '../ImportAll.dart';

class CustomIconName extends StatelessWidget {
  String imgPath;
  double width;
  double height;

  CustomIconName(this.imgPath, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imgPath,
      width: width,
      height: height,
    );
  }
}
