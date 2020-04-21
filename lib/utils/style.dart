import 'package:firebaseflutterauth/utils/mat_colors.dart';
import 'package:flutter/material.dart';

final screenTitleStyle = TextStyle(
  color: MatColor.iconColor,
  fontFamily: 'Lato',
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

final errorStyle = TextStyle(
  fontFamily: 'Lato',
  fontSize: 14,
  color: Colors.red,
);

final onTapTextBoldStyle = TextStyle(
  fontSize: 14,
  fontFamily: 'Lato',
  fontWeight: FontWeight.bold,
  color: MatColor.secondaryTextColor,
);

final divider = Divider(
  thickness: 1.2,
  color: MatColor.dividerColor,
);
