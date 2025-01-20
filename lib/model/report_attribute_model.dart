import '../ImportAll.dart';
class ReportAttribute {
  final String username;
  final DateTime date;
  final String attributeName;
  final double value;

  ReportAttribute({
    required this.username,
    required this.date,
    required this.attributeName,
    required this.value,
  });

  // Factory method to create an instance from a map (useful for Firestore or JSON data)
  factory ReportAttribute.fromMap(Map<String, dynamic> map) {
    return ReportAttribute(
      username: map['username'],
      date: (map['date'] as Timestamp).toDate(),
      attributeName: map['attribute_name'],
      value: map['value'].toDouble(),
    );
  }

  // Method to convert the instance to a map (useful for Firestore or JSON data)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'date': date,
      'attribute_name': attributeName,
      'value': value,
    };
  }
}
