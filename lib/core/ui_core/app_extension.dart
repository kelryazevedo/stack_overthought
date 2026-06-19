import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:stack_overthought/model/tag.dart';

extension DateTimeExtension on DateTime {
  String get formatted {
    return DateFormat('dd MMM, HH:mm', 'pt_BR').format(this);
  }
}

extension TagColorX on Tag {
  Color get parsedColor {
    return Color(int.parse(color.replaceFirst('#', '0xFF')));
  }
}
