// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../InpeksiAksesHama/ListPage.dart';
import '../MonitoringPemakaian/listPage.dart';
import '../dailyActivity/listPage.dart';
import '../monitoringPeralatan/listPage.dart';
import '../perhitunganIndex/listPage.dart';
import '../timesheet/date.dart';
import 'jobPage.dart';
import 'loginPage.dart';

class FromPage extends StatelessWidget {
  final String item;
  FromPage({super.key, required this.item});
  List<String> fromData = [
    'Timesheet',
    'Monitor Peralatan',
    'Daily Activity',
    'Bukti Service',
    'Perhitungan Populasi Hama',
    'Inpeksi Akses Hama',
    'Monitoring Pemakaian',
    'Berita Acara',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          backLogout(context),
          richHama(context),
          const SizedBox(
            height: 50,
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
            'List Forms',
            style: TextStyle(color: grey, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListFrom('Timesheet', context, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimesheetPage(
                    item: item,
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListFrom('Monitoring Peralatan', context, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListMonitorPeralatan(
                    item: item,
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListFrom('Daily Activity', context, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListDailyActivity(
                    item: item,
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListFrom('Perhitungan Populasi Hama', context, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListIndex(
                    item: item,
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListFrom('Inpeksi Akses Hama', context, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListInpeksi(
                    item: item,
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListFrom('Monitoring Pemakaian', context, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListMonitoringPemakaian(
                    item: item,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

Widget ListFrom(String item, BuildContext context, VoidCallback onTap) {
  return InkWell(
    onTap: () {
      onTap();
    },
    child: Container(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          item,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    ),
  );
}
