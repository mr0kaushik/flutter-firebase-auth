class User {
  final String userId;
  final String email;
  final String phoneNumber;
  bool isEmailAuth;

  User({this.userId, this.email, this.phoneNumber}) {
    isEmailAuth = this.email != null;
  }
}
