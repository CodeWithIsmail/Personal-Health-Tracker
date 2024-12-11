import 'ImportAll.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
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

      // home: LoginOrRegistration(),
      home: HomePage(),
      // home: QRCodeGenerator(),
      // home:QRCodeScannerPage(),
      // home:ScanCodePage(),
      // home: ProfileScreen(),
      // home: AddReportScreen(),
      // home: ChatScreen(),
    );
  }
}
