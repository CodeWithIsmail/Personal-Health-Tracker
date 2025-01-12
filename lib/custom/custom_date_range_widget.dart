import '../ImportAll.dart';
class CustomDateRangeWidget extends StatelessWidget {
  BuildContext context;
  Widget child;

  CustomDateRangeWidget(this.context, this.child);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.blue, // Header background color
            onPrimary: Colors.white, // Header text color
            onSurface: Colors.black, // Body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue, // Button text color
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
