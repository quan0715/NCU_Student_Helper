class UserModel{
  String studentId;
  String eeclassPassword;
  String lineUserId;
  String lineUserName;

  UserModel({
    this.studentId = '',
    this.eeclassPassword = '',
    this.lineUserId = '',
    this.lineUserName = '',
  });

  set setStudentId(String studentId) => this.studentId = studentId;
  set setEeclassPassword(String eeclassPassword) => this.eeclassPassword = eeclassPassword;
  bool accountValidated() => studentId != '' && eeclassPassword != '';

  // UserModel.fromJson(Map<String, dynamic> json)
  //     : studentId = json['account'],
  //       eeclassPassword = json['password'],
  //       lineUserName = ,
  //       lineUserId = json['lineUserId'];
  
  // Map<String, dynamic> toJson() => {
  //   'studentId': studentId,
  //   'eeclassPassword': eeclassPassword,
  //   'lineUserId': lineUserId,
  //   'lineUserName': lineUserName,
  // };

}