import '../ImportAll.dart';

class FirestoreService {
  // Future<void> storeSummeryImgLink(
  //     String uname, String imgLink, String summeryText) async {
  //   CollectionReference reports =
  //       FirebaseFirestore.instance.collection('report_summery');
  //
  //   Map<String, dynamic> reportData = {
  //     'date': DateTime.now(),
  //     'image_link': imgLink,
  //     'summery': summeryText,
  //   };
  //
  //   try {
  //     DocumentReference docRef = reports.doc(uname);
  //     DocumentSnapshot docSnapshot = await docRef.get();
  //
  //     if (docSnapshot.exists) {
  //       await docRef.update({
  //         'summery': FieldValue.arrayUnion([reportData]),
  //       });
  //     } else {
  //       await docRef.set({
  //         'summery': [reportData],
  //       });
  //     }
  //
  //     print("Report added successfully");
  //   } catch (e) {
  //     print("Error storing report: $e");
  //   }
  // }

  Future<void> storeSummeryImgLink(
      String username, String imgLink, String summery) async {
    try {
      await FirebaseFirestore.instance.collection('report').add({
        'username': username,
        'date': DateTime.now(),
        'image': imgLink,
        'summery': summery,
        'viewer': [],
      });
    } catch (e) {
      debugPrint('Error storing report data: $e');
    }
  }

  Future<void> profileInfoSave(ProfileInfo profileInfo) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(profileInfo.uname)
          .set({
        'uname': profileInfo.uname,
        'fname': profileInfo.fname,
        'lname': profileInfo.lname,
        'gender': profileInfo.gender,
        'city': profileInfo.city,
        'country': profileInfo.country,
        'email': profileInfo.email,
        'phone': profileInfo.phone,
        'dob': profileInfo.dob,
        'weight': profileInfo.weight,
        'height': profileInfo.height,
        'image': profileInfo.image,
        'qr': profileInfo.qr,
        'bg': profileInfo.bg,
      });
      print("User added successfully with custom ID!");
    } catch (e) {
      print("Error adding user: $e");
    }
  }
}
