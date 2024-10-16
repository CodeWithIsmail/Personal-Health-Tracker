import 'package:personal_health_tracker/data.dart';

import 'ImportAll.dart';

class Cbcinputscreen extends StatefulWidget {
  const Cbcinputscreen({super.key});

  @override
  State<Cbcinputscreen> createState() => _CbcinputscreenState();
}

class _CbcinputscreenState extends State<Cbcinputscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Text(allCBCtest[0]),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
