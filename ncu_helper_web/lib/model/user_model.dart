class UserModel{
  String studentId;
  String eeclassPassword;
  String lineUserId;
  String lineUserName;
  String notionDatabaseId;
  String notionAuthToken;

  UserModel({
    this.studentId = '',
    this.eeclassPassword = '',
    this.lineUserId = '',
    this.lineUserName = '',
    this.notionDatabaseId = '',
    this.notionAuthToken = '',
  });

  set setStudentId(String studentId) => this.studentId = studentId;
  set setEeclassPassword(String eeclassPassword) => this.eeclassPassword = eeclassPassword;
  set setLineUserId(String lineUserId) => this.lineUserId = lineUserId;
  set setLineUserName(String lineUserName) => this.lineUserName = lineUserName;
  set setNotionDatabaseId(String notionDatabaseId) => this.notionDatabaseId = notionDatabaseId;
  set setNotionAuthToken(String notionAuthToken) => this.notionAuthToken = notionAuthToken;
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