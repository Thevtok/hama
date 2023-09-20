// ignore_for_file: file_names, library_prefixes

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Dio;

import '../model/inpeksi.dart';
import '../model/login.dart';

import 'apiUrl.dart';

class InpeksiController extends GetxController {
  final Dio.Dio _dio = Dio.Dio();
  final String order;

  InpeksiController({
    required this.order,
  });

  @override
  void onInit() {
    super.onInit();
    fetchInpeksi(order);
  }

  var inpeksi = <Inpeksi>[].obs;

  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final tanggalController = TextEditingController();
  final rekomendasiController = TextEditingController();

  final keteranganController = TextEditingController();

  RxBool isLoading = false.obs;
  bool tambahInpeksi = true;

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

  Future<void> fetchInpeksi(String order) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response =
          await _dio.get('${ApiUrls.getInpeksi}/$order', options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<Inpeksi> newInpeksi =
            data.map((json) => Inpeksi.fromJson(json)).toList();

        inpeksi.value = newInpeksi;
      } else if (response.statusCode == 404) {
        inpeksi.value = [];
        debugPrint('Tidak ada data inpeksi ditemukan');
      } else {
        debugPrint('Gagal mengambil data inpeksi: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addInpeksi(Inpeksi inpeksi, String order, File buktiFoto) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);

      final formData = Dio.FormData.fromMap({
        'name': inpeksi.name,
        'no_order': inpeksi.noOrder,
        'lokasi': inpeksi.lokasi,
        'tanggal': inpeksi.tanggal,
        'bukti_foto': await Dio.MultipartFile.fromFile(
          buktiFoto.path,
        ),
        'keterangan': inpeksi.keterangan,
        'rekomendasi': inpeksi.rekomendasi
      });

      final response = await _dio.post(
        '${ApiUrls.addInpeksi}/$order',
        options: options,
        data: formData,
      );

      if (response.statusCode == 201) {
        tambahInpeksi = true;
        return true;
      } else {
        debugPrint('Gagal menambahkan inpeksi: ${response.statusCode}');
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
