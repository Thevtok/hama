// ignore_for_file: file_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:hama/home/loginPage.dart';

import 'package:intl/intl.dart';

import '../home/jobPage.dart';
import '../monitoringPeralatan/fromData.dart';

class FromDataMonitoringPemakaian extends StatefulWidget {
  DateTime? selectedDateForGo;
  final String item;
  FromDataMonitoringPemakaian(
      {super.key, this.selectedDateForGo, required this.item});

  @override
  State<FromDataMonitoringPemakaian> createState() =>
      _FromDataMonitoringPemakaianState();
}

class _FromDataMonitoringPemakaianState
    extends State<FromDataMonitoringPemakaian> {
  List<String> fromData = [
    'sabun',
    'shampo',
    'sikat',
    'sabun',
    'shampo',
    'sikat',
    'sabun',
    'shampo',
    'sikat',
  ];
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM dd, yyyy')
        .format(widget.selectedDateForGo ?? DateTime.now());
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
              widget.item,
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
                  formattedDate,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 5,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: fromData.length,
              itemBuilder: (BuildContext context, int index) {
                int itemNumber = index + 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildListItem(
                                '$itemNumber.${fromData[index]}', context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              },
            ),
            AddButton(onTap: () {}, text: 'Save', lebar: 0.5)
          ],
        ),
      ),
    );
  }
}

Widget buildListItem(String item, BuildContext context) {
  return InkWell(
    onTap: () {},
    child: Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: grey.withOpacity(0.1),
              border: Border.all(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(item),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kondisiLabel('Bahan Aktif'),
                  kondisiTextField(context)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [kondisiLabel('Merk'), kondisiTextField(context)],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kondisiLabel('Stok Awal'),
                  kondisiTextField(context)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [kondisiLabel('Satuan'), kondisiTextField(context)],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  kondisiLabel('Mutasi'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  const Text('In'),
                  Expanded(child: kondisiTextField(context)),
                  const Text('Out'),
                  Expanded(child: kondisiTextField(context)),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kondisiLabel('Stok Akhir'),
                  kondisiTextField(context)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [kondisiLabel('Satuan'), kondisiTextField(context)],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
