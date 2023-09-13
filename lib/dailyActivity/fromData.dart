// ignore_for_file: file_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:hama/home/loginPage.dart';

import 'package:intl/intl.dart';

import '../home/jobPage.dart';
import '../monitoringPeralatan/fromData.dart';

class FromDataDailyActivity extends StatefulWidget {
  DateTime? selectedDateForGo;
  final String item;
  FromDataDailyActivity(
      {super.key, this.selectedDateForGo, required this.item});

  @override
  State<FromDataDailyActivity> createState() => _FromDataDailyActivityState();
}

class _FromDataDailyActivityState extends State<FromDataDailyActivity> {
  List<String> fromData = [
    'Activity 1',
    'Activity 2',
    'Activity 3',
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
                  formattedDate,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AddButton(onTap: (){}, text: 'Tambah Activity', lebar: 0.5)
          
            ,
            const SizedBox(
              height: 5,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: fromData.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildListItem(fromData[index], context),
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
      height: MediaQuery.of(context).size.height * 0.63,
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
                children: [kondisiLabel('Merk'), kondisiTextField(context)],
              ),
              const SizedBox(
                height: 5,
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
                children: [
                  kondisiLabel('Jenis Treatment'),
                  kondisiTextField(context)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kondisiLabel('Hama Ditemukan'),
                  kondisiTextField(context)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [kondisiLabel('Jumlah'), kondisiTextField(context)],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
            ],
          ),
        ],
      ),
    ),
  );
}
