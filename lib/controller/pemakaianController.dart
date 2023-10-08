// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/model/pemakaian.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login.dart';
import 'apiUrl.dart';

class PemakaianController extends GetxController {
  final Dio _dio = Dio();
  final String order;

  PemakaianController({
    required this.order,
  });

  @override
  void onInit() {
    super.onInit();
    fetchPemakaians(order);
    Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      monitorConnection();
    });
  }

  var pemakaians = <Pemakaian>[].obs;

  final namaController = TextEditingController();
  final bahanController = TextEditingController();
  final merkController = TextEditingController();
  final stokAwalController = TextEditingController();
  final satuanController = TextEditingController();
  final insController = TextEditingController();
  final outsController = TextEditingController();
  final stokAkhirController = TextEditingController();
  final satuanBController = TextEditingController();

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
      List<String>? peralatanListJson =
          prefs.getStringList('pemakaian_list$order');

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
          prefs.remove('pemakaian_list$order');
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
        Pemakaian peralatan = Pemakaian.fromJson(data);
        bool berhasil = await addPemakaian(peralatan, order);
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
          'Data lokal peralatan berhasil dikirim ke server!',
          snackPosition: SnackPosition.BOTTOM, // Atur posisi snack bar
        );
      }
    }
  }

  Future<void> fetchPemakaians(String order) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response =
          await _dio.get('${ApiUrls.getPemakaian}/$order', options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<Pemakaian> newPemakaians =
            data.map((json) => Pemakaian.fromJson(json)).toList();

        pemakaians.value = newPemakaians;
      } else if (response.statusCode == 404) {
        pemakaians.value = [];
        debugPrint('Tidak ada data pemakaian ditemukan');
      } else {
        debugPrint('Gagal mengambil data pemakaian: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addPemakaian(Pemakaian pemakaian, String order) async {
    try {
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response = await _dio.post('${ApiUrls.addPemakaian}/$order',
          options: options, data: pemakaian.toJson());

      if (response.statusCode == 201) {
        final addedPeralatan = Pemakaian.fromJson(response.data);
        pemakaians.add(addedPeralatan);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}

class PemakaianDateController extends GetxController {
  final Dio _dio = Dio();
  final String order;
  final String tanggal;
  PemakaianDateController({required this.order, required this.tanggal});

  @override
  void onInit() {
    super.onInit();

    fetchPemakaiansDate(order, tanggal);
  }

  var pemakaianDate = <Pemakaian>[].obs;

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

  Future<void> fetchPemakaiansDate(String order, String date) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response = await _dio.get('${ApiUrls.getPemakaian}/$order/$date',
          options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<Pemakaian> newPemakaians =
            data.map((json) => Pemakaian.fromJson(json)).toList();

        pemakaianDate.value = newPemakaians;
      } else if (response.statusCode == 404) {
        pemakaianDate.value = [];
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
