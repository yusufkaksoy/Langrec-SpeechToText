import 'package:flutter/widgets.dart';
import 'package:translator/translator.dart';

class AppState extends ChangeNotifier {
  bool _isListening = false;
  GoogleTranslator _translator = GoogleTranslator();
  String _translatedText;

  bool get isListening => _isListening;

  set isListening(bool value) {
    _isListening = value;
    notifyListeners();
  }

  GoogleTranslator get translator => _translator;

  set translator(GoogleTranslator value) {
    _translator = value;
    notifyListeners();
  }

  String get translatedText => _translatedText;

  set translatedText(String value) {
    _translatedText = value;
    notifyListeners();
  }
}
