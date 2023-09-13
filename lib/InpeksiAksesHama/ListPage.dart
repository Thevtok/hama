// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';
import '../monitoringPeralatan/fromData.dart';
import '../perhitunganIndex/listPage.dart';

class ListInpeksi extends StatelessWidget {
  final String item;
  ListInpeksi({
    Key? key,
    required this.item,
  }) : super(key: key);
  List<String> fromData = [
    'Inpeksi 1',
    'Inpeksi 2',
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
              'Inpeksi Akses Hama',
              style: TextStyle(color: grey, fontSize: 16),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  showMyDialog(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: blue,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Tambah Hasil Inpeksi',
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
              height: 20,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: fromData.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: buildListItem(fromData[index], context)),
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
      height: MediaQuery.of(context).size.height * 0.5,
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
                children: [kondisiLabel('Lokasi'), kondisiTextField(context)],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [kondisiLabel('Tanggal'), kondisiTextField(context)],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text('Bukti Foto'),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        height: 120,
                        width: 180,
                        color: grey,
                      ))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kondisiLabel('Keterangan'),
                  kondisiTextField(context)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kondisiLabel('Rekomendasi'),
                  kondisiTextField(context)
                ],
              ),
            ],
          ),
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
          title: Center(
            child: Text(
              'Tambah Isian',
              style: TextStyle(color: white, fontWeight: FontWeight.w500),
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [labelDialog('Lokasi'), texfieldDialog(context)],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [labelDialog('Tanggal'), texfieldDialog(context)],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'Bukti Foto',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          height: 80,
                          width: 120,
                          color: grey,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    labelDialog('Keterangan'),
                    texfieldDialog(context)
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    labelDialog('Rekomendasi'),
                    texfieldDialog(context)
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                AddButton(onTap: () {}, text: 'Add', lebar: 0.45)
              ],
            ),
          ));
    },
  );
}

Widget labelDialog(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Text(
      label,
      style: const TextStyle(fontSize: 12),
    ),
  );
}

