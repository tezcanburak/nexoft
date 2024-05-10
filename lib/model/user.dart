class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profileImageUrl;

  final DateTime? createdAt;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.createdAt,
  });

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      lastName: lastName ?? this.lastName,
      createdAt: createdAt ?? this.createdAt,
      firstName: firstName ?? this.firstName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  const User.empty()
      : id = null,
        lastName = null,
        firstName = null,
        phoneNumber = null,
        profileImageUrl = null,
        createdAt = null;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'lastName': lastName,
        'firstName': firstName,
        'phoneNumber': phoneNumber,
        'profileImageUrl': profileImageUrl,
        'createdAt': createdAt.toString(),
      };
}
