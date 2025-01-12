import '../ImportAll.dart';

String calculateAge(Timestamp birthDate) {
  DateTime birthDateTime = birthDate.toDate();
  DateTime currentDate = DateTime.now();

  int years = currentDate.year - birthDateTime.year;
  int months = currentDate.month - birthDateTime.month;
  int days = currentDate.day - birthDateTime.day;
  if (months < 0) {
    months += 12;
    years--;
  }
  if (days < 0) {
    months--;
    days += DateTime(currentDate.year, currentDate.month, 0).day;
  }
  String yearsText = years <= 1 ? "Year" : "Years";
  String monthsText = months <= 1 ? "Month" : "Months";
  String daysText = days <= 1 ? "Day" : "Days";

  List<String> parts = [];

  if (years > 0) {
    parts.add("$years $yearsText");
  }
  if (months > 0) {
    parts.add("$months $monthsText");
  }
  if (days > 0) {
    parts.add("$days $daysText");
  }
  return parts.join(' ');
}

double calculateBMI(double weight, double height) {
  print(weight);
  print(height);
  height /= 100.0;
  return (weight / (height * height));
}