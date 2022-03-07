import '../../utils/screen.dart';
import './custom_colors.dart';

import 'package:flutter/material.dart';

abstract class CustomInputs {
  static InputDecoration authInputDecoration(
      {@required String hintText, IconData icon, Function function}) {
    return InputDecoration(
      filled: true,
      fillColor: CustomColors.inputRed,
      contentPadding: EdgeInsets.all(Screen.height(3)),
      errorStyle: TextStyle(color: Colors.white),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: Colors.transparent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: Colors.transparent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: Colors.transparent),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: Colors.transparent),
      ),
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 16, color: Colors.white),
      suffixIcon: icon != null
          ? Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: Icon(
                    icon,
                    color: Colors.white,
                  ),
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () => function()),
            )
          : null,
      errorMaxLines: 2,
    );
  }

  static InputDecoration userDetailDecoration(
      {@required String hintText, Function function, IconData icon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(Screen.height(3)),
      errorStyle: TextStyle(color: CustomColors.red),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: CustomColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 16),
      suffixIcon: icon != null
          ? Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: Icon(
                    icon,
                    color: CustomColors.grey,
                  ),
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () => function()),
            )
          : null,
      errorMaxLines: 2,
    );
  }

  static InputDecoration paymentDetailDecoration({@required String hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(Screen.height(3)),
      errorStyle: TextStyle(color: CustomColors.red),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: CustomColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 16),
      errorMaxLines: 5,
    );
  }

  static InputDecoration orderPageDecoration({@required String hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(Screen.height(3)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(width: 1, color: CustomColors.grey),
      ),
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 16),
      errorMaxLines: 5,
    );
  }
}
