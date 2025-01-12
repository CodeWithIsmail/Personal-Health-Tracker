import '../ImportAll.dart';

class Report {
  final String username;
  final List<String> viewer;
  final DateTime date;
  final String image;
  final String summary;

  Report({
    required this.username,
    required this.viewer,
    required this.date,
    required this.image,
    required this.summary,
  });

  // Convert Firestore document to a Report object
  factory Report.fromFirestore(Map<String, dynamic> data) {
    return Report(
      username: data['username'] as String,
      viewer: List<String>.from(data['viewer'] as List<dynamic>),
      date: (data['date'] as Timestamp).toDate(),
      image: data['image'] as String,
      summary: data['summery'] as String,
    );
  }

  // Convert a Report object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'viewer': viewer,
      'date': Timestamp.fromDate(date),
      'image': image,
      'summery': summary,
    };
  }
}
