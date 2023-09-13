// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:hama/InpeksiAksesHama/ListPage.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';
import '../monitoringPeralatan/fromData.dart';

class ListIndex extends StatelessWidget {
  final String item;
  ListIndex({
    Key? key,
    required this.item,
  }) : super(key: key);
  List<String> fromData = [
    'Index 1',
    'Index 2',
  ];
  @override
  Widget build(BuildContext context) {
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
              'Perhitungan Index',
              style: TextStyle(color: grey, fontSize: 16),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 40,
              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: Text(
                  '31 Juli 2023',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  showMyDialog(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: blue,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Tambah Isian',
                      style: TextStyle(
                        color: white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: buildListItem(
                            '$itemNumber.${fromData[index]}', context)),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            ),
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
      height: MediaQuery.of(context).size.height * 0.45,
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
                height: 20,
              ),
              for (var label in [
                'Lokasi',
                'Tanggal',
                'Jumlah',
                'Jenis Hama',
                'Indeks Populasi',
                'Status'
              ])
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(label),
                    ),
                    kondisiTextField(context),
                  ],
                ),
            ],
          )
        ],
      ),
    ),
  );
}

void showMyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 194, 193, 191),
        title: const Center(
          child: Text(
            'Tambah Isian',
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
              buildRow('Lokasi', context),
              const SizedBox(
                height: 5,
              ),
              buildRow('Tanggal', context),
              const SizedBox(
                height: 5,
              ),
              buildRow('Jumlah', context),
              const SizedBox(
                height: 5,
              ),
              buildRow('Jenis Hama', context),
              const SizedBox(
                height: 5,
              ),
              buildRow('Index Populasi', context),
              const SizedBox(
                height: 5,
              ),
              buildRow('Status', context),
              const SizedBox(
                height: 50,
              ),
              AddButton(onTap: () {}, text: 'Add', lebar: 0.43),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildRow(String label, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      labelDialog(label),
      texfieldDialog(context),
    ],
  );
}

Widget texfieldDialog(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Container(
        height: 30,
        width: 120,
        decoration: BoxDecoration(color: white, border: Border.all(width: 1)),
        child: const TextField()),
  );
}
