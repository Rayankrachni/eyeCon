
class UserModel {
   final String name;
  final String email;
  final String surname;
  final String phone;
  final String gender;
  final String birthday;
  final String eyeColor;

  UserModel({
    required this.name,
    required this.email,
    required this.surname,
    required this.phone,
    required this.gender,
    required this.birthday,
    required this.eyeColor,
  });








  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    surname: json['surname'].toString(),
    name: json['name'].toString(),
    email: json['email'].toString(),
    phone: json['phone'].toString(),
    birthday: json['birthday'].toString(),
    gender: json['gender'].toString(),
    eyeColor: json['eyeColor'].toString(),
  
  );


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'surname': surname,
      'phone': phone,
      'gender':gender,
      'birthday':birthday,
      'eyeColor':eyeColor
    };
  }
}