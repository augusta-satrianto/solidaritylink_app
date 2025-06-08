class UserModel {
  final int id;
  String name;
  String email;
  String? password;
  String? image;
  String? profession;
  String? address;
  String? city;
  String? province;
  String? gender;
  DateTime? birthDate;
  String? bio;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.image,
    this.profession,
    this.address,
    this.city,
    this.province,
    this.gender,
    this.birthDate,
    this.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], name: json['name'], email: json['email']);
  }
}
