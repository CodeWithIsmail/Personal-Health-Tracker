import '../ImportAll.dart';

class CustomTextField extends StatelessWidget {
  String hint;
  bool obscure;
  TextEditingController textEditingController;
  TextInputType textInputType;

  CustomTextField(
      this.hint, this.obscure, this.textEditingController, this.textInputType);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      textAlign: TextAlign.left,
      obscureText: obscure,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        hintText: hint,
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
    );
  }
}
