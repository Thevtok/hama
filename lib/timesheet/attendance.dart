// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';

class AttendancePage extends StatefulWidget {
  DateTime? selectedDateForGo;
  final String item;
  AttendancePage({Key? key, this.selectedDateForGo, required this.item})
      : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<String> personelData = [
    'Personel 1',
    'Personel 2',
    'Personel 3',
    'Personel 4',
    'Personel 5',
  ];

  Map<String, String> personelAttendanceStatus = {};
  @override
  void initState() {
    super.initState();
    // Inisialisasi status hadir untuk setiap personel
    for (String personel in personelData) {
      personelAttendanceStatus[personel] = 'Hadir';
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM dd, yyyy')
        .format(widget.selectedDateForGo ?? DateTime.now());
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
            child: ListView.builder(
              itemCount: personelData.length,
              itemBuilder: (BuildContext context, int index) {
                final personel = personelData[index];
                return Column(
                  children: [
                    Text(
                      personel,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                      personelAttendanceStatus[personel] ??
                                          'Hadir'),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (String newValue) {
                                    setState(() {
                                      personelAttendanceStatus[personel] =
                                          newValue;
                                    });
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
            ),
          ),
          SaveButton(
            onTap: () {},
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
