// ignore_for_file: file_names, must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/pemakaianController.dart';
import '../home/jobPage.dart';
import '../home/loginPage.dart';
import '../monitoringPeralatan/listData.dart';

class ListDataPemakaian extends StatelessWidget {
  String selectedDateForGo;
  final String item;

  ListDataPemakaian({
    super.key,
    required this.selectedDateForGo,
    required this.item,
  }){
 final pemakaianController =
        Get.put(PemakaianDateController(order: item, tanggal: selectedDateForGo));
  }

  @override
  Widget build(BuildContext context) {
     final pemakaianController =
        Get.find<PemakaianDateController>();
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
              'Monitoring Pemakaian',
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
              if (pemakaianController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pemakaianController.pemakaianDate.length,
                  itemBuilder: (BuildContext context, int index) {
                    final pemakaian = pemakaianController.pemakaianDate[index];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.44,
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
                                            pemakaian.name,
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
                                          labelText: 'Bahan Aktif',
                                          value: pemakaian.bahanAktif),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Merk',
                                          value: pemakaian.merk),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Stok Awal',
                                          value: pemakaian.stokAwal.toString()),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Satuan',
                                          value: pemakaian.satuan),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataMutasi(
                                        labelText: 'Mutasi',
                                        ins: pemakaian.ins.toString(),
                                        out: pemakaian.out.toString(),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Stok Akhir',
                                          value:
                                              pemakaian.stokAkhir.toString()),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Satuan',
                                          value: pemakaian.satuanb),
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

class ListDataMutasi extends StatelessWidget {
  final String labelText;
  final String ins;
  final String out;

  const ListDataMutasi({
    super.key,
    required this.labelText,
    required this.ins,
    required this.out,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            labelText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const Text(
          'In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
                  child: Text(ins),
                )),
          ),
        ),
        const Text(
          'Out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
                  child: Text(out),
                )),
          ),
        ),
      ],
    );
  }
}
