// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../model/login.dart';
import 'apiUrl.dart';

class AuthController extends GetxController {
  final Dio _dio = Dio(); // Inisialisasi objek Dio

  Future<bool> login(UserLogin user) async {
    try {
      // Lakukan permintaan POST untuk login
      final response = await _dio.post(
        ApiUrls.loginUrl,
        data: user.toJson(), // Menggunakan method toJson pada model UserLogin
      );

      // Cek status kode respons
      if (response.statusCode == 200) {
        // Jika berhasil, simpan token dalam variabel
        var token = response.data['token'];
        await HiveService.saveToken(token);
        return true;
      } else {
        // Jika gagal, Anda dapat menangani kesalahan di sini
        debugPrint('Gagal login: ${response.statusCode}');
      }
    } catch (error) {
      // Tangani kesalahan jaringan atau kesalahan lainnya
      debugPrint('Kesalahan: $error');
    }
    return false;
  }
}
