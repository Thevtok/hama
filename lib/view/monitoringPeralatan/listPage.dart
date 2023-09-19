// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, invalid_use_of_protected_member
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/controller/peralatanController.dart';
import '../../view/monitoringPeralatan/listData.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';
import 'date.dart';

class ListMonitorPeralatan extends StatelessWidget {
  final String item;

  ListMonitorPeralatan({
    Key? key,
    required this.item,
  }) : super(key: key);

  Set<String> tanggalSet = <String>{};

  @override
  Widget build(BuildContext context) {
    final peralatanController =
        Get.put(PeralatanController(tanggal: '', order: item));
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
            'Monitoring Peralatan',
            style: TextStyle(color: grey, fontSize: 16),
          ),
          const SizedBox(
            height: 30,
          ),
          AddButton(
              onTap: () {
                Get.to(DatePeralatan(item: item));
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
                'Form Monitoring Peralatan',
                style: TextStyle(color: grey, fontSize: 16),
              ),
            ),
          ),
          Obx(() {
            if (peralatanController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: peralatanController.peralatans.length,
                itemBuilder: (BuildContext context, int index) {
                  final peralatan = peralatanController.peralatans[index];
                  if (!tanggalSet.contains(peralatan.tanggal)) {
                    tanggalSet.add(peralatan.tanggal);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () async {
                          
                          Get.to(ListDataPeralatan(
                            item: item,
                            selectedDateForGo: peralatan.tanggal,
                            
                          ));
                        },
                        child: Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          padding: const EdgeInsets.all(5),
                          child: Text(peralatan.tanggal),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            }
          }),
        ],
      ),
    );
  }
}
