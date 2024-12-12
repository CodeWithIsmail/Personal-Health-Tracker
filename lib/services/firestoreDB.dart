import '../ImportAll.dart';

class FirestoreService {
  Future<void> storeImgLink(
      String userId, String reportId, String imgLink) async {
    CollectionReference reports =
        FirebaseFirestore.instance.collection('reports');
    Map<String, dynamic> reportData = {
      'user_id': userId,
      'report_id': reportId,
      'image_link': imgLink,
      'time': DateTime.now(),
    };

    try {
      await reports.add(reportData);
      print("report added successfully");
    } catch (e) {
      print(e);
    }
  }

  // Stream<QuerySnapshot<Object?>> getEntry(String user_id) {
  //   final CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection("reports");
  //   return collectionReference.where('user_id', isEqualTo: user_id).snapshots();
  // }

  Stream<QuerySnapshot<Object?>> getEntry(String user_id) {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("ReportSummery");
    return collectionReference.where('user_id', isEqualTo: user_id).snapshots();
  }

  Stream<QuerySnapshot<Object?>> getUserProfile(String uname) {
    final CollectionReference = FirebaseFirestore.instance.collection('users');
    return CollectionReference.where('uname', isEqualTo: uname).snapshots();
  }

  Future<void> storeSummeryImgLink(
      String userId, String imgLink, String summery) async {
    CollectionReference reports =
        FirebaseFirestore.instance.collection('ReportSummery');
    Map<String, dynamic> reportData = {
      'user_id': userId,
      'image_link': imgLink,
      'report_summery': summery,
      'time': DateTime.now(),
    };

    try {
      await reports.add(reportData);
      print("report added successfully");
    } catch (e) {
      print(e);
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
