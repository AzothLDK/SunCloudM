import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

import '../../dao/daoX.dart';
import '../../routes/Routes.dart';
import '../../toolview/custom_view.dart';

class WorkSpacePvPage extends StatefulWidget {
  const WorkSpacePvPage({super.key});

  @override
  State<WorkSpacePvPage> createState() => _WorkSpacePvPageState();
}

class _WorkSpacePvPageState extends State<WorkSpacePvPage> {
  List titleList = [
    "电站信息",
    "允许策略",
    "结算单",
    "运营报告",
    "光伏监测",
    "储能监测",
    "电表监测",
    "曲线分析",
    "故障告警",
    "档案管理"
  ];
  List titleImage = [
    "assets/dzxxicon.png",
    "assets/yxclicon.png",
    "assets/jsdicon.png",
    "assets/yybgicon.png",
    "assets/gfjcicon.png",
    "assets/cnjcicon.png",
    "assets/dbjcicon.png",
    "assets/qxfxicon2.png",
    "assets/gzgjicon.png",
    "assets/daglicon.png"
  ];

  Map<String, dynamic> projectData = {};

  Future<void> getProjectInfoUrl() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getProjectInfoUrl(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        projectData = data['data'];
        setState(() {});
      } else {}
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProjectInfoUrl();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      projectData['itemName'] ?? "--",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Image(image: AssetImage('assets/location_green.png')),
                    Text(
                      projectData['detailAddress'] ?? "--",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Text(projectData['statusMsg'] ?? "--",
                            style: const TextStyle(
                                fontSize: 16, color: Color(0xFF24C18F)))),
                  ),
                ),
              ],
            ),
          ),
          const Image(image: AssetImage('assets/overviewtopImage.png')),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SearchField(
              maxSuggestionsInViewPort: 5,
              itemHeight: 70,
              hint: '搜索应用模块',
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
                    'image': titleImage[i],
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

          ///常用模块
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Row(
                    children: [
                      SizedBox(
                        height: 18,
                        child: VerticalDivider(
                          thickness: 3,
                          color: Colors.green,
                        ),
                      ),
                      Text('常用',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      creatCellCard([
                        "电站信息",
                        "允许策略",
                        "结算单",
                        "运营报告"
                      ], [
                        "assets/dzxxicon.png",
                        "assets/yxclicon.png",
                        "assets/jsdicon.png",
                        "assets/yybgicon.png",
                      ]),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          ///运行模块
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Row(
                    children: [
                      SizedBox(
                        height: 18,
                        child: VerticalDivider(
                          thickness: 3,
                          color: Colors.green,
                        ),
                      ),
                      Text('运行',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      creatCellCard([
                        "光伏监测",
                        "储能监测",
                        "电表监测",
                        "曲线分析"
                      ], [
                        "assets/gfjcicon.png",
                        "assets/cnjcicon.png",
                        "assets/dbjcicon.png",
                        "assets/zdjcicon.png",
                      ]),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      creatCellCard([
                        "故障告警",
                        "档案管理"
                      ], [
                        "assets/gzgjicon.png",
                        "assets/daglicon.png",
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          ///运维模块
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: const Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 18,
                        child: VerticalDivider(
                          thickness: 3,
                          color: Colors.green,
                        ),
                      ),
                      Text('运维',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  creatCellCard(List titleList, List imageList) {
    var imageBtns = <Widget>[];
    double screenWidth = MediaQuery.of(context).size.width;
    for (int i = 0; i < imageList.length; i++) {
      imageBtns.add(ImageButton(imageList[i],
          width: (screenWidth - 40) / 4,
          text: titleList[i],
          iconSize: 35,
          func: navigateTo,
          textStyle: const TextStyle(fontSize: 15, color: Color(0xff656565))));
    }

    return Expanded(
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(
          bottom: 5,
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: imageBtns,
        ),
      ),
    );
  }

  void navigateTo(String lab) {
    switch (lab) {
      case '报告报表':
        Routes.instance!.navigateTo(context, Routes.seletereport);
        break;
      case '收益分析':
        Routes.instance!.navigateTo(context, Routes.profitanalysis);
        break;
      case '结算单':
        Routes.instance!.navigateTo(context, Routes.settlementlist);
        break;
      case '回收周期':
        Routes.instance!.navigateTo(context, Routes.collectingcycles);
        break;
      case '策略管理':
        Routes.instance!.navigateTo(context, Routes.strategic);
        break;
      case '结算管理':
        Routes.instance!.navigateTo(context, Routes.settlementselete);
        break;
      case '电价时段':
        Routes.instance!.navigateTo(context, Routes.eleprice);
        break;
      case '光伏监测':
        Routes.instance!.navigateTo(context, Routes.pvOverViewPage);
        break;
      case '曲线分析':
        Routes.instance!.navigateTo(context, Routes.chartAlsSeletePage);
        break;
      case '故障告警':
        Routes.instance!.navigateTo(context, Routes.alarmSeletePage);
        break;
      case '电表监测':
        Routes.instance!.navigateTo(context, Routes.emMonitorPage);
        break;
    }
  }
}

class UserTile extends StatelessWidget {
  final Map title;

  // final String titleImage;

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
