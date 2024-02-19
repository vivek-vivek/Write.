import 'package:intl/intl.dart';

String normalDateFormate(String dateString) {
  if (dateString.trim().isEmpty) return "";

  DateTime dateTime = DateTime.parse(dateString);

  String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

  // Output: 20 Feb 2024
  return formattedDate;
}
