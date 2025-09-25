import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suncloudm/dao/storage.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> _items = [];
  List<String> _filteredItems = [];
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();

    List<dynamic> companyList = jsonDecode(GlobalStorage.getCompanyList()!);
    _items = companyList
        .map((item) => (item as Map<String, dynamic>)['itemName'] as String)
        .toList();

    _filteredItems = _items;
    _searchController.addListener(() {
      _filterItems(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text('Search Anchor Example'),
              floating: true,
              pinned: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: SearchAnchor.bar(
                  searchController: _searchController,
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return List.generate(_filteredItems.length, (index) {
                      final item = _filteredItems[index];
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          controller.closeView(item);
                          // 处理点击搜索结果的逻辑
                        },
                      );
                    });
                  },
                  barHintText: '选择站点',
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: _filteredItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_filteredItems[index]),
            );
          },
        ),
      ),
    );
  }
}
