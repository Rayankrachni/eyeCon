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

  return _dio.post('/MobileUser/Upload/db92236a-1a00-47db-910a-e52d88ddb15d', data: formData,options: Options(headers: {}));

}

  Future<Response> getData() {
    return _dio.get('/MobileUser/prescription/0');
  }
}