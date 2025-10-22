import 'dart:convert';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:searchfield/searchfield.dart';
import 'package:suncloudm/View/WorkspaceView/PvMonitoring/pvnbq_view.dart';
import 'package:suncloudm/View/WorkspaceView/PvMonitoring/pvoverview_view.dart';
import 'package:suncloudm/dao/config.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/dao/storage.dart';
import 'package:suncloudm/routes/Routes.dart';
import 'package:suncloudm/toolview/custom_view.dart';
import '../../../utils/screentool.dart';
import 'package:suncloudm/generated/l10n.dart';

//光伏监测
class PVOverViewPage extends StatefulWidget {
  const PVOverViewPage({super.key});

  @override
  State<PVOverViewPage> createState() => _PVOverViewPageState();
}

class _PVOverViewPageState extends State<PVOverViewPage>
    with SingleTickerProviderStateMixin {
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String? singleId = GlobalStorage.getSingleId();
  final TextEditingController searchController = TextEditingController();
  late final TabController mController;
  final List<String> _tabs = [S.current.overview, S.current.inverter];
  Map seleteCompany = {};
  List companyList = [];
  int todayCount = 0;

  Map<String, dynamic> combinedData = {};
  Map<String, dynamic> generalData = {};

  // Future<Map<String, dynamic>> getPvStationInfo1() async {
  //   Map<String, dynamic> params = {};
  //   if (userInfo['userType'] == 2 && singleId == null) {
  //     params['itemId'] = seleteCompany['id'];
  //   }
  //   if (userInfo['userType'] == 2 && singleId != null) {
  //     params['itemId'] = singleId;
  //   }
  //   var data = await IndexDao.getPvStationInfo(params: params);
  //   debugPrint(data.toString());
  //   if (data["code"] == 200) {
  //     if (data['data'] != null) {
  //       return generalData = data['data'];
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  // getWeather() async {
  //   Map<String, dynamic> params = {};
  //   if (userInfo['userType'] == 2 && singleId == null) {
  //     params['itemId'] = seleteCompany['id'];
  //   }
  //   if (userInfo['userType'] == 2 && singleId != null) {
  //     params['itemId'] = singleId;
  //   }
  //   params['date'] = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  //   var data = await IndexDao.getWeather(params: params);
  //   if (data["code"] == 200) {
  //     if (data['data'] != null) {
  //       companyList = data['data'];
  //       seleteCompany = companyList[0];
  //       setState(() {});
  //     } else {}
  //   }
  // }

  Future<Map<String, dynamic>> getPvStationInfo() async {
    Map<String, dynamic> params = {};
    if (isOperator == true && singleId == null) {
      params['itemId'] = seleteCompany['id'];
    }
    if (isOperator == true && singleId != null) {
      params['itemId'] = singleId;
    }
    debugPrint(params.toString());
    var stationData = await IndexDao.getPvStationInfo(params: params);
    debugPrint(stationData.toString());

    // 调用 getWeather 函数
    params['date'] = date_format.formatDate(DateTime.now(),
        [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
    var weatherData = await IndexDao.getWeather(params: params);

    // 合并结果
    combinedData = {'stationInfo': stationData, 'weatherInfo': weatherData};
    generalData = combinedData['stationInfo']['data'];
    return combinedData;
  }

  getPVStationList() async {
    Map<String, dynamic> params = {};
    params['stationType'] = 2;
    var data = await LoginDao.getItem(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        companyList = data['data'];
        if (companyList.isNotEmpty) {
          seleteCompany = companyList[0];
          getTodayCount();
          setState(() {});
        }
      } else {}
    }
  }

  getTodayCount() async {
    Map<String, dynamic> params = {};
    if (isOperator == true && singleId == null) {
      params['itemId'] = seleteCompany['id'];
    }
    if (isOperator == true && singleId != null) {
      params['itemId'] = singleId;
    }
    var data = await AlarmDao.getTodayCount(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        print("${data['data']}");
        todayCount = data['data'];
        setState(() {});
      } else {}
    }
  }

  @override
  void initState() {
    super.initState();
    mController = TabController(initialIndex: 0, length: 2, vsync: this);
    if (isOperator == true && singleId == null) {
      getPVStationList();
    }
  }

  @override
  void dispose() {
    mController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Object>(
          future: getPvStationInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map weartherData = {};
              if (combinedData['weatherInfo']['data'] != null) {
                weartherData = combinedData['weatherInfo']['data'];
              }
              return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/gradientbg.png'),
                        fit: BoxFit.fill)),
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                            Icons.arrow_back_ios_new)),
                                    (isOperator == true && singleId == null)
                                        ?
                                        // Expanded(
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.symmetric(
                                        //           horizontal: 0),
                                        //       child: SizedBox(
                                        //         height: 40,
                                        //         child: DropdownButtonFormField2<
                                        //                 String>(
                                        //             isExpanded: true,
                                        //             decoration: InputDecoration(
                                        //               filled: true,
                                        //               fillColor: Colors.transparent,
                                        //               contentPadding:
                                        //                   const EdgeInsets
                                        //                       .symmetric(
                                        //                       vertical: 10),
                                        //               border: OutlineInputBorder(
                                        //                 borderRadius:
                                        //                     BorderRadius.circular(
                                        //                         20),
                                        //                 borderSide: BorderSide.none,
                                        //               ),
                                        //               // Add more decoration..
                                        //             ),
                                        //             hint: Text(
                                        //               seleteCompany['itemName'] ??
                                        //                   "--",
                                        //               style: const TextStyle(
                                        //                   fontSize: 15,
                                        //                   fontWeight:
                                        //                       FontWeight.bold),
                                        //             ),
                                        //             items: companyList
                                        //                 .map((item) =>
                                        //                     DropdownMenuItem<
                                        //                         String>(
                                        //                       value: item['id']
                                        //                           .toString(),
                                        //                       child: Text(
                                        //                         item['itemName'],
                                        //                         style: const TextStyle(
                                        //                             fontSize: 15,
                                        //                             fontWeight:
                                        //                                 FontWeight
                                        //                                     .bold),
                                        //                       ),
                                        //                     ))
                                        //                 .toList(),
                                        //             validator: (value) {
                                        //               return null;
                                        //             },
                                        //             onChanged: (value) {
                                        //               debugPrint(value);
                                        //               for (var item
                                        //                   in companyList) {
                                        //                 if (item['id'].toString() ==
                                        //                     value) {
                                        //                   seleteCompany = item;
                                        //                   setState(() {});
                                        //                 }
                                        //               }
                                        //             },
                                        //             onSaved: (value) {},
                                        //             buttonStyleData:
                                        //                 const ButtonStyleData(
                                        //               padding:
                                        //                   EdgeInsets.only(right: 8),
                                        //             ),
                                        //             iconStyleData:
                                        //                 const IconStyleData(
                                        //                     icon: Icon(
                                        //                       Icons.arrow_drop_down,
                                        //                       color: Colors.black45,
                                        //                     ),
                                        //                     iconSize: 24),
                                        //             dropdownStyleData:
                                        //                 DropdownStyleData(
                                        //               decoration: BoxDecoration(
                                        //                   borderRadius:
                                        //                       BorderRadius.circular(
                                        //                           15)),
                                        //             ),
                                        //             menuItemStyleData:
                                        //                 const MenuItemStyleData(
                                        //                     padding: EdgeInsets
                                        //                         .symmetric(
                                        //                             horizontal:
                                        //                                 16))),
                                        //       ),
                                        //     ),
                                        //   )
                                        Expanded(
                                            child: Visibility(
                                              visible: isOperator == true
                                                  ? true
                                                  : true,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 10),
                                                child: SearchField(
                                                  controller: searchController,
                                                  maxSuggestionsInViewPort: 5,
                                                  itemHeight: 50,
                                                  hint: seleteCompany[
                                                          'itemName'] ??
                                                      "--",
                                                  searchInputDecoration:
                                                      SearchInputDecoration(
                                                    suffixIcon: const Icon(
                                                        Icons.search),
                                                    filled: true,
                                                    fillColor:
                                                        Colors.transparent,
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                  ),
                                                  marginColor:
                                                      Colors.grey.shade300,
                                                  suggestions: companyList
                                                      .map((e) =>
                                                          SearchFieldListItem(
                                                              e['itemName']
                                                                  .toString(),
                                                              item: e['id']
                                                                  .toString()))
                                                      .toList(),
                                                  focusNode: focusNode,
                                                  onTapOutside: (e) {
                                                    focusNode.unfocus();
                                                  },
                                                  onSuggestionTap:
                                                      (SearchFieldListItem x) {
                                                    getTodayCount();
                                                    for (var item
                                                        in companyList) {
                                                      if (item['id']
                                                              .toString() ==
                                                          x.item) {
                                                        seleteCompany = item;
                                                        searchController.text =
                                                            item['itemName'];
                                                        setState(() {});
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: Row(
                                              children: [
                                                getTextColor(
                                                    generalData['itemType']),
                                                const SizedBox(width: 6),
                                                Text(
                                                    "${generalData['stationName'] ?? "--"}",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                    InkWell(
                                      onTap: () {
                                        if (isOperator == true &&
                                            singleId == null) {
                                          Routes.instance!.navigateTo(
                                              context,
                                              Routes.alarmRLPage,
                                              seleteCompany['id'].toString());
                                        } else if (isOperator == true &&
                                            singleId != null) {
                                          Routes.instance!.navigateTo(
                                              context,
                                              Routes.alarmRLPage,
                                              singleId.toString());
                                        } else {
                                          Routes.instance!.navigateTo(
                                              context, Routes.alarmRLPage);
                                        }
                                      },
                                      child: Badge(
                                        label: todayCount > 0
                                            ? Text(todayCount.toString())
                                            : null,
                                        child: const Icon(Icons.add_alert),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Image(
                                                image: AssetImage(
                                                    'assets/location_green.png')),
                                            const SizedBox(width: 3),
                                            Text(
                                                '${generalData['detailAddress'] ?? "--"}',
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${S.current.grid_connection_time}:${generalData['useTime'] ?? "--"}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              width: 120,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                      '${generalData['stationStatusValue']}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Color(
                                                              0xFF24C18F))))),
                                        )
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        var json = jsonEncode(generalData);
                                        Routes.instance!.navigateTo(context,
                                            Routes.pvweatherDetail, json);
                                      },
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/${weartherData['icon'] ?? "100"}.svg',
                                              width: 24,
                                              height: 24,
                                              // colorFilter: ColorFilter.mode(
                                              //     Colors.yellow,
                                              //     BlendMode.srcIn), // 可选：修改颜色
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                                '${weartherData['temp'] ?? "--"}℃',
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Image(
                                                height: 24,
                                                width: 24,
                                                image: AssetImage(
                                                    'assets/humidity.png')),
                                            const SizedBox(width: 8),
                                            Text(
                                                '${weartherData['humidity'] ?? "--"}%',
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ]),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Image(image: AssetImage('assets/pvlog.png')),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              height: 32.0,
                              child: ButtonsTabBar(
                                width: (ScreenDimensions.screenWidth(context) -
                                        30) /
                                    2,
                                contentCenter: true,
                                tabs: _tabs.map((e) => Tab(text: e)).toList(),
                                onTap: (index) {
                                  setState(() {});
                                },
                                controller: mController,
                                backgroundColor: const Color(0xFF24C18F),
                                unselectedBackgroundColor: Colors.white,
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                unselectedLabelStyle:
                                    const TextStyle(color: Color(0xFF8693AB)),
                                buttonMargin:
                                    const EdgeInsets.only(right: 20, left: 20),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                elevation: 0.5,
                                radius: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1200,
                            child: TabBarView(
                                controller: mController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  PvOverView(seleteCompany['id'].toString(),
                                      pageData: generalData),
                                  NBQListPage(seleteCompany['id'].toString())
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "${generalData['stationName'] ?? S.current.overview}",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [],
                    centerTitle: false,
                  ),
                  body: Center(
                      child: Text('${S.current.no_data}',
                          style: TextStyle(fontSize: 20))));
            } else {
              return const SizedBox(
                  height: 280,
                  child: Center(child: CircularProgressIndicator()));
            }
          }),
    );
  }
}
