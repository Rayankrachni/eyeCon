import 'package:dio/dio.dart';
import 'package:eyedetector/model/user.dart';

class ApiProvider {
  final Dio _dio;

  ApiProvider()
      : _dio = Dio(BaseOptions(
          baseUrl: "http://eyes.live.net.mk/api",

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

 Future<Response> uploadVideoFile(String userId,FormData formData) {
//userId
  return _dio.post('/MobileUser/Upload/$userId', data: formData,options: Options(headers: {}));

}

  Future<Response> getData(String userId) {
    return _dio.get('/MobileUser/prescription/$userId');
  }
}