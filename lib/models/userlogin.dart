class UserLogin {
  final String FullName;
  final String UserID;

  const UserLogin({required this.FullName,required this.UserID});

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      FullName: json['FullName'],
      UserID: json['UserID'],
    );
  }
}