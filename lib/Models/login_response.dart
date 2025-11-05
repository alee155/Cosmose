import 'dart:convert';

class LoginResponse {
  final String token;
  final User user;
  final dynamic loyaltyCard; // Can be null, so dynamic type is used.

  LoginResponse({
    required this.token,
    required this.user,
    this.loyaltyCard,
  });

  /// **Factory constructor to parse JSON**
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json["token"],
      user: User.fromJson(json["user"]),
      loyaltyCard: json["loyaltyCard"], // Can be null
    );
  }

  /// **Convert Model to JSON (Optional)**
  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "user": user.toJson(),
      "loyaltyCard": loyaltyCard,
    };
  }

  /// **Pretty Print JSON (For Debugging)**
  String prettyPrint() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}

class User {
  final int id;
  final String name;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "role": role,
    };
  }
}
