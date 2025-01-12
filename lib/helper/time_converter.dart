import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  return DateFormat('EEE, dd MMM yyyy').format(dateTime);
}
