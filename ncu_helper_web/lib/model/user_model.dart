class UserModel{
  String studentId;
  String eeclassPassword;
  String lineUserId;

  UserModel({
    this.studentId = '',
    this.eeclassPassword = '',
    this.lineUserId = '',
  });

  set setStudentId(String studentId) => this.studentId = studentId;
  set setEeclassPassword(String eeclassPassword) => this.eeclassPassword = eeclassPassword;
  bool accountValidated() => studentId != '' && eeclassPassword != '';

  UserModel.fromJson(Map<String, dynamic> json)
      : studentId = json['studentId'],
        eeclassPassword = json['eeclassPassword'],
        lineUserId = json['lineUserId'];
  
  Map<String, dynamic> toJson() => {
    'studentId': studentId,
    'eeclassPassword': eeclassPassword,
    'lineUserId': lineUserId,
  };

}