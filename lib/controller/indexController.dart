// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/model/index.dart';

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
