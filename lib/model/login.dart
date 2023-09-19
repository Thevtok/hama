import 'package:hive_flutter/hive_flutter.dart';

class UserLogin {
  final String email;
  final String password;

  UserLogin({required this.email, required this.password});

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}


class HiveService {
  
  static Future<void> init() async {
    await Hive.initFlutter();
  }





  static Future<void> saveToken(String token) async {
    final box = await Hive.openBox('auth');
    await box.put('token', token);
  }



  static Future<String?> getToken() async {
    final box = await Hive.openBox('auth');
    return box.get('token');
  }

  static Future<bool> hasToken() async {
    final box = await Hive.openBox('auth');
    final token = box.get('token') as String?;

    return token != null;
  }


  static Future<void> deleteToken() async {
    final box = await Hive.openBox('auth');
    await box.delete('token');
  }
}

bool isTokenExpired() {
  
  DateTime currentTime = DateTime.now();

  DateTime expiryTime = currentTime.add(const Duration(hours: 1));

  if (currentTime.isAfter(expiryTime)) {
    return true;
  } else {
    return false;
  }
}