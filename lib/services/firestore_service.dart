import '../ImportAll.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch user document by username
  Future<Map<String, dynamic>?> fetchUserDocument(String username) async {
    try {
      final docSnapshot =
          await _firestore.collection('users').doc(username).get();

      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching user document: $error');
      return null;
    }
  }

  /// Fetch the list of test names from the specified document
  Future<List<String>> fetchTestNames() async {
    try {
      final documentSnapshot =
          await _firestore.collection('test_collection').doc('sample').get();

      if (documentSnapshot.exists) {
        List<dynamic> data = documentSnapshot.get('test_names');
        return data.cast<String>();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching test names: $e');
      return [];
    }
  }

  /// Add a new test name to the specified document in Firestore
  Future<void> addTestName(String testName) async {
    try {
      final documentRef =
          _firestore.collection('test_collection').doc('sample');

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(documentRef);

        if (snapshot.exists) {
          List<dynamic> currentTestNames = snapshot.get('test_names');
          currentTestNames.add(testName);
          transaction.update(documentRef, {'test_names': currentTestNames});
        } else {
          transaction.set(documentRef, {
            'test_names': [testName]
          });
        }
      });
    } catch (e) {
      print('Error adding test name: $e');
      rethrow;
    }
  }

  /// Fetch all reports for a specific username
  Future<List<Report>> fetchReports(String username) async {
    try {
      final snapshot = await _firestore
          .collection('report')
          .where('username', isEqualTo: username)
          .get();

      return snapshot.docs
          .map((doc) => Report.fromFirestore(doc.data()))
          .toList();
    } catch (error) {
      print('Error fetching reports: $error');
      return [];
    }
  }

  /// Fetch reports for a specific date range and username
  Future<List<Report>> fetchReportsByDateRange(
      String username, DateTime startDate, DateTime endDate) async {
    try {
      final snapshot = await _firestore
          .collection('report')
          .where('username', isEqualTo: username)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      return snapshot.docs
          .map((doc) => Report.fromFirestore(doc.data()))
          .toList();
    } catch (error) {
      print('Error filtering reports: $error');
      return [];
    }
  }

  /// Add a new report
  Future<void> addReport(Report report) async {
    try {
      await _firestore.collection('report').add(report.toFirestore());
    } catch (error) {
      print('Error adding report: $error');
      rethrow;
    }
  }

  /// Add a viewer to the report's viewer list
  Future<void> addViewer(String docId, String addViewerUsername) async {
    try {
      await _firestore.collection('report').doc(docId).update({
        'viewer': FieldValue.arrayUnion([addViewerUsername]),
      });
    } catch (error) {
      print('Error adding viewer: $error');
      rethrow;
    }
  }

  /// Remove a viewer from the report's viewer list
  Future<void> removeViewer(String docId, String removeViewerUsername) async {
    try {
      await _firestore.collection('report').doc(docId).update({
        'viewer': FieldValue.arrayRemove([removeViewerUsername]),
      });
    } catch (error) {
      print('Error removing viewer: $error');
      rethrow;
    }
  }

  /// Delete a report by document ID
  Future<void> deleteReport(String docId) async {
    try {
      await _firestore.collection('report').doc(docId).delete();
    } catch (error) {
      print('Error deleting report: $error');
      rethrow;
    }
  }

  /// Fetch report data for a specific user, test name, and date range
  Future<List<ChartDataTimewise>> fetchReportData(String username,
      String testName, DateTime startingDate, DateTime endingDate) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('report_attribute')
          .where('username', isEqualTo: username)
          .where('attribute_name', isEqualTo: testName)
          .where('date', isGreaterThanOrEqualTo: startingDate)
          .where('date', isLessThanOrEqualTo: endingDate)
          .get();

      return snapshot.docs.map((doc) {
        final report =
            ReportAttribute.fromMap(doc.data() as Map<String, dynamic>);
        return ChartDataTimewise(
          report.date.millisecondsSinceEpoch,
          report.value,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching report data: $e');
      rethrow;
    }
  }

  /// Store new report data
  Future<void> storeReportData(String username, DateTime date,
      String attributeName, double value) async {
    try {
      await _firestore.collection('report_attribute').add({
        'username': username,
        'date': date,
        'attribute_name': attributeName,
        'value': value,
      });
    } catch (e) {
      debugPrint('Error storing report data: $e');
      rethrow;
    }
  }

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
