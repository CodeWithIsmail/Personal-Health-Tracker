import 'package:personal_health_tracker/ImportAll.dart';

class AppRoutes{
   static Map<String,WidgetBuilder> getRoutes(){
       return {
          '/authCheck' : (context) => AuthCheck(),
          '/scanCodePage' : (context) => ScanCodePage(),
          '/loginOrRegistration' : (context) => LoginOrRegistration()
       };
   }
}
