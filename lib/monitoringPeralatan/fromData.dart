// ignore_for_file: file_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:hama/home/loginPage.dart';

import 'package:intl/intl.dart';

import '../home/jobPage.dart';

class FromDataPeralatan extends StatefulWidget {
  DateTime? selectedDateForGo;
  final String item;
  FromDataPeralatan({super.key, this.selectedDateForGo, required this.item});

  @override
  State<FromDataPeralatan> createState() => _FromDataPeralatanState();
}

class _FromDataPeralatanState extends State<FromDataPeralatan> {
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
                  formattedDate,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: fromData.length,
              itemBuilder: (BuildContext context, int index) {
                int itemNumber = index + 1; // Tambahkan 1 untuk nomor awal
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    )
                  ],
                );
              },
            ),
            AddButton(onTap: (){}, text: 'Save', lebar: 0.5)
          
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
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(border: Border.all()),
        child: Column(children: [
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
              for (var label in ['Merk', 'Jumlah', 'Satuan', 'Kondisi'])
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: 100, // Sesuaikan lebar label sesuai kebutuhan
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(label),
                    ),
                    kondisiTextField(
                        context), // Gantilah ini dengan kondisiTextField Anda
                  ],
                ),
            ],
          )
        ])),
  );
}

// Widget untuk teks "Kondisi"
Widget kondisiLabel(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Text(
      label,
    ),
  );
}

// Widget untuk TextField
Widget kondisiTextField(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    child: SizedBox(
      height: 30,
      width: MediaQuery.of(context).size.width * 0.5,
      child: const TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(), // Mengatur border
        ),
      ),
    ),
  );
}
