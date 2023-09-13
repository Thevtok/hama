// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';
import 'date.dart';


class ListDailyActivity extends StatelessWidget {
  final String item;
  ListDailyActivity({
    Key? key,
    required this.item,
  }) : super(key: key);
  List<String> fromData = [
    '31 Juli 2023',
    '30 Juli 2023',
    '29 Juli 2023',
    '28 Juli 2023',
    '27 Juli 2023',
    '26 Juli 2023',
    '25 Juli 2023',
    '24 Juli 2023',
  ];
  @override
  Widget build(BuildContext context) {
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
          AddButton(onTap: (){Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DateDailyActivity(
                    item: item,
                  ),
                ),
              );}, text: 'Tambah Form', lebar: 0.5),
       
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
          ListView.builder(
            shrinkWrap: true,
            itemCount: fromData.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  padding: const EdgeInsets.all(5),
                  child: Text(fromData[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
