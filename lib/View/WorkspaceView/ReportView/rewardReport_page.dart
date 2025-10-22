import 'package:date_format/date_format.dart' as date_format;
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:suncloudm/toolview/imports.dart';
import '../../../utils/screentool.dart';

class RewardReportPage extends StatefulWidget {
  const RewardReportPage({super.key});

  @override
  State<RewardReportPage> createState() => _RewardReportPageState();
}

class _RewardReportPageState extends State<RewardReportPage>
    with TickerProviderStateMixin {
  List<String> _tabs = [];
  List<Widget> _tabChildren = [];
  TabController? selController;
  final TextEditingController searchController =
      TextEditingController(); // 新增控制器
  String seleteId = '';
  String seleteName = S.current.please_select;
  int seleteType = 1;
  List companyList = [];
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String? singleId = GlobalStorage.getSingleId();

  int _currentDateType = 0;
  String startDate = date_format.formatDate(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
      [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
  String endDate = date_format.formatDate(DateTime.now(),
      [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);

  List _mipageData = []; //微电网'
  List _pvpageData = []; //光伏
  List _stpageData = []; //储能

  @override
  void dispose() {
    selController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (isOperator == true && singleId == null) {
      String? jsonStr = GlobalStorage.getCompanyList();
      companyList = jsonDecode(jsonStr!);
      seleteId = companyList[0]["id"].toString();
      seleteType = companyList[0]["itemType"];
      seleteName = companyList[0]["itemName"].toString();
    } else if (isOperator == true && singleId != null) {
      seleteType = loginType;
    } else {
      seleteType = userInfo['itemType'];
    }
    getViewType();
  }

  getViewType() {
    if (seleteType == 1) {
      _tabs = [S.current.mg, S.current.pv, S.current.ess];
      _tabChildren = [
        mireportView(),
        pvreportView(),
        storgeReportView(),
      ];
    } else if (seleteType == 2) {
      _tabs = [S.current.ess];
      _tabChildren = [
        storgeReportView(),
      ];
    } else if (seleteType == 3) {
      _tabs = [S.current.pv];
      _tabChildren = [
        pvreportView(),
      ];
    } else {
      // _tabs = [];
      // _tabChildren = [];
      _tabs = [S.current.mg, S.current.pv, S.current.ess];
      _tabChildren = [
        mireportView(),
        pvreportView(),
        storgeReportView(),
      ];
    }
    selController = TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  Future<List> _getmicIncome() async {
    Map<String, dynamic> params = {};
    params['startTime'] = startDate;
    params['endTime'] = endDate;
    if (singleId != null) {
      params['itemId'] = singleId;
    } else if (seleteId != "") {
      params['itemId'] = seleteId;
    }
    print(params);
    var data = await ReportDao.getmicIncome(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return _mipageData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> _getPvIncome() async {
    Map<String, dynamic> params = {};
    params['startTime'] = startDate;
    params['endTime'] = endDate;
    params['type'] = 2;
    if (singleId != null) {
      params['itemId'] = singleId;
    } else if (seleteId != "") {
      params['itemId'] = seleteId;
    }
    print(params);
    var data = await ReportDao.getcnAndPvIncome(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return _pvpageData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> _getCNIncome() async {
    Map<String, dynamic> params = {};
    params['startTime'] = startDate;
    params['endTime'] = endDate;
    // params['type'] = 1;
    if (singleId != null) {
      params['itemId'] = singleId;
    } else if (seleteId != "") {
      params['itemId'] = seleteId;
    }
    print(params);
    var data = await ReportDao.getcnAppIncome(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return _stpageData = data['data'];
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
        title: Text(
          S.current.revenue_report,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [],
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xFFF7F7F9),
        child: Column(
          children: [
            Visibility(
              visible: (isOperator == true && singleId == null) ? true : false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: SearchField(
                  controller: searchController, // 设置控制器
                  maxSuggestionsInViewPort: 5,
                  itemHeight: 60,
                  hint: seleteName,
                  searchInputDecoration: SearchInputDecoration(
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
                        color: Colors.grey,
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
                          item: e))
                      .toList(),
                  focusNode: focusNode,
                  onTapOutside: (e) {
                    focusNode.unfocus();
                  },
                  onSuggestionTap: (SearchFieldListItem x) {
                    seleteId = x.item!['id'].toString();
                    seleteType = x.item['itemType'];
                    seleteName = x.item['itemName'].toString();
                    searchController.text = seleteName;
                    setState(() {
                      selController?.index = 0;
                      getViewType();
                    });
                  },
                ),
              ),
            ),
            // Visibility(
            //   visible: (isOperator == true && singleId == null)
            //       ? true
            //       : false,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 15),
            //     child: SizedBox(
            //       height: 40,
            //       child: DropdownButtonFormField2<Map>(
            //           isExpanded: true,
            //           decoration: InputDecoration(
            //             filled: true,
            //             fillColor: Colors.white,
            //             contentPadding:
            //                 const EdgeInsets.symmetric(vertical: 10),
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
            //               .map((item) => DropdownMenuItem<Map>(
            //                     value: item,
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
            //             seleteId = value!['id'].toString();
            //             seleteType = value['itemType'];
            //             setState(() {
            //               selController?.index = 0;
            //               getViewType();
            //             });
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    width: 300,
                                    height: 400,
                                    child: SfDateRangePicker(
                                      confirmText: S.current.confirm,
                                      cancelText: S.current.cancel,
                                      backgroundColor: Colors.transparent,
                                      showActionButtons: true,
                                      // initialSelectedRange: PickerDateRange(
                                      //     DateTime(2020), DateTime(2050)),
                                      selectionMode:
                                          DateRangePickerSelectionMode.range,
                                      view: _currentDateType == 0
                                          ? DateRangePickerView.month
                                          : _currentDateType == 1
                                              ? DateRangePickerView.year
                                              : DateRangePickerView.decade,
                                      allowViewNavigation: false,
                                      headerStyle:
                                          const DateRangePickerHeaderStyle(
                                              backgroundColor:
                                                  Colors.transparent),
                                      startRangeSelectionColor:
                                          const Color.fromRGBO(36, 193, 143, 1),
                                      endRangeSelectionColor:
                                          const Color.fromRGBO(36, 193, 143, 1),
                                      rangeSelectionColor: const Color.fromRGBO(
                                          36, 193, 143, 0.3),
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                      onSubmit: (Object? value) {
                                        print(value.runtimeType);
                                        if (value is PickerDateRange) {
                                          List<String> formats =
                                              _currentDateType == 0
                                                  ? [
                                                      date_format.yyyy,
                                                      '-',
                                                      date_format.mm,
                                                      '-',
                                                      date_format.dd
                                                    ]
                                                  : _currentDateType == 1
                                                      ? [
                                                          date_format.yyyy,
                                                          '-',
                                                          date_format.mm
                                                        ]
                                                      : [date_format.yyyy];
                                          startDate = date_format.formatDate(
                                              value.startDate!, formats);
                                          if (value.endDate == null) {
                                            endDate = date_format.formatDate(
                                                value.startDate!, formats);
                                          } else {
                                            endDate = date_format.formatDate(
                                                value.endDate!, formats);
                                          }
                                          setState(() {});
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      onSelectionChanged:
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        if (args.value is PickerDateRange) {
                                          // startDate = formatDate(args.value.startDate, [yyyy]);
                                          // endDate = formatDate(args.value.endDate, [yyyy]);
                                          // print(args.value.startDate);
                                          // seleteDate=formatDate(args.value.startDate, [yyyy])+formatDate(args.value.endDate, [yyyy]);
                                          // setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(0, 40),
                          shape: const StadiumBorder(),
                          side:
                              const BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$startDate-$endDate",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black26),
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: MaterialSegmentedControl(
                    verticalOffset: 5,
                    children: {
                      0: Text(S.current.day),
                      1: Text(S.current.month),
                      2: Text(S.current.year)
                    },
                    selectionIndex: _currentDateType,
                    borderColor: const Color.fromRGBO(36, 193, 143, 1),
                    selectedColor: const Color.fromRGBO(36, 193, 143, 1),
                    unselectedColor: Colors.white,
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    unselectedTextStyle: const TextStyle(
                        color: Color.fromRGBO(36, 193, 1435, 1)),
                    borderWidth: 0.7,
                    borderRadius: 32.0,
                    onSegmentTapped: (index) {
                      switch (index) {
                        case 0:
                          {
                            _currentDateType = 0;
                            startDate = date_format.formatDate(
                                DateTime(DateTime.now().year,
                                    DateTime.now().month, 1),
                                [
                                  date_format.yyyy,
                                  '-',
                                  date_format.mm,
                                  '-',
                                  date_format.dd
                                ]);
                            endDate = date_format.formatDate(DateTime.now(), [
                              date_format.yyyy,
                              '-',
                              date_format.mm,
                              '-',
                              date_format.dd
                            ]);
                          }
                        case 1:
                          {
                            _currentDateType = 1;
                            startDate = date_format.formatDate(DateTime.now(),
                                [date_format.yyyy, '-', date_format.mm]);
                            endDate = date_format.formatDate(DateTime.now(),
                                [date_format.yyyy, '-', date_format.mm]);
                          }
                        case 2:
                          {
                            _currentDateType = 2;
                            startDate = date_format
                                .formatDate(DateTime.now(), [date_format.yyyy]);
                            endDate = date_format
                                .formatDate(DateTime.now(), [date_format.yyyy]);
                          }
                      }
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: Theme(
                data: ThemeData(
                    splashColor: Colors.transparent,
                    // 点击时的水波纹颜色设置为透明
                    highlightColor: Colors.transparent,
                    // 点击时的背景高亮颜色设置为透明
                    tabBarTheme: const TabBarThemeData(
                        dividerColor: Colors.transparent)),
                child: TabBar(
                  tabs: _tabs.map((e) => Tab(text: e)).toList(),
                  unselectedLabelColor: const Color.fromRGBO(104, 104, 104, 1),
                  labelColor: const Color.fromRGBO(36, 193, 143, 1),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: const Color.fromRGBO(36, 193, 143, 1),
                  labelStyle: const TextStyle(fontSize: 17),
                  controller: selController,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: selController,
                children: getChilden(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getChilden() {
    if (seleteType == 1) {
      _tabChildren = [
        mireportView(),
        pvreportView(),
        storgeReportView(),
      ];
    } else if (seleteType == 2) {
      _tabChildren = [
        storgeReportView(),
      ];
    } else if (seleteType == 3) {
      _tabChildren = [
        pvreportView(),
      ];
    } else {
      _tabChildren = [
        mireportView(),
        pvreportView(),
        storgeReportView(),
      ];
    }
    return _tabChildren;
  }

  mireportView() {
    return FutureBuilder(
        future: _getmicIncome(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: const TextStyle(fontSize: 12),
                      headingRowColor:
                          WidgetStateProperty.all(const Color(0xFFF2F8F9)),
                      headingRowHeight: 40,
                      columnSpacing: ScreenDimensions.screenWidth(context) / 12,
                      dataTextStyle: const TextStyle(fontSize: 12),
                      columns: [
                        DataColumn(
                          label: Text(S.current.date),
                        ),
                        DataColumn(
                          label: Text(
                              '${S.current.total_revenue}(${S.current.yuan})'),
                        ),
                        DataColumn(
                          label: Text(
                              '${S.current.pv_revenue}(${S.current.yuan})'),
                        ),
                        DataColumn(
                          label: Text(
                              '${S.current.ess_revenue}(${S.current.yuan})'),
                        ),
                      ],
                      rows: _getMiData(_mipageData),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(
                height: 280, child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  _getMiData(List? datelist) {
    if (datelist == null) {
      return [
        const DataRow(
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        )
      ];
    } else {
      return datelist
          .asMap()
          .entries
          .map((e) => DataRow(
                color: (e.key % 2 == 0)
                    ? WidgetStateProperty.all(const Color(0xFFFFFFFF))
                    : WidgetStateProperty.all(const Color(0xFFF2F8F9)),
                cells: [
                  DataCell(Text(e.value["time"] ?? "")),
                  DataCell(Text((e.value["totalIncome"] ?? "").toString())),
                  DataCell(Text((e.value["pvIncome"] ?? "").toString())),
                  DataCell(Text((e.value["cnIncome"] ?? "").toString())),
                ],
              ))
          .toList();
    }
  }

  pvreportView() {
    return FutureBuilder(
        future: _getPvIncome(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: TextStyle(fontSize: 12),
                      headingRowColor:
                          WidgetStateProperty.all(Color(0xFFF2F8F9)),
                      headingRowHeight: 40,
                      columnSpacing: ScreenDimensions.screenWidth(context) / 12,
                      dataTextStyle: TextStyle(fontSize: 12),
                      columns: [
                        DataColumn(
                          label: Text(S.current.date),
                        ),
                        DataColumn(
                          label: Text(
                              '${S.current.total_revenue}(${S.current.yuan})'),
                        ),
                        DataColumn(
                          label: Text(
                              '${S.current.consumption_revenue}(${S.current.yuan})'),
                        ),
                        DataColumn(
                          label: Text(
                              '${S.current.online_revenue}(${S.current.yuan})'),
                        ),
                      ],
                      rows: _getPVData(_pvpageData),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(
                height: 280, child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  _getPVData(List? datelist) {
    if (datelist == null) {
      return [
        const DataRow(
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        )
      ];
    } else {
      return datelist
          .asMap()
          .entries
          .map((e) => DataRow(
                color: (e.key % 2 == 0)
                    ? WidgetStateProperty.all(const Color(0xFFFFFFFF))
                    : WidgetStateProperty.all(const Color(0xFFF2F8F9)),
                cells: [
                  DataCell(Text(e.value["time"] ?? "")),
                  DataCell(Text((e.value["realityIncome"] ?? "").toString())),
                  DataCell(Text((e.value["costAll"] ?? "").toString())),
                  DataCell(Text((e.value["incomeAll"] ?? "").toString())),
                ],
              ))
          .toList();
    }
  }

  storgeReportView() {
    return FutureBuilder(
        future: _getCNIncome(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: const TextStyle(fontSize: 12),
                      headingRowColor:
                          WidgetStateProperty.all(const Color(0xFFF2F8F9)),
                      headingRowHeight: 40,
                      columnSpacing: ScreenDimensions.screenWidth(context) / 12,
                      dataTextStyle: const TextStyle(fontSize: 12),
                      columns: [
                        DataColumn(
                          label: Text(S.current.date),
                        ),
                        DataColumn(
                          label: Text(
                              '${S.current.total_revenue}(${S.current.yuan})'),
                        ),
                        DataColumn(
                          label: Text(
                              '${S.current.charge_cost}(${S.current.yuan})'),
                        ),
                        DataColumn(
                          label: Text(
                              '${S.current.discharge_revenue}(${S.current.yuan})'),
                        ),
                      ],
                      rows: _getSTData(_stpageData),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(
                height: 280, child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  _getSTData(List? datelist) {
    if (datelist == null) {
      return [
        const DataRow(
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        )
      ];
    } else {
      return datelist
          .asMap()
          .entries
          .map((e) => DataRow(
                color: (e.key % 2 == 0)
                    ? WidgetStateProperty.all(const Color(0xFFFFFFFF))
                    : WidgetStateProperty.all(const Color(0xFFF2F8F9)),
                cells: [
                  DataCell(Text(e.value["time"] ?? "")),
                  DataCell(Text((e.value["realityIncome"] ?? "").toString())),
                  DataCell(Text((e.value["costAll"] ?? "").toString())),
                  DataCell(Text((e.value["incomeAll"] ?? "").toString())),
                ],
              ))
          .toList();
    }
  }
}
