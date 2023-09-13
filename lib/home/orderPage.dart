// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

import 'jobPage.dart';
import 'loginPage.dart';
import 'serachResultPage.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _searchController = TextEditingController();
  final List<String> dataList = [
    '1123424 - Job ppp',
    '2222333 - Task abc',
    '3344555 - Assignment xyz',
    '3344555 - Assignment xyz',
    '3344555 - Assignment xyz',
    '2222333 - Task abc',
    '2222333 - Task abc',
    '2222333 - Task abc',
    '3344555 - Assignment xyz',
    '2222333 - Task abc',
    '2222333 - Task abc',
    '2222333 - Task abc',
  ];
  List<String> filteredDataList = [];
  @override
  void initState() {
    super.initState();
    filteredDataList = dataList;
  }

  void filterData(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredDataList = dataList;
      } else {
        filteredDataList = dataList
            .where((item) => item.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double doble = screenHeight * 0.13;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
            backLogout(context),
          richHama(context),
          Padding(
            padding: EdgeInsets.fromLTRB(30, doble, 30, 0),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Center(
                  child: Text(
                    'Nomor Order',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                      color: grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            filterData(_searchController.text);
                            navigateToSearchResultsPage(
                                context, filteredDataList,_searchController.text);
                            _searchController.clear();
                          },
                          icon: const Icon(Icons.search)),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListOrder(dataList[index],context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

Widget ListOrder(String item,BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobPage(item: item), // Kirim nilai item sebagai parameter
        ),
      );
    },
    child: Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(item),
      ),
    ),
  );
}


void navigateToSearchResultsPage(
    BuildContext context, List<String> filteredData,String label) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SearchResultsPage(filteredData: filteredData,label:label ,),
    ),
  );
}
