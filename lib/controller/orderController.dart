// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../model/login.dart';
import '../model/order.dart';
import 'apiUrl.dart';

class OrderController extends GetxController {
  final Dio _dio = Dio();
  final orderText = TextEditingController();

  RxList<Order> orders = <Order>[].obs;
  RxList<Order> filteredOrders =
      <Order>[].obs; // Daftar order yang sudah difilter
  RxString searchQuery = ''.obs; // Query pencarian
  RxBool isLoading = false.obs; // Status loading

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  @override
  void onReady() {
    super.onReady();
    fetchOrders();
  }

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

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response = await _dio.get(ApiUrls.getOrder, options: options);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<Order> newOrders =
            data.map((json) => Order.fromJson(json)).toList();

        orders.value = newOrders;
        filterOrders(); // Filter order saat data sudah diambil
      } else {
        debugPrint('Gagal mengambil data order: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOrder(Order newOrder) async {
    try {
      final token = await HiveService.getToken();
      setAuthToken(token!);
      final response = await _dio.post(ApiUrls.addOrder,
          options: options, data: newOrder.toJson());

      if (response.statusCode == 201) {
        final addedOrder = Order.fromJson(response.data);
        orders.add(addedOrder);
      } else {
        debugPrint('Gagal menambahkan order: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Kesalahan: $error');
    } finally {}
  }

  void filterOrders() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredOrders.value = orders; // Jika query kosong, tampilkan semua order
    } else {
      filteredOrders.value = orders
          .where((order) => order.noOrder.toLowerCase().contains(query))
          .toList();
    }
  }
}
