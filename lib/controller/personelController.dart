// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/login.dart';
import '../model/personel.dart';
import 'apiUrl.dart';

class PersonelController extends GetxController {
  final Dio _dio = Dio();
  final nameText = TextEditingController();

  final String order;
  final String tanggal;

  PersonelController({required this.order, required this.tanggal});

  @override
  void onInit() {
    super.onInit();
    getPersonels(order);
    getAbsen(order, tanggal);
  }

  bool tambahPersonel = false;
  RxBool isLoading = false.obs;

  RxList<Personel> personels = <Personel>[].obs;
  RxList<Absen> absens = <Absen>[].obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<DateTime?> selectedDateForGo = Rx<DateTime?>(null);

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

  Future<bool> addPersonel(String order, String name) async {
    try {
      final token = await HiveService.getToken();
      setAuthToken(token!);

      final Map<String, dynamic> requestData = {
        'name': name,
        'no_order': order,
      };

      final response = await _dio.post(
        '${ApiUrls.addPersonel}/$order',
        options: options,
        data: requestData,
      );

      if (response.statusCode == 201) {
        tambahPersonel = true;

        return true;
      } else {
        debugPrint('Gagal menambah data personel: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> absen(
      String name, String tanggal, String keterangan, String order) async {
    try {
      final token = await HiveService.getToken();
      setAuthToken(token!);

      final response = await _dio.post(
        '${ApiUrls.absenPersonel}/$order',
        options: options,
        data: {'tanggal': tanggal, 'keterangan': keterangan, 'name': name},
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        debugPrint('Gagal absen: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
      return false;
    }
  }

  Future<void> getAbsen(String order, String tanggal) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response = await _dio.get('${ApiUrls.getAbsen}/$order/$tanggal',
          options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<Absen> newAbsens =
            data.map((json) => Absen.fromJson(json)).toList();

        absens.assignAll(newAbsens);
      } else {
        debugPrint('Gagal mengambil data personel: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPersonels(String order) async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response =
          await _dio.get('${ApiUrls.getPersonel}/$order', options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<Personel> newPersonels =
            data.map((json) => Personel.fromJson(json)).toList();

        personels.assignAll(newPersonels);
      } else {
        debugPrint('Gagal mengambil data personel: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deletePersonel(String name, String order) async {
    try {
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response = await _dio
          .delete('${ApiUrls.deletePersonel}/$order/$name', options: options);

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Gagal menghapus personel: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
      return false;
    }
  }

  Future<bool> updatePersonel(String order, String name, String nama) async {
    try {
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final Map<String, dynamic> data = {
        "newData": {"name": nama}
      };

      final response = await _dio.put(
        '${ApiUrls.updatePersonel}/$order/$name',
        options: options,
        data: data,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Gagal memperbarui personel: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
      return false;
    }
  }
}
