// ignore_for_file: file_names, library_prefixes, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:shared_preferences/shared_preferences.dart';

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
    Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      monitorConnection();
    });
  }

  var inpeksi = <Inpeksi>[].obs;
  bool stopPhotoUpload = false;

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

  Future<bool> sendLocalDataToServer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? inspeksiListJson =
          prefs.getStringList('inspeksi_list$order');

      if (inspeksiListJson != null && inspeksiListJson.isNotEmpty) {
        // Mengonversi List<String> JSON menjadi List<Map<String, dynamic>>
        List<Map<String, dynamic>> dataList = inspeksiListJson
            .map((dataString) => jsonDecode(dataString))
            .cast<Map<String, dynamic>>()
            .toList();

        // Kirim seluruh list inspeksi ke server menggunakan metode addPeralatans atau metode yang sesuai dalam controller Anda
        bool berhasil = await sendListToServer(dataList);

        // Hapus seluruh data dari SharedPreferences setelah mencoba mengirimnya ke server

        if (berhasil) {
          prefs.remove('inspeksi_list$order');
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

        Inpeksi inspeksi = Inpeksi.fromJson(data);
        File? buktiFoto;
        if (inspeksi.buktiFotoPath != null &&
            inspeksi.buktiFotoPath!.isNotEmpty) {
          buktiFoto = Inpeksi.base64ToImage(
            inspeksi.buktiFoto,
            inspeksi.buktiFotoPath!,
          );
        }

        bool berhasil = await addInpeksi(inspeksi, order, buktiFoto!);
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
      if (response.statusCode == 409) {
        stopPhotoUpload =
            true; // Hentikan proses pengiriman foto jika respons adalah 409
        return false;
      }

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
