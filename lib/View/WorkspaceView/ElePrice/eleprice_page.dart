import 'package:date_format/date_format.dart' as date_format;
import 'package:suncloudm/toolview/imports.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:suncloudm/View/WorkspaceView/ElePrice/eleprice_cell.dart';
import 'eleprice_cell_b.dart';

class ElepricePage extends StatefulWidget {
  const ElepricePage({super.key});

  @override
  State<ElepricePage> createState() => _ElepricePageState();
}

class _ElepricePageState extends State<ElepricePage>
    with SingleTickerProviderStateMixin {
  final List<Tab> selTabs = <Tab>[
    Tab(text: S.current.pv),
    Tab(text: S.current.ess),
  ];
  TabController? selController;
  final TextEditingController searchController =
      TextEditingController(); // 新增控制器
  String seleteId = '';
  String seleteName = S.current.please_select;
  int seleteType = 1;
  List companyList = [];
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String? singleId = GlobalStorage.getSingleId();

  String seleteDate = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
  List _pageData = [];
  List _pageData2 = [];

  @override
  void initState() {
    super.initState();
    selController = TabController(
      length: selTabs.length,
      vsync: this,
    );
    if (isOperator == true && singleId == null) {
      String? jsonStr = GlobalStorage.getCompanyList();
      companyList = jsonDecode(jsonStr!);
      seleteId = companyList[0]["id"].toString();
      seleteName = companyList[0]["itemName"].toString();
      seleteType = companyList[0]["itemType"];
    } else if (isOperator == true && singleId != null) {
      seleteType = loginType;
    } else {
      seleteType = userInfo['itemType'];
    }
  }

  Future<List> _getPriceList() async {
    Map<String, dynamic> params = {};
    params['time'] = seleteDate;
    params['deviceType'] = 2;
    params['pageNum'] = 1;
    params['pageSize'] = 100;
    params['priceType'] = 1;
    if (singleId != null) {
      params['stationId'] = singleId;
    } else if (seleteId != "") {
      params['stationId'] = seleteId;
    }
    print(params);
    var data = await StrategyDao.getprice(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return _pageData = data['data']['records'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> _getPriceList2() async {
    Map<String, dynamic> params = {};
    params['time'] = seleteDate;
    params['deviceType'] = 1;
    params['pageNum'] = 1;
    params['pageSize'] = 100;
    params['priceType'] = 1;
    if (singleId != null) {
      params['stationId'] = singleId;
    } else if (seleteId != "") {
      params['stationId'] = seleteId;
    }
    var data = await StrategyDao.getprice(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return _pageData2 = data['data']['records'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          S.current.ele_price,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [],
        // 移除AppBar的阴影
        centerTitle: true,
      ),
      body: Column(
        children: [
          Visibility(
            visible: (isOperator == true && singleId == null) ? true : false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: SearchField(
                controller: searchController,
                maxSuggestionsInViewPort: 5,
                itemHeight: 60,
                hint: seleteName,
                searchInputDecoration: SearchInputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                marginColor: Colors.grey.shade300,
                suggestions: companyList
                    .map((e) => SearchFieldListItem(e['itemName'].toString(),
                        item: e['id'].toString()))
                    .toList(),
                focusNode: focusNode,
                onTapOutside: (e) {
                  focusNode.unfocus();
                },
                onSuggestionTap: (SearchFieldListItem x) {
                  seleteId = x.item!;
                  for (var item in companyList) {
                    if (item['id'].toString() == x.item) {
                      seleteType = item["itemType"];
                      seleteName = item["itemName"];
                      searchController.text = seleteName; // 更新控制器的值
                    }
                  }
                  setState(() {});
                },
              ),
            ),
          ),

          // Visibility(
          //   visible:
          //       (isOperator == true && singleId == null) ? true : false,
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          //     child: SizedBox(
          //       height: 40,
          //       child: DropdownButtonFormField2<String>(
          //           isExpanded: true,
          //           decoration: InputDecoration(
          //             filled: true,
          //             fillColor: Colors.white,
          //             contentPadding: const EdgeInsets.symmetric(vertical: 10),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(20),
          //               borderSide: BorderSide.none,
          //             ),
          //             // Add more decoration..
          //           ),
          //           hint: Text(
          //             seleteName,
          //             style: const TextStyle(fontSize: 15),
          //           ),
          //           items: companyList
          //               .map((item) => DropdownMenuItem<String>(
          //                     value: item['id'].toString(),
          //                     child: Text(
          //                       item['itemName'],
          //                       style: const TextStyle(
          //                         fontSize: 15,
          //                       ),
          //                     ),
          //                   ))
          //               .toList(),
          //           validator: (value) {
          //             return null;
          //           },
          //           onChanged: (value) {
          //             debugPrint(value);
          //             seleteId = value!;
          //             for (var item in companyList) {
          //               if (item['id'].toString() == value) {
          //                 seleteType = item["itemType"];
          //               }
          //             }
          //             setState(() {});
          //           },
          //           onSaved: (value) {},
          //           buttonStyleData: const ButtonStyleData(
          //             padding: EdgeInsets.only(right: 8),
          //           ),
          //           iconStyleData: const IconStyleData(
          //               icon: Icon(
          //                 Icons.keyboard_arrow_down,
          //                 color: Colors.black45,
          //               ),
          //               iconSize: 24),
          //           dropdownStyleData: DropdownStyleData(
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(15)),
          //           ),
          //           menuItemStyleData: const MenuItemStyleData(
          //               padding: EdgeInsets.symmetric(horizontal: 16))),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
                onPressed: () async {
                  DateTime? d = await showMonthYearPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2030),
                    initialMonthYearPickerMode: MonthYearPickerMode.month,
                    locale: savedLanguage == 'zh'
                        ? const Locale('zh')
                        : const Locale('en'),
                  );
                  seleteDate = date_format
                      .formatDate(d!, [date_format.yyyy, '-', date_format.mm]);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(0, 40),
                  shape: const StadiumBorder(),
                  side: const BorderSide(color: Colors.grey, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      seleteDate,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black45),
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black45,
                    )
                  ],
                )),
          ),
          seleteType == 1
              ? Material(
                  color: Colors.white,
                  child: Theme(
                    data: ThemeData(
                        splashColor: Colors.transparent,
                        // 点击时的水波纹颜色设置为透明
                        highlightColor: Colors.transparent,
                        // 点击时的背景高亮颜色设置为透明
                        tabBarTheme: const TabBarThemeData(
                            dividerColor: Colors.transparent)),
                    child: TabBar(
                      tabs: selTabs,
                      unselectedLabelColor:
                          const Color.fromRGBO(104, 104, 104, 1),
                      labelColor: const Color.fromRGBO(36, 193, 143, 1),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: const Color.fromRGBO(36, 193, 143, 1),
                      labelStyle: const TextStyle(fontSize: 17),
                      controller: selController,
                    ),
                  ),
                )
              : Container(),
          seleteType == 1
              ? Expanded(
                  child: TabBarView(
                    controller: selController,
                    children: [
                      photovoltaicView(),
                      storageView(),
                    ],
                  ),
                )
              : seleteType == 2
                  ? Expanded(child: storageView())
                  : Expanded(child: photovoltaicView()),
        ],
      ),
    );
  }

  photovoltaicView() {
    return FutureBuilder(
        future: _getPriceList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(10),
              color: const Color(0xFFF7F7F9),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: _pageData.length,
                        itemBuilder: (context, i) {
                          return ElepriceCellB(data: _pageData[i]);
                        }),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox(
                height: 280, child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  storageView() {
    return FutureBuilder(
        future: _getPriceList2(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(10),
              color: const Color(0xFFF7F7F9),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: _pageData2.length,
                        itemBuilder: (context, i) {
                          return ElepriceCell(data: _pageData2[i]);
                        }),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox(
                height: 280, child: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
