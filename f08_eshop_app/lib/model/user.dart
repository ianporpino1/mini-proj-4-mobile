class User {
  String? id;
  final String name;
  final String email;
  final String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory User.fromJson(String id, Map<String, dynamic> json) {
    return User(
      id: id,
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
