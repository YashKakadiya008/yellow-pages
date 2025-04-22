class User {
  String id;
  String username;
  String? firstname;
  String? lastname;
  String? postalcode;
  String? birthdate;
  String zender;
  String language;
  String profile;
  String email;
  String role;
  String createdAt;
  String updatedAt;

  User({
    this.id = '',
    this.username = '',
    this.firstname,
    this.lastname,
    this.postalcode,
    this.birthdate,
    this.zender = 'other',
    this.language = 'en',
    this.profile = '',
    this.email = '',
    this.role = 'user',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      postalcode: json['postalcode'],
      birthdate: json['birthdate'],
      zender: json['zender'],
      language: json['language'],
      profile: json['profile'],
      email: json['email'],
      role: json['role'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'postalcode': postalcode,
      'birthdate': birthdate,
      'zender': zender,
      'language': language,
      'profile': profile,
      'email': email,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
