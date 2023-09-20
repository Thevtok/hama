// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/controller/indexController.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';
import '../monitoringPeralatan/listData.dart';

class ListDataIndex extends StatelessWidget {
  final String selectedDateForGo;
  final String item;

  const ListDataIndex({
    super.key,
    required this.selectedDateForGo,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final indexController =
        Get.put(IndexDateController(order: item, tanggal: selectedDateForGo));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            backLogout(context),
            richHama(context),
            const SizedBox(
              height: 30,
            ),
            Text(
              item,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Perhitungan Indeks',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 40,
              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  selectedDateForGo,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Obx(() {
              if (indexController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: indexController.indexDate.length,
                  itemBuilder: (BuildContext context, int index) {
                    final peralatan = indexController.indexDate[index];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 35,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: grey.withOpacity(0.1),
                                          border: Border.all(),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            peralatan.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      ListDataRow(
                                          labelText: 'Lokasi',
                                          value: peralatan.lokasi),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Tanggal',
                                          value: peralatan.tanggal),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Jumlah',
                                          value: peralatan.jumlah.toString()),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Jenis Hama',
                                          value: peralatan.jenisHama),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Indeks Populasi',
                                          value: peralatan.indeksPopulasi
                                              .toString()),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Status',
                                          value: peralatan.status),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  },
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
