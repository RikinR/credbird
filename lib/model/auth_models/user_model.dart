// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final String token;
  final bool accountVerified;
  final bool isActive;
  final double walletAmount;
  final DateTime? lastOnline;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.token,
    required this.accountVerified,
    required this.isActive,
    required this.walletAmount,
    this.lastOnline,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ?? '',
      userType: json['userType'] ?? 'STUDENT',
      token: json['token'] ?? '',
      accountVerified: json['accountVerified'] ?? false,
      isActive: json['isActive'] ?? false,
      walletAmount: (json['walletAmount'] ?? 0).toDouble(),
      lastOnline:
          json['lastOnline'] != null
              ? DateTime.tryParse(json['lastOnline'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'userType': userType,
    'token': token,
    'accountVerified': accountVerified,
    'isActive': isActive,
    'walletAmount': walletAmount,
    'lastOnline': lastOnline?.toIso8601String(),
  };

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? token,
    bool? accountVerified,
    bool? isActive,
    double? walletAmount,
    DateTime? lastOnline,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      token: token ?? this.token,
      accountVerified: accountVerified ?? this.accountVerified,
      isActive: isActive ?? this.isActive,
      walletAmount: walletAmount ?? this.walletAmount,
      lastOnline: lastOnline ?? this.lastOnline,
    );
  }
}
