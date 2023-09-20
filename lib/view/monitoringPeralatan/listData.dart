// ignore_for_file: file_names, must_be_immutable, unused_local_variable
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hama/controller/peralatanController.dart';
import '../home/jobPage.dart';
import '../home/loginPage.dart';

class ListDataPeralatan extends StatelessWidget {
  final String selectedDateForGo;
  final String item;

  ListDataPeralatan({
    Key? key,
    required this.selectedDateForGo,
    required this.item,
  }) : super(key: key) {
    final peralatanController =
        Get.put(PeralatanDateController(order: item, tanggal: selectedDateForGo));
   
  }
  @override
  Widget build(BuildContext context) {
    final peralatanController = Get.find<PeralatanDateController>();

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
              'Monitoring Peralatan',
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
              if (peralatanController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: peralatanController.peralatansDate.length,
                  itemBuilder: (BuildContext context, int index) {
                    final peralatan = peralatanController.peralatansDate[index];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
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
                                          labelText: 'Merk',
                                          value: peralatan.merek),
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
                                          labelText: 'Satuan',
                                          value: peralatan.satuan),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Kondisi',
                                          value: peralatan.kondisi),
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

class ListDataRow extends StatelessWidget {
  final String labelText;
  final String value;

  const ListDataRow({super.key, required this.labelText, required this.value});

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
              height: 30,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(border: Border.all()),
              child: Center(
                child: Text(value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
