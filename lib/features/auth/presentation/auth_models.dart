/// Login Request Model
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

/// User Model
class UserModel {
  static bool _parseBool(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1' || normalized == 'yes' || normalized == 'y') return true;
      if (normalized == 'false' || normalized == '0' || normalized == 'no' || normalized == 'n') return false;
    }
    return fallback;
  }

  final int id;
  final String email;
  final String username;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? nik;
  final String? region;
  final String? address;
  final String? gender;
  final DateTime? birthDate;
  final String? avatarUrl;
  final bool isActive;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    this.firstName,
    this.lastName,
    this.phone,
    this.nik,
    this.region,
    this.address,
    this.gender,
    this.birthDate,
    this.avatarUrl,
    this.isActive = true,
    this.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawBirthDate = json['birth_date'] ?? json['birthDate'];
    DateTime? parsedBirthDate;
    if (rawBirthDate is String && rawBirthDate.isNotEmpty) {
      parsedBirthDate = DateTime.tryParse(rawBirthDate);
    }

    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? json['fullName'],
      firstName: json['first_name'] ?? json['firstName'],
      lastName: json['last_name'] ?? json['lastName'],
      phone: json['phone'],
      nik: json['nik'],
      region: json['region'],
      address: json['address'],
      gender: json['gender'],
      birthDate: parsedBirthDate,
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
      isActive: _parseBool(json['is_active'], fallback: true),
      isVerified: _parseBool(json['is_verified'], fallback: false),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    'full_name': fullName,
    'first_name': firstName,
    'last_name': lastName,
    'phone': phone,
    'nik': nik,
    'region': region,
    'address': address,
    'gender': gender,
    'birth_date': birthDate?.toIso8601String(),
    'avatar_url': avatarUrl,
    'is_active': isActive,
    'is_verified': isVerified,
  };
}

/// Login Response Model
class LoginResponse {
  final bool success;
  final String message;
  final String? token;
  final UserModel? user;

  LoginResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['data']?['token'] ?? json['token'],
      user: json['data']?['user'] != null ? UserModel.fromJson(json['data']['user']) : null,
    );
  }
}

/// Register Request Model
class RegisterRequest {
  final String email;
  final String username;
  final String password;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? nik;
  final String? region;
  final String? fullName;
  final String? address;
  /// Backend expects 'L' or 'P'
  final String? gender;
  /// ISO date string `YYYY-MM-DD`
  final String? birthDate;

  RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.nik,
    this.region,
    this.fullName,
    this.address,
    this.gender,
    this.birthDate,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'nik': nik,
    'region': region,
    'fullName': fullName,
    'address': address,
    'gender': gender,
    'birthDate': birthDate,
  };
}

/// Register Response Model
class RegisterResponse {
  final bool success;
  final String message;
  final String? token;
  final UserModel? user;

  RegisterResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['data']?['token'] ?? json['token'],
      user: json['data']?['user'] != null ? UserModel.fromJson(json['data']['user']) : null,
    );
  }
}
