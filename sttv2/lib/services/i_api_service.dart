import 'package:sttv2/models/base/base_model.dart';

abstract class IApiService {
  Future<dynamic> get<T extends BaseModel>(String path, {BaseModel model});

  Future<dynamic> post<T extends BaseModel>(String path, {BaseModel model});

  Future<dynamic> put<T extends BaseModel>(String path, {BaseModel model});

  Future<dynamic> delete<T extends BaseModel>(String path, {BaseModel model});
}
