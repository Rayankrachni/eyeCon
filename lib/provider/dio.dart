import 'package:dio/dio.dart';
import 'package:eyedetector/model/user.dart';

class ApiProvider {
  final Dio _dio;

  ApiProvider()
      : _dio = Dio(BaseOptions(
          baseUrl: "http://eyes.live.net.mk/api",
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  Future<Response> registerUser(UserModel user) {
    return _dio.post('/MobileUser', data: {
      'userId': '',
      'name': user.name,
      'surname': user.surname,
      'email':user.email,
      'dateOfBirth':user.birthday ,
      'eyesColor':user.eyeColor

    });
  }





}