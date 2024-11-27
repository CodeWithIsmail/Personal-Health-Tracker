import 'ImportAll.dart';


void main() async {
  // final model = GenerativeModel(
  //   model: 'gemini-1.5-pro',
  //   apiKey: apiKey,
  // );
  //
  // final prompt = 'Analyze the following medical report and provide a summary of the key findings. Are there any abnormal test results that require further investigation? Are there any specific instructions for the patient to follow?';
  // final imageBytes = await File('cookie.png').readAsBytes();
  // final content = [
  //   Content.multi([
  //     TextPart(prompt),
  //     DataPart('image/png', imageBytes),
  //   ])
  // ];
  //
  // final response = await model.generateContent(content);
  // print(response.text);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(MyApp());
  runApp(GenerativeAISample());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: CBCinputScreen(new CBC("12", "", "", "", "", "", "", "", "", "", "",
      //     "", "", "", "", "", "", "", "", "")),
      // home: LoginOrRegistration(),
      home: HomePage(),
    );
  }
}
