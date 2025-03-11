import 'dart:typed_data';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../ImportAll.dart';

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find user'),
        titleTextStyle: TextStyle(
          color: Colors.green.shade900,
          fontSize: 20,
        ),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            print('Barcode found! ${barcode.rawValue}');
          }
          if (image != null) {
            String uname = barcodes.first.rawValue ?? "ismail99";
            print(uname);

            checkPermissionAndNavigate(context, uname);

            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ProfileScreen(uname),
            //   ),
            // );
          }
        },
      ),
    );
  }

  void checkPermissionAndNavigate(
      BuildContext context, String targetUsername) async {
    String currentUser =
        FirebaseAuth.instance.currentUser!.email!.split('@')[0];

    // Fetch the current user's document from the 'connection' collection
    final DocumentSnapshot<Map<String, dynamic>> currentUserDoc =
        await FirebaseFirestore.instance
            .collection("connection")
            .doc(currentUser)
            .get();

    // Fetch the target user's document from the 'connection' collection
    final DocumentSnapshot<Map<String, dynamic>> targetUserDoc =
        await FirebaseFirestore.instance
            .collection("connection")
            .doc(targetUsername)
            .get();

    if (targetUserDoc.exists && currentUserDoc.exists) {
      // Get the viewers and connections array for both users
      List<dynamic> targetViewers = targetUserDoc.data()?["viewers"] ?? [];
      List<dynamic> currentConnections =
          currentUserDoc.data()?["connections"] ?? [];

      // Check if current user is in the target user's viewers array and if target user is in current user's connections
      if (targetViewers.contains(currentUser) &&
          currentConnections.contains(targetUsername)) {
        // Permission granted: Navigate to the profile screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(targetUsername),
          ),
        );
      } else {
        // No permission: Show a dialog
        showNoPermissionDialog(context);
      }
    } else {
      // Either current user or target user doesn't exist in the database
      showErrorDialog(context, "User not found or missing connection data.");
    }
  }

  void showNoPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Access Denied"),
        content: Text("You do not have permission to view this profile."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
