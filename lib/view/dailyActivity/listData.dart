// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/controller/dailyController.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';
import '../monitoringPeralatan/listData.dart';

class ListDataDaily extends StatelessWidget {
  String selectedDateForGo;
  final String item;

  ListDataDaily({
    super.key,
    required this.selectedDateForGo,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final dailyController =
        Get.put(DailynController(order: item, tanggal: selectedDateForGo));
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
              'Daily Activity',
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
              if (dailyController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dailyController.dailyDate.length,
                  itemBuilder: (BuildContext context, int index) {
                    final daily = dailyController.dailyDate[index];

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
                                            daily.name!,
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
                                          value: daily.lokasi!),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Jenis Treatment',
                                          value: daily.jenisTreatment!),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Hama Ditemukan',
                                          value: daily.hamaDitemukan!),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    
                                      ListDataRow(
                                          labelText: 'Jumlah',
                                          value: daily.jumlah.toString()),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListImageRow(
                                          labelText: 'Bukti Foto',
                                          value: daily.buktiFoto),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Keterangan',
                                          value: daily.keterangan!),
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

class ListImageRow extends StatelessWidget {
  final String labelText;
  final String value;

  const ListImageRow({super.key, required this.labelText, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            labelText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://aa61-125-164-19-202.ngrok.io/api/uploads/$value'))),
            ),
          ),
        ),
      ],
    );
  }
}
