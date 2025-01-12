import '../ImportAll.dart';

class UserData {
  final Timestamp dob;
  final String uname;
  final String image;
  final String qr;
  final String fname;
  final String lname;
  final String city;
  final String country;
  final String email;
  final String phone;
  final String gender;
  final String bg;
  final double weight;
  final double height;

  UserData({
    required this.dob,
    required this.uname,
    required this.image,
    required this.qr,
    required this.fname,
    required this.lname,
    required this.city,
    required this.country,
    required this.email,
    required this.phone,
    required this.gender,
    required this.bg,
    required this.weight,
    required this.height,
  });

  /// Convert Firestore document to UserInfo object
  factory UserData.fromMap(Map<String, dynamic> data, String uname) {
    return UserData(
      dob: data['dob'] ?? Timestamp.now(),
      uname: uname,
      image: data['image'] ?? '',
      qr: data['qr'] ?? '',
      fname: data['fname'] ?? '',
      lname: data['lname'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      gender: data['gender'] ?? '',
      bg: data['bg'] ?? '',
      weight: (data['weight'] ?? 0).toDouble(),
      height: (data['height'] ?? 0).toDouble(),
    );
  }
}
