class Helpers {
  static bool isNull(dynamic value) => value == null;

  static bool isListNull(List<dynamic> value) =>
      value == null || value.length == 0;

  static bool isNullOrEmpty(String value) =>
      value == null || value == "" || value.length == 0;
}
