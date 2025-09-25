import 'dart:convert';
import 'package:searchfield/searchfield.dart';
import 'package:flutter/material.dart';
import 'package:suncloudm/dao/config.dart';
import 'package:suncloudm/generated/l10n.dart';
import 'package:suncloudm/toolview/language_resource.dart';
import '../../dao/daoX.dart';
import '../../dao/storage.dart';
import '../../routes/Routes.dart';
import '../../toolview/custom_view.dart';

class WorkSpaceHomePage extends StatefulWidget {
  const WorkSpaceHomePage({super.key});
  @override
  State<WorkSpaceHomePage> createState() => _WorkSpaceHomePageState();
}

class _WorkSpaceHomePageState extends State<WorkSpaceHomePage> {
  String? singleId = GlobalStorage.getSingleId();
  Map userInfo = jsonDecode(
      GlobalStorage.getLoginInfo()!); //"项目类型 1：微网项目 2：储能项目 3：光伏项目 4: 充电桩项目")

  String lastName = jsonDecode(GlobalStorage.getLoginInfo()!)['lastName'];

  // List operationList = ["收益分析", "策略管理", "电价时段", "报告报表", "结算管理"];
  List operationList = [
    S.current.revenue_analysis,
    S.current.strategy_management,
    S.current.electricity_price_periods,
    S.current.reports_statements,
    S.current.settlement_management
  ];
  List operationImageList = [
    "assets/syfxicon.png",
    "assets/clglicon.png",
    "assets/djsdicon.png",
    "assets/bgbbicon.png",
    "assets/jsglicon.png",
  ];

  Map<String, dynamic> projectData = {};

  Future<void> getProjectInfoUrl() async {
    Map<String, dynamic> params = {};
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    var data = await IndexDao.getProjectInfoUrl(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        List datalist = data['data']['items'];
        if (datalist.isNotEmpty) {
          projectData = datalist[0];
          if (mounted) {
            setState(() {});
          }
        }
      } else {}
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getProjectInfoUrl();
  }

  List<String> getTitleList() {
    if (isOperator == true) {
      List<String> titles = [
        S.current.photovoltaic_monitoring,
        S.current.energy_storage_monitoring,
        S.current.fault_alarm
      ];
      return titles;
    } else {
      List<String> titles = [S.current.fault_alarm];
      List<dynamic> itemResource = userInfo['itemResource'] ?? [];
      if (itemResource.contains(2)) {
        titles.insert(0, S.current.photovoltaic_monitoring);
      }
      if (itemResource.contains(1)) {
        if (itemResource.contains(2)) {
          titles.insert(1, S.current.energy_storage_monitoring);
        } else {
          titles.insert(0, S.current.energy_storage_monitoring);
        }
      }
      return titles;
    }
  }

  List<String> getImageList() {
    if (isOperator == true) {
      List<String> images = [
        "assets/gfjcicon.png",
        "assets/cnjcicon.png",
        "assets/gzgjicon.png"
      ];
      return images;
    } else {
      List<String> images = ["assets/gzgjicon.png"];
      List<dynamic> itemResource = userInfo['itemResource'] ?? [];

      if (itemResource.contains(2)) {
        images.insert(0, "assets/gfjcicon.png");
      }
      if (itemResource.contains(1)) {
        if (itemResource.contains(2)) {
          images.insert(1, "assets/cnjcicon.png");
        } else {
          images.insert(0, "assets/cnjcicon.png");
        }
      }
      return images;
    }
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    List titleList = [];
    List imageList = [];
    titleList.addAll(operationList);
    imageList.addAll(operationImageList);
    titleList.addAll(getTitleList());
    imageList.addAll(getImageList());

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
      child: SafeArea(
        child: Column(
          children: [
            Transform.translate(
              offset: const Offset(-10, 0),
              child: Image(
                  height: 50,
                  image: AssetImage(
                      LanguageResource.getImagePath('assets/logintext'))),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Image(
                        image: AssetImage('assets/overviewtopImage.png')),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SearchField(
                        maxSuggestionsInViewPort: 5,
                        itemHeight: 70,
                        hint: S.current.search_application_modules,
                        suggestionsDecoration: SuggestionDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8),
                          ),
                          border: Border.all(color: Colors.white),
                        ),
                        suggestionItemDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Colors.transparent,
                                style: BorderStyle.solid,
                                width: 1.0)),
                        searchInputDecoration: SearchInputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        marginColor: Colors.grey.shade300,
                        suggestions: [
                          for (int i = 0; i < titleList.length; i++)
                            {
                              'title': titleList[i],
                              'image': imageList[i],
                            },
                        ]
                            .map((e) => SearchFieldListItem(e['title'],
                                child: UserTile(title: e)))
                            .toList(),
                        focusNode: focusNode,
                        onTapOutside: (e) {
                          focusNode.unfocus();
                        },
                        onSuggestionTap: (SearchFieldListItem x) {
                          debugPrint(x.searchKey);
                          navigateTo(x.searchKey);
                        },
                      ),
                    ),

                    // ///常用模块
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10),
                    //   child: Container(
                    //     padding: const EdgeInsets.all(10.0),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    //     child: Column(
                    //       children: [
                    //         const Row(
                    //           children: [
                    //             SizedBox(
                    //               height: 18,
                    //               child: VerticalDivider(
                    //                 thickness: 3,
                    //                 color: Colors.green,
                    //               ),
                    //             ),
                    //             Text('常用',
                    //                 style: TextStyle(
                    //                     fontSize: 14, fontWeight: FontWeight.w600)),
                    //           ],
                    //         ),
                    //         const SizedBox(height: 10),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             creatCellCard([
                    //               "电站信息",
                    //               "允许策略",
                    //               "结算单",
                    //               "运营报告"
                    //             ], [
                    //               "assets/dzxxicon.png",
                    //               "assets/yxclicon.png",
                    //               "assets/jsdicon.png",
                    //               "assets/yybgicon.png",
                    //             ]),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    Visibility(
                      visible: (isOperator == true) ? true : true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    height: 18,
                                    child: VerticalDivider(
                                      thickness: 3,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(S.current.operating,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              creatCellCard(
                                getTitleList(), // 使用已定义的operationList
                                getImageList(), // 使用已定义的operationImageList
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     creatCellCard([
                              //       "储能监测",
                              //       "光伏监测",
                              //       "故障告警",
                              //     ], [
                              //       "assets/cnjcicon.png",
                              //       "assets/gfjcicon.png",
                              //       "assets/gzgjicon.png",
                              //     ]),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    ///运营模块
                    Visibility(
                      visible:
                          (lastName.contains('新疆和田') || lastName.contains('灌溉'))
                              ? false
                              : true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    height: 18,
                                    child: VerticalDivider(
                                      thickness: 3,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(S.current.operational,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // 直接传入完整数据列表，自动生成多行
                              creatCellCard(
                                operationList, // 使用已定义的operationList
                                operationImageList, // 使用已定义的operationImageList
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    ///运维模块
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10),
                    //   child: Container(
                    //     padding: const EdgeInsets.all(10.0),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    //     child: const Column(
                    //       children: [
                    //         Row(
                    //           children: [
                    //             SizedBox(
                    //               height: 18,
                    //               child: VerticalDivider(
                    //                 thickness: 3,
                    //                 color: Colors.green,
                    //               ),
                    //             ),
                    //             Text('运维',
                    //                 style: TextStyle(
                    //                     fontSize: 14, fontWeight: FontWeight.w600)),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 修改creatCellCard函数为Wrap布局
  creatCellCard(List titleList, List imageList) {
    var imageBtns = <Widget>[];
    double screenWidth = MediaQuery.of(context).size.width;
    // 计算单个按钮宽度（屏幕宽度 - 左右边距10*2 - 水平间距10*3） / 4列
    double btnWidth = (screenWidth - 20 - 30 - 20) / 4;

    for (int i = 0; i < imageList.length; i++) {
      imageBtns.add(
        ImageButton(
          imageList[i],
          width: btnWidth, // 固定宽度保证每行4个
          text: titleList[i],
          iconSize: 35,
          func: navigateTo,
          textStyle: const TextStyle(fontSize: 14, color: Color(0xff656565)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 10, // 水平间距
        runSpacing: 20, // 垂直间距
        children: imageBtns, // 直接使用按钮列表
      ),
    );
  }

  void navigateTo(String lab) {
    if (lab == S.current.reports_statements) {
      Routes.instance!.navigateTo(context, Routes.seletereport);
    } else if (lab == S.current.revenue_analysis) {
      Routes.instance!.navigateTo(context, Routes.profitanalysis);
    } else if (lab == S.current.electricity_price_periods) {
      Routes.instance!.navigateTo(context, Routes.eleprice);
    } else if (lab == S.current.strategy_management) {
      Routes.instance!.navigateTo(context, Routes.strategic);
    } else if (lab == S.current.settlement_management) {
      Routes.instance!.navigateTo(context, Routes.settlementselete);
    } else if (lab == '结算单') {
      Routes.instance!.navigateTo(context, Routes.settlementlist);
    } else if (lab == '回收周期') {
      Routes.instance!.navigateTo(context, Routes.collectingcycles);
    } else if (lab == S.current.photovoltaic_monitoring) {
      Routes.instance!.navigateTo(context, Routes.pvOverViewPage);
    } else if (lab == S.current.energy_storage_monitoring) {
      if (singleId != null) {
        Routes.instance!.navigateTo(context, Routes.cnmonitorPageSingle);
      } else {
        Routes.instance!.navigateTo(context, Routes.cnmonitorPage);
      }
    } else if (lab == '曲线分析') {
      Routes.instance!.navigateTo(context, Routes.chartAlsSeletePage);
    } else if (lab == S.current.fault_alarm) {
      Routes.instance!.navigateTo(context, Routes.alarmSeletePage);
    } else if (lab == '电表监测') {
      Routes.instance!.navigateTo(context, Routes.emMonitorPage);
    }
  }
}

class UserTile extends StatelessWidget {
  final Map title;

  const UserTile({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(title['image']),
      ),
      title: Text(title['title']),
    );
  }
}
