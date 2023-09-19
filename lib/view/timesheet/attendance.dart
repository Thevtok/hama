// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/controller/personelController.dart';
import '../home/jobPage.dart';
import '../home/loginPage.dart';
import '../home/orderPage.dart';
import 'package:intl/intl.dart';



class AttendancePage extends StatefulWidget {
  DateTime? selectedDateForGo;
  final String item;
  final int id;

  AttendancePage({
    Key? key,
    this.selectedDateForGo,
    required this.item,
    required this.id,
  }) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  Map<int, String> selectedValues = {};
  void updateSelectedValue(int index, String value) {
    setState(() {
      selectedValues[index] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM dd, yyyy')
        .format(widget.selectedDateForGo ?? DateTime.now());
    String urlFormat = DateFormat('yyyy-MM-dd')
        .format(widget.selectedDateForGo ?? DateTime.now());
    final personelController =
        Get.put(PersonelController(tanggal: urlFormat, order: widget.item));
    return Scaffold(
      body: Column(
        children: [
          // Bagian atas dengan daftar personel
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
            'Timesheet',
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

          Expanded(
            child: Obx(() {
              if (personelController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (personelController.absens.isEmpty) {
                return ListView.builder(
                  itemCount: personelController.personels.length,
                  itemBuilder: (BuildContext context, int index) {
                    final personel = personelController.personels[index];
                    String selectedValue =
                        selectedValues[index] ?? 'Belum Absen';
                    return Column(
                      children: [
                        Text(
                          personel.name,
                          style: const TextStyle(fontSize: 15),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(color: grey, width: 2.5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(selectedValue),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (String newValue) {
                                        updateSelectedValue(index, newValue);
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'Hadir',
                                          child: Text('Hadir'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Tidak Hadir',
                                          child: Text('Tidak Hadir'),
                                        ),
                                      ],
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                                color: Colors.grey, width: 2.5),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.arrow_drop_down),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              return ListView.builder(
                itemCount: personelController.absens.length,
                itemBuilder: (BuildContext context, int index) {
                  final personel = personelController.absens[index];
                  return Column(
                    children: [
                      Text(
                        personel.name,
                        style: const TextStyle(fontSize: 15),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 35,
                              decoration: BoxDecoration(
                                border: Border.all(color: grey, width: 2.5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        personel.keterangan ?? 'Belum Absen'),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (String newValue) {},
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Hadir',
                                        child: Text('Hadir'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Tidak Hadir',
                                        child: Text('Tidak Hadir'),
                                      ),
                                    ],
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              color: Colors.grey, width: 2.5),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.arrow_drop_down),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
          SaveButton(
            onTap: () async {
              String tanggal = urlFormat;

              String order = widget.item;

              for (int index = 0;
                  index < personelController.personels.length;
                  index++) {
                final personel = personelController.personels[index];
                String selectedValue = selectedValues[index] ?? 'Belum Absen';
                String keterangan = '';

                if (selectedValue == 'Hadir') {
                  keterangan = 'Hadir';
                } else if (selectedValue == 'Tidak Hadir') {
                  keterangan = 'Tidak Hadir';
                }

                if (keterangan.isNotEmpty) {
                  bool berhasil = await personelController.absen(
                    personel.name,
                    tanggal,
                    keterangan,
                    order,
                  );

                  if (berhasil) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Absen berhasil'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal melakukan absen'),
                      ),
                    );
                  }
                  Get.off(OrderPage());
                }
              }
            },
            text: 'Save',
            lebar: 0.5,
          )
        ],
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double lebar;

  const SaveButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.lebar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Center(
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * lebar,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
