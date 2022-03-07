import '../../constants/style/custom_colors.dart';

import '../../utils/screen.dart';
import 'package:flutter/rendering.dart';

abstract class CustomTexts {
  static final yellowHeader = TextStyle(
    color: CustomColors.yellow,
    fontWeight: FontWeight.bold,
    fontSize: Screen.size(22),
  );

  static final redHeader = TextStyle(
    color: CustomColors.red,
    fontWeight: FontWeight.bold,
    fontSize: Screen.size(25),
  );

  static final redHeader2 = TextStyle(
    color: CustomColors.red,
    fontWeight: FontWeight.bold,
    fontSize: Screen.size(22),
  );
}
