// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/model/order.dart';

import 'package:hama/controller/orderController.dart';
import '../../model/login.dart';
import 'jobPage.dart';
import 'loginPage.dart';

class OrderPage extends StatelessWidget {
  final orderController = Get.put(OrderController());

  OrderPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    final token =  HiveService.getToken();
    if  (token == null) {
      
      return const LoginPage(); 
    } 
    else {
        double screenHeight = MediaQuery.of(context).size.height;
    double doble = screenHeight * 0.13;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            backLogout(context),
            richHama(context),
            const SizedBox(
              height: 30,
            ),
            AddButton(
                onTap: () {
                  showOrderDialog(context, orderController);
                },
                text: 'Tambah Order',
                lebar: 0.4),
            Padding(
              padding: EdgeInsets.fromLTRB(30, doble, 30, 0),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Center(
                    child: Text(
                      'Nomor Order',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25.0,
                        color: grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        orderController.searchQuery.value = value;
                        orderController.filterOrders();
                      },
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            orderController.filterOrders();
                          },
                          icon: const Icon(Icons.search),
                        ),
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Obx(
                    () {
                      if (orderController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderController.filteredOrders.length,
                          itemBuilder: (BuildContext context, int index) {
                            final order = orderController.filteredOrders[index];
                            return ListOrder(order.noOrder, order.id!, context);
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    }
   
  }
}

void showOrderDialog(BuildContext context, OrderController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 194, 193, 191),
        title: const Center(
          child: Text(
            'Tambah Order',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text('Nama'),
                  ),
                  Container(
                    height: 30,
                    width: 120,
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: controller.orderText,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              AddButton(
                  onTap: () async {
                    controller.addOrder(Order(
                        noOrder: controller.orderText.text,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now()));
                    controller.orderText.text = '';
                    await controller.fetchOrders();
                    Navigator.of(context).pop();
                  },
                  text: 'Add',
                  lebar: 0.43),
            ],
          ),
        ),
      );
    },
  );
}

Widget ListOrder(String item, int id, BuildContext context) {
  return InkWell(
    onTap: () {
      Get.to(JobPage(
        item: item,
        id: id,
      ));
    },
    child: Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('$id - $item'),
      ),
    ),
  );
}
