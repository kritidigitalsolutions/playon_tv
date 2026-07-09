import 'dart:ui';

import 'package:flutter/material.dart';

enum Status { init, success, error, loading }

Color statusColor(String? status) {
  switch (status) {
    case "CONFIRMED":
      return Colors.green;
    case "PENDING":
      return Colors.orange;
    case "CANCELLED":
      return Colors.red;
    default:
      return Colors.grey;
  }
}