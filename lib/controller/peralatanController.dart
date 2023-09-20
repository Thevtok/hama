// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../model/login.dart';
import '../model/peralatan.dart';
import 'apiUrl.dart';

class PeralatanController extends GetxController {
  final Dio _dio = Dio();
  final String order;
 
  PeralatanController({required this.order});

  @override
  void onInit() {
    super.onInit();
    fetchPeralatans(order);
   
  }

  RxList<MonitoringPeralatan> peralatans = <MonitoringPeralatan>[].obs;

  final namaController = TextEditingController();
  final merkController = TextEditingController();
  final jumlahController = TextEditingController();
  final satuanController = TextEditingController();
  final kondisiController = TextEditingController();

  RxBool isLoading = false.obs;

  Options options = Options(
    headers: {
      'Content-Type': 'application/json', // Sesuaikan sesuai kebutuhan Anda
    },
  );
  void setAuthToken(String token) {
    options = Options(
      headers: {
        'Authorization': token, // Tambahkan token ke header Authorization
        'Content-Type': 'application/json', // Sesuaikan sesuai kebutuhan Anda
      },
    );
  }

  Future<void> fetchPeralatans(String order) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response =
          await _dio.get('${ApiUrls.getPeralatan}/$order', options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<MonitoringPeralatan> newPeralatans =
            data.map((json) => MonitoringPeralatan.fromJson(json)).toList();

        peralatans.value = newPeralatans;
      } else if (response.statusCode == 404) {
        // Jika status adalah 404, set peralatans menjadi list kosong
        peralatans.value = [];
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


  Future<bool> addPeralatans(
      MonitoringPeralatan peralatan, String order) async {
    try {
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response = await _dio.post('${ApiUrls.addPeralatan}/$order',
          options: options, data: peralatan.toJson());

      if (response.statusCode == 201) {
        final addedPeralatan = MonitoringPeralatan.fromJson(response.data);
        peralatans.add(addedPeralatan);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}

class PeralatanDateController extends GetxController {
   final Dio _dio = Dio();
    final String order;
  final String tanggal;
   PeralatanDateController({required this.order, required this.tanggal});
     RxList<MonitoringPeralatan> peralatansDate = <MonitoringPeralatan>[].obs;

      @override
  void onInit() {
    super.onInit();
   
    fetchPeralatansDate(order, tanggal);
  }
  
  RxBool isLoading = false.obs;

  Options options = Options(
    headers: {
      'Content-Type': 'application/json', // Sesuaikan sesuai kebutuhan Anda
    },
  );
  void setAuthToken(String token) {
    options = Options(
      headers: {
        'Authorization': token, // Tambahkan token ke header Authorization
        'Content-Type': 'application/json', // Sesuaikan sesuai kebutuhan Anda
      },
    );
  }
  
  Future<void> fetchPeralatansDate(String order, String date) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response = await _dio.get('${ApiUrls.getPeralatan}/$order/$date',
          options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<MonitoringPeralatan> newPeralatans =
            data.map((json) => MonitoringPeralatan.fromJson(json)).toList();

        peralatansDate.value = newPeralatans;
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
