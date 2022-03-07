import 'package:sttv2/models/base/base_model.dart';

class User extends BaseModel {
  int id;
  User({
    this.id,
  });

  @override
  fromJson(Map<String, Object> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, Object> toJson() {
    throw UnimplementedError();
  }
}
