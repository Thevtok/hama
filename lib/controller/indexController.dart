// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/model/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login.dart';
import 'apiUrl.dart';

class IndexController extends GetxController {
  final Dio _dio = Dio();
  final String order;

  IndexController({
    required this.order,
  });

  @override
  void onInit() {
    super.onInit();
    fetchIndexs(order);
      Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      monitorConnection();
    });
  }

  var indexs = <PerhitunganIndex>[].obs;

  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final tanggalController = TextEditingController();
  final jumlahController = TextEditingController();
  final jenisController = TextEditingController();
  final indexController = TextEditingController();
  final statusController = TextEditingController();

  RxBool isLoading = false.obs;

  Options options = Options(
    headers: {
      'Content-Type': 'application/json',
    },
  );
  void setAuthToken(String token) {
    options = Options(
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );
  }
    Future<bool> sendLocalDataToServer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? peralatanListJson = prefs.getStringList('index_list$order');

      if (peralatanListJson != null && peralatanListJson.isNotEmpty) {
        // Mengonversi List<String> JSON menjadi List<Map<String, dynamic>>
        List<Map<String, dynamic>> dataList = peralatanListJson
            .map((dataString) => jsonDecode(dataString))
            .cast<Map<String, dynamic>>()
            .toList();

        // Kirim seluruh list peralatan ke server menggunakan metode addPeralatans atau metode yang sesuai dalam controller Anda
        bool berhasil = await sendListToServer(dataList);

        if (berhasil) {
          // Hapus seluruh data dari SharedPreferences jika berhasil terkirim
          prefs.remove('index_list$order');
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
        PerhitunganIndex peralatan = PerhitunganIndex.fromJson(data);
        bool berhasil = await addIndex(peralatan, order);
        if (!berhasil) {
          // Handle kesalahan jika gagal mengirimkan data tertentu
          return false;
        }
      }
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> monitorConnection() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      bool dataTerkirim = await sendLocalDataToServer();
      if (dataTerkirim) {
        Get.snackbar(
          'Sukses',
          'Data lokal index berhasil dikirim ke server!',
          snackPosition: SnackPosition.BOTTOM, // Atur posisi snack bar
        );
      }
    }
  }

  Future<void> fetchIndexs(String order) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response =
          await _dio.get('${ApiUrls.getIndex}/$order', options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<PerhitunganIndex> newIndexs =
            data.map((json) => PerhitunganIndex.fromJson(json)).toList();

        indexs.value = newIndexs;
      } else if (response.statusCode == 404) {
        indexs.value = [];
        debugPrint('Tidak ada data index ditemukan');
      } else {
        debugPrint('Gagal mengambil data index: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addIndex(PerhitunganIndex index, String order) async {
    try {
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response = await _dio.post('${ApiUrls.addIndex}/$order',
          options: options, data: index.toJson());

      if (response.statusCode == 201) {
        final addedPeralatan = PerhitunganIndex.fromJson(response.data);
        indexs.add(addedPeralatan);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}

class IndexDateController extends GetxController {
  final Dio _dio = Dio();
  final String order;
  final String tanggal;
  IndexDateController({required this.order, required this.tanggal});

  @override
  void onInit() {
    super.onInit();

    fetchIndexsDate(order, tanggal);
  }

  var indexDate = <PerhitunganIndex>[].obs;

  RxBool isLoading = false.obs;

  Options options = Options(
    headers: {
      'Content-Type': 'application/json',
    },
  );
  void setAuthToken(String token) {
    options = Options(
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );
  }

  Future<void> fetchIndexsDate(String order, String date) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response =
          await _dio.get('${ApiUrls.getIndex}/$order/$date', options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<PerhitunganIndex> newIndexs =
            data.map((json) => PerhitunganIndex.fromJson(json)).toList();

        indexDate.value = newIndexs;
      } else if (response.statusCode == 404) {
        indexDate.value = [];
        debugPrint('Tidak ada data peralatan ditemukan');
      } else {
        debugPrint('Gagal mengambil data order: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
