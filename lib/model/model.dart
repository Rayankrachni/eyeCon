class Model{

  String? fileName;
  String? fileType;
  String? title;
  String? description;
  int? duration;

  Model({required this.fileName,required this.fileType,required this.title,required this.description, required this.duration});

  factory Model.fromJson(Map<String,dynamic> json)=> Model(
      fileName: json['fileName'].toString(),
      fileType: json['fileType'].toString(),
      title: json['title'].toString(),
      description: json['description'].toString(),

      duration: int.parse(json['duration'].toString())
  );

  Map<String, dynamic> toMap() {
    return {

      'fileName':fileName,
      'fileType': fileType,
      'title':title,
      'description':description,
      'duration': duration,

    };
  }
}