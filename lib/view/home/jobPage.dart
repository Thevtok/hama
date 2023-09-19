// ignore_for_file: file_names, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/home/formPage.dart';
import '../../view/home/personelPage.dart';

import 'loginPage.dart';

class JobPage extends StatelessWidget {
  final String item;
  final int id;

  const JobPage({super.key, required this.item, required this.id});

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
            '$id - $item',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25.0,
              color: grey,
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Column(
            children: [
              JobButton(
                  onTap: () async {
                    Get.to(PersonelPage(
                      item: item,
                      id: id,
                    ));
                  },
                  text: 'Personel'),
              const SizedBox(
                height: 50,
              ),
              JobButton(
                  onTap: () async {
                    Get.to(FromPage(
                      item: item,
                      id: id,
                    ));
                  },
                  text: 'Form'),
            ],
          )
        ],
      ),
    );
  }
}

RichText richHama(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: DefaultTextStyle.of(context).style,
      children: [
        TextSpan(
          text: 'Hama',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 30.0,
            color: dark,
          ),
        ),
        TextSpan(
          text: 'App',
          style: TextStyle(
            fontSize: 30.0,
            color: dark,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

Padding backLogout(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
    child: Row(
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
                border: Border.all(color: dark, width: 1),
                color: blue,
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                'Back',
                style: TextStyle(color: dark, fontSize: 18),
              ),
            ),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Get.off(const LoginPage());
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
                border: Border.all(color: dark, width: 1),
                color: white,
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                'Logout',
                style: TextStyle(color: dark, fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class JobButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const JobButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: white,
            ),
          ),
        ),
      ),
    );
  }
}
