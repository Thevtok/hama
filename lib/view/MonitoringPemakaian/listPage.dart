// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/controller/pemakaianController.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';
import 'date.dart';
import 'listData.dart';

class ListPemakaianPage extends StatelessWidget {
  final String item;

  ListPemakaianPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  Set<String> tanggalSet = <String>{};

  @override
  Widget build(BuildContext context) {
    final pemakaianController =
        Get.put(PemakaianController(order: item));
    return Scaffold(
      body: Column(
        children: [
          backLogout(context),
          richHama(context),
          const SizedBox(
            height: 30,
          ),
          Text(
            item,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25.0,
              color: grey,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Monitoring Pemakaian',
            style: TextStyle(color: grey, fontSize: 16),
          ),
          const SizedBox(
            height: 30,
          ),
          AddButton(
              onTap: () {
                Get.to(DateMonitoringPemakaian(item: item));
              },
              text: 'Tambah Form',
              lebar: 0.5),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Form Monitoring Pemakaian',
                style: TextStyle(color: grey, fontSize: 16),
              ),
            ),
          ),
          Obx(() {
            if (pemakaianController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: pemakaianController.pemakaians.length,
                  itemBuilder: (BuildContext context, int index) {
                    final daily = pemakaianController.pemakaians[index];
                    if (!tanggalSet.contains(daily.tanggal)) {
                      tanggalSet.add(daily.tanggal);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: InkWell(
                          onTap: () async {
                            Get.to(()=>ListDataPemakaian(
                                item: item, selectedDateForGo: daily.tanggal));
                          },
                          child: Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 1)),
                            padding: const EdgeInsets.all(5),
                            child: Text(daily.tanggal),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  });
            }
          }),
        ],
      ),
    );
  }
}
