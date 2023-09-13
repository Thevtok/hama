// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'jobPage.dart';
import 'loginPage.dart';
import 'orderPage.dart';

class SearchResultsPage extends StatefulWidget {
  final List<String> filteredData;
  final String label;

  const SearchResultsPage(
      {super.key, required this.filteredData, required this.label});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final _searchController = TextEditingController();
  List<String> filteredDataList = [];
  @override
  void initState() {
    super.initState();
    filteredDataList = widget.filteredData;
  }

  void filterData(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredDataList = widget.filteredData;
      } else {
        filteredDataList = widget.filteredData
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
                  Text(
                    'Nomor Order',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                      color: grey,
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
                              navigateToSearchResultsPage(context,
                                  filteredDataList, _searchController.text);
                              _searchController.clear();
                            },
                            icon: const Icon(Icons.search)),
                        hintText: widget.label,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.filteredData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListOrder(widget.filteredData[index],context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
