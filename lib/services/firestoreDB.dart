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

  Stream<QuerySnapshot<Object?>> getEntry(String user_id) {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("reports");
    return collectionReference.where('user_id', isEqualTo: user_id).snapshots();
  }
}
