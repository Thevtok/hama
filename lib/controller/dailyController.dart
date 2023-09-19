// ignore_for_file: file_names, library_prefixes

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Dio;

import '../model/daily.dart';
import '../model/login.dart';

import 'apiUrl.dart';

class DailynController extends GetxController {
  final Dio.Dio _dio = Dio.Dio();
  final String order;
  final String tanggal;
  DailynController({required this.order, required this.tanggal});

  @override
  void onInit() {
    super.onInit();
    fetchDaily(order);
    fetchDailyDate(order, tanggal);
  }

  var dailys = <Daily>[].obs;
  var dailyDate = <Daily>[].obs;
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
