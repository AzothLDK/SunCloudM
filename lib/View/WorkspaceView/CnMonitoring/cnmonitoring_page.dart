import 'package:suncloudm/View/WorkspaceView/CnMonitoring/cnmonitoring_view.dart';
import 'package:suncloudm/toolview/imports.dart';

class CnmonitoringPage extends StatefulWidget {
  const CnmonitoringPage({super.key});

  @override
  State<CnmonitoringPage> createState() => _CnmonitoringPageState();
}

class _CnmonitoringPageState extends State<CnmonitoringPage> {
  Map seleteCompany = {};
  List companyList = [];
  List deviceList = [];
  int _selectedIndex = 0;
  FocusNode focusNode = FocusNode();

  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  int todayCount = 0;

  @override
  void initState() {
    super.initState();
    String? jsonStr = GlobalStorage.getCompanyList();
    companyList = jsonDecode(jsonStr!);
    // 添加过滤逻辑，剔除itemType=3的元素
    companyList = companyList.where((item) => item['itemType'] != 3).toList();

    seleteCompany = companyList[0];
    getTodayCount();
    getCnMonitorTabList();
    getProjectInfoUrl();
  }

  getTodayCount() async {
    Map<String, dynamic> params = {};
    params['itemId'] = seleteCompany['id'];
    var data = await AlarmDao.getTodayCount(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        todayCount = data['data'];
        setState(() {});
      } else {}
    }
  }

  Map<String, dynamic> projectData = {};
  getProjectInfoUrl() async {
    Map<String, dynamic> params = {};
    params['itemId'] = seleteCompany['id'];
    var data = await IndexDao.getProjectInfoUrl(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        projectData = data['data']['items'][0];
        setState(() {});
      } else {}
    } else {}
  }

  getCnMonitorTabList() async {
    Map<String, dynamic> params = {};
    debugPrint(seleteCompany.toString());
    params['itemId'] = seleteCompany['id'];
    var data = await CnMonitorDao.cnMonitorTabList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        deviceList = data['data'];
        deviceList.insert(0, {'name': S.current.overview});
        setState(() {});
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios_new)),
                        // Expanded(
                        //   child: Visibility(
                        //     visible: isOperator == true ? true : true,
                        //     child: Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 0),
                        //       child: SizedBox(
                        //         height: 40,
                        //         child: DropdownButtonFormField2<String>(
                        //             isExpanded: true,
                        //             decoration: InputDecoration(
                        //               filled: true,
                        //               fillColor: Colors.transparent,
                        //               contentPadding:
                        //                   const EdgeInsets.symmetric(
                        //                       vertical: 10),
                        //               border: OutlineInputBorder(
                        //                 borderRadius:
                        //                     BorderRadius.circular(20),
                        //                 borderSide: BorderSide.none,
                        //               ),
                        //               // Add more decoration..
                        //             ),
                        //             hint: Text(
                        //               seleteCompany['itemName'] ?? "--",
                        //               style: const TextStyle(
                        //                   fontSize: 15,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //             items: companyList
                        //                 .map((item) =>
                        //                     DropdownMenuItem<String>(
                        //                       value: item['id'].toString(),
                        //                       child: Text(
                        //                         item['itemName'],
                        //                         style: const TextStyle(
                        //                             fontSize: 15,
                        //                             fontWeight:
                        //                                 FontWeight.bold),
                        //                       ),
                        //                     ))
                        //                 .toList(),
                        //             validator: (value) {
                        //               return null;
                        //             },
                        //             onChanged: (value) {
                        //               debugPrint(value);
                        //               for (var item in companyList) {
                        //                 if (item['id'].toString() == value) {
                        //                   seleteCompany = item;
                        //                   getProjectInfoUrl();
                        //                 }
                        //               }
                        //               _selectedIndex = 0;
                        //               getCnMonitorTabList();
                        //             },
                        //             onSaved: (value) {},
                        //             buttonStyleData: const ButtonStyleData(
                        //               padding: EdgeInsets.only(right: 8),
                        //             ),
                        //             iconStyleData: const IconStyleData(
                        //                 icon: Icon(
                        //                   Icons.arrow_drop_down,
                        //                   color: Colors.black45,
                        //                 ),
                        //                 iconSize: 24),
                        //             dropdownStyleData: DropdownStyleData(
                        //               decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(15)),
                        //             ),
                        //             menuItemStyleData:
                        //                 const MenuItemStyleData(
                        //                     padding: EdgeInsets.symmetric(
                        //                         horizontal: 16))),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: SearchField(
                              maxSuggestionsInViewPort: 5,
                              itemHeight: 50,
                              hint: seleteCompany['itemName'] ?? "--",
                              searchInputDecoration: SearchInputDecoration(
                                suffixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
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
                              ),
                              marginColor: Colors.grey.shade300,
                              suggestions: companyList
                                  .map((e) => SearchFieldListItem(
                                      e['itemName'].toString(),
                                      item: e['id'].toString()))
                                  .toList(),
                              focusNode: focusNode,
                              onTapOutside: (e) {
                                focusNode.unfocus();
                              },
                              onSuggestionTap: (SearchFieldListItem x) {
                                for (var item in companyList) {
                                  if (item['id'].toString() == x.item) {
                                    seleteCompany = item;
                                    getProjectInfoUrl();
                                  }
                                }
                                _selectedIndex = 0;
                                getTodayCount();
                                getCnMonitorTabList();
                              },
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Routes.instance!.navigateTo(
                                context,
                                Routes.alarmRLPage,
                                seleteCompany['id'].toString());
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
                      children: [
                        const Image(
                            image: AssetImage('assets/location_green.png')),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            seleteCompany['detailAddress'] ?? "--",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${S.current.grid_connection_time}：${seleteCompany['useTime'] ?? "--"}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 120,
                        height: 25,
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
              const Image(height: 100, image: AssetImage('assets/sclogo.png')),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: deviceList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final device = entry.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? const Color(0xFF24C18F)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          device['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _selectedIndex == index
                                ? Colors.white
                                : Color(0xFF8693AB),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _buildPage(_selectedIndex),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    if (deviceList.isEmpty) {
      return Center(
        child: Text(S.current.no_data),
      );
    }
    Map deviceInfo = deviceList[index];
    if (deviceInfo['tagSign'] == 2) {
      return SingleChildScrollView(
          child: BMSSegement(
        key: Key(deviceList[index]['tagSign'].toString()),
        companyData: seleteCompany,
        deviceData: deviceList[index],
      ));
    } else {
      // 这里可以根据 index 显示不同的页面
      switch (index) {
        case 0:
          return SingleChildScrollView(
              child: OverViewSegement(
            companyData: seleteCompany,
          ));
        // case 1:
        //   return SingleChildScrollView(
        //       child: PCSSegement(
        //     companyData: seleteCompany,
        //     deviceData: deviceList[index],
        //   ));
        // default:
        //   return Center(child: Text('${deviceList[index]['name']} 页面'));
        // 可以继续添加更多 case
        default:
          return SingleChildScrollView(
              child: PCSSegement(
            key: Key(deviceList[index]['tagSign'].toString()),
            companyData: seleteCompany,
            deviceData: deviceList[index],
          ));
      }
    }
  }
}
