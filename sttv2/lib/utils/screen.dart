import 'package:flutter/widgets.dart';

class Screen {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double devicePixel;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    devicePixel = _mediaQueryData.devicePixelRatio;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  static double height(double percentOfHeight) =>
      safeBlockVertical * percentOfHeight;

  static double width(double percentOfWidth) =>
      safeBlockHorizontal * percentOfWidth;

  static double size(double size) => safeBlockHorizontal / 4.3 * size;
}
