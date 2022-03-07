import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:sttv2/models/base/base_model.dart';
import 'package:sttv2/services/i_api_service.dart';
import 'package:sttv2/utils/app_exception.dart';

class ApiManager implements IApiService {
  final String _baseUrl = "https://jsonplaceholder.typicode.com/";

  Future<dynamic> get<T extends BaseModel>(String path,
      {BaseModel model}) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + path);
      responseJson = _returnResponse<T>(model, response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post<T extends BaseModel>(String path,
      {BaseModel model}) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrl + path, body: model);
      responseJson = _returnResponse<T>(model, response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put<T extends BaseModel>(String path,
      {BaseModel model}) async {
    var responseJson;
    try {
      final response = await http.put(_baseUrl + path, body: model);
      responseJson = _returnResponse<T>(model, response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete<T extends BaseModel>(String path,
      {BaseModel model}) async {
    var apiResponse;
    try {
      final response = await http.delete(_baseUrl + path);
      apiResponse = _returnResponse<T>(model, response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return apiResponse;
  }

  dynamic _returnResponse<T>(BaseModel model, http.Response response) {
    switch (response.statusCode) {
      case 200:
        return _jsonBodyParser<T>(model, response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  dynamic _jsonBodyParser<T>(BaseModel model, String body) {
    final jsonBody = jsonDecode(body);

    if (jsonBody is List)
      return jsonBody.map((e) => model.fromJson(e)).toList().cast<T>();
    else if (jsonBody is Map)
      return model.fromJson(jsonBody);
    else
      return jsonBody;
  }
}
