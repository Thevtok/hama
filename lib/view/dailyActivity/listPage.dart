// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, invalid_use_of_protected_member, unused_local_variable
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/controller/dailyController.dart';
import '../../view/dailyActivity/listData.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';
import 'date.dart';

class ListDailyActivity extends StatelessWidget {
  final String item;

  ListDailyActivity({
    Key? key,
    required this.item,
  }) : super(key: key) {
    final dailyController = Get.put(DailynController(
      order: item,
    ));
  }

  Set<String> tanggalSet = <String>{};

  @override
  Widget build(BuildContext context) {
    final dailyController = Get.find<DailynController>();

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
            'Daily Activity',
            style: TextStyle(color: grey, fontSize: 16),
          ),
          const SizedBox(
            height: 30,
          ),
          AddButton(
              onTap: () {
                Get.to(() => DateDailyActivity(item: item));
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
                'Form Daily Activity',
                style: TextStyle(color: grey, fontSize: 16),
              ),
            ),
          ),
          Obx(() {
            if (dailyController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: dailyController.dailys.length,
                  itemBuilder: (BuildContext context, int index) {
                    final daily = dailyController.dailys[index];
                    if (!tanggalSet.contains(daily.tanggal)) {
                      tanggalSet.add(daily.tanggal!);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: InkWell(
                          onTap: () async {
                            Get.to(() => ListDataDaily(
                                item: item, selectedDateForGo: daily.tanggal!));
                          },
                          child: Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 1)),
                            padding: const EdgeInsets.all(5),
                            child: Text(daily.tanggal!),
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
