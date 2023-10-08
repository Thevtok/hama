// ignore_for_file: file_names, library_prefixes, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/daily.dart';
import '../model/login.dart';

import 'apiUrl.dart';

class DailynController extends GetxController {
  final Dio.Dio _dio = Dio.Dio();
  final String order;

  DailynController({
    required this.order,
  });

  @override
  void onInit() {
    super.onInit();
    fetchDaily(order);
    Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      monitorConnection();
    });
  }

  var dailys = <Daily>[].obs;
  bool stopPhotoUpload = false;

  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final jenisController = TextEditingController();
  final hamaController = TextEditingController();
  final jumlahController = TextEditingController();
  final keteranganController = TextEditingController();

  RxBool isLoading = false.obs;
  bool tambahDaily = true;

  Dio.Options options = Dio.Options(
    headers: {
      'Content-Type': 'application/json', // Sesuaikan sesuai kebutuhan Anda
    },
  );
  void setAuthToken(String token) {
    options = Dio.Options(
      headers: {
        'Authorization': token, // Tambahkan token ke header Authorization
        'Content-Type': 'application/json', // Sesuaikan sesuai kebutuhan Anda
      },
    );
  }

  Future<void> fetchDaily(String order) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response =
          await _dio.get('${ApiUrls.getDaily}/$order', options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<Daily> newDaily =
            data.map((json) => Daily.fromJson(json)).toList();

        dailys.value = newDaily;
      } else if (response.statusCode == 404) {
        dailys.value = [];
        debugPrint('Tidak ada data daily ditemukan');
      } else {
        debugPrint('Gagal mengambil data daily: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendLocalDataToServer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? dailyListJson = prefs.getStringList('daily_list$order');

      if (dailyListJson != null && dailyListJson.isNotEmpty) {
        // Mengonversi List<String> JSON menjadi List<Map<String, dynamic>>
        List<Map<String, dynamic>> dataList = dailyListJson
            .map((dataString) => jsonDecode(dataString))
            .cast<Map<String, dynamic>>()
            .toList();

        // Kirim seluruh list daily ke server menggunakan metode addPeralatans atau metode yang sesuai dalam controller Anda
        bool berhasil = await sendListToServer(dataList);

        // Hapus seluruh data dari SharedPreferences setelah mencoba mengirimnya ke server

        if (berhasil) {
          prefs.remove('daily_list$order');
          print('Data lokal berhasil dikirim ke server!');
          return true;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  Future<bool> sendListToServer(List<Map<String, dynamic>> dataList) async {
    try {
      // Contoh pengiriman data ke server
      for (var data in dataList) {
        if (stopPhotoUpload) {
          return false; // Hentikan pengiriman jika stopPhotoUpload adalah true
        }

        Daily daily = Daily.fromJson(data);
        File? buktiFoto;
        if (daily.buktiFotoPath != null && daily.buktiFotoPath!.isNotEmpty) {
          buktiFoto = Daily.base64ToImage(
            daily.buktiFoto,
            daily.buktiFotoPath!,
          );
        }

        bool berhasil = await addDaily(daily, order, buktiFoto!);
        if (!berhasil) {
          stopPhotoUpload =
              true; // Set stopPhotoUpload ke true jika terjadi kesalahan
          return false;
        }
        print('Data berhasil dikirim ke server!');
      }

      return true;
    } catch (e) {
      print('Error: $e');
      stopPhotoUpload =
          true; // Set stopPhotoUpload ke true jika terjadi kesalahan
      return false;
    }
  }

  bool isDataTerkirim = false; // Tambahkan variabel flag

  Future<void> monitorConnection() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if ((result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) &&
        !isDataTerkirim) {
      // Periksa apakah data belum terkirim
      bool dataTerkirim = await sendLocalDataToServer();
      if (dataTerkirim) {
        isDataTerkirim = true;
        Get.snackbar(
          'Sukses',
          'Data lokal daily berhasil dikirim ke server!',
          snackPosition: SnackPosition.BOTTOM,
        );
        print('Data lokal berhasil dikirim ke server!');
      }
    }
  }

  Future<bool> addDaily(Daily daily, String order, File buktiFoto) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);

      final formData = Dio.FormData.fromMap({
        'name': daily.name,
        'no_order': daily.noOrder,
        'lokasi': daily.lokasi,
        'jenis_treatment': daily.jenisTreatment,
        'hama_ditemukan': daily.hamaDitemukan,
        'jumlah': daily.jumlah.toString(),
        'tanggal': daily.tanggal,
        'bukti_foto': await Dio.MultipartFile.fromFile(
          buktiFoto.path,
        ),
        'keterangan': daily.keterangan,
      });

      final response = await _dio.post(
        '${ApiUrls.addDaily}/$order',
        options: options,
        data: formData,
      );

      if (response.statusCode == 409) {
        stopPhotoUpload =
            true; // Hentikan proses pengiriman foto jika respons adalah 409
        return false;
      }

      if (response.statusCode == 201) {
        tambahDaily = true;
        return true;
      } else {
        debugPrint('Gagal menambahkan daily: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

class DailyDateController extends GetxController {
  final Dio.Dio _dio = Dio.Dio();
  final String order;
  final String tanggal;
  DailyDateController({required this.order, required this.tanggal});

  @override
  void onInit() {
    super.onInit();

    fetchDailyDate(order, tanggal);
  }

  var dailyDate = <Daily>[].obs;
  RxBool isLoading = false.obs;

  Dio.Options options = Dio.Options(
    headers: {
      'Content-Type': 'application/json',
    },
  );
  void setAuthToken(String token) {
    options = Dio.Options(
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );
  }

  Future<void> fetchDailyDate(String order, String date) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response =
          await _dio.get('${ApiUrls.getDaily}/$order/$date', options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<Daily> newDaily =
            data.map((json) => Daily.fromJson(json)).toList();

        dailyDate.value = newDaily;
      } else if (response.statusCode == 404) {
        // Jika status adalah 404, set dailyDate menjadi list kosong
        dailyDate.value = [];
        debugPrint('Tidak ada data daily ditemukan');
      } else {
        debugPrint('Gagal mengambil data daily: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
