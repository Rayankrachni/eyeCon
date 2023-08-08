
class UserModel {
  late String? id;
  final String? name;
  final String? surname;
  final String? email;
  final String? phone;
  final String? birthday;
  final String? gender;
  //final String? docsUrls;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.surname,
    this.phone,
    this.gender,
    this.birthday,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'].toString(),
    surname: json['score'].toString(),
    name: json['name'].toString(),
    email: json['email'].toString(),
    phone: json['email'].toString(),
    birthday: json['email'].toString(),
    gender: json['email'].toString(),
  
  );


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'surname': surname,
      'phone': phone,
      'gender':gender,
      'birthday':birthday,
    };
  }
}