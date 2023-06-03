class AppUser {
  final String uid;
  final int userType;
  final String? admin;
  final String? name;
  final String? clas;
  final String? div;
  AppUser(
      {required this.uid,
      required this.userType,
      this.admin,
      this.name,
      this.clas,
      this.div});
}
