import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:suncloudm/View/index_page.dart';
import '../../utils/screentool.dart';
import 'package:suncloudm/toolview/imports.dart';

class ProjectListPage extends StatefulWidget {
  final Function(bool) onGoBackToFirst;
  const ProjectListPage({super.key, required this.onGoBackToFirst});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic> projectData = {};
  Map userInfo = jsonDecode(
      GlobalStorage.getLoginInfo()!); //"项目类型 1：微网项目 2：储能项目 3：光伏项目 4: 充电桩项目")
  String? singleId = GlobalStorage.getSingleId();
  String itemName = '';

  Future<Map<String, dynamic>> getProjectInfoUrl() async {
    Map<String, dynamic> params = {};
    singleId = GlobalStorage.getSingleId();
    print(singleId);
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    params["itemName"] = itemName;
    var data = await IndexDao.getProjectInfoUrl(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return projectData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void changeView() {
    setState(() {});
  }

  Map<String, dynamic> _getPassword() {
    String? pw = GlobalStorage.getPassword();
    if (pw == null) {
      return {};
    } else {
      Map<String, dynamic> dd = jsonDecode(pw);
      return dd;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          // appBar: AppBar(
          //   automaticallyImplyLeading: false,
          //   title: const Text(
          //     '项目',
          //     style:
          //         TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          //   ),
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   // 移除AppBar的阴影
          //   centerTitle: true,
          //   actions: [
          //     ((isOperator == true && singleId == null))
          //         ? Container()
          //         : (isOperator == false)
          //             ? Container()
          //             : TextButton.icon(
          //                 icon: const Icon(Icons.keyboard_return,
          //                     color: Colors.black),
          //                 label: const Text('返回主页',
          //                     style: TextStyle(color: Colors.black)),
          //                 onPressed: () async {
          //                   await GlobalStorage.deleteKeyValue('single');
          //                   widget.onGoBackToFirst(false);
          //                 },
          //               ),
          //   ],
          // ),
          body: SafeArea(
            child: FutureBuilder<Object>(
                future: getProjectInfoUrl(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if ((isOperator == true && singleId == null)) {
                      List projectList = projectData['items'];
                      return RefreshIndicator(
                        onRefresh: getProjectInfoUrl,
                        child: Column(
                          children: [
                            Transform.translate(
                              offset: const Offset(-10, 0),
                              child: Image(
                                  height: 50,
                                  image: AssetImage(
                                      LanguageResource.getImagePath(
                                          'assets/logintext'))),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${projectData['itemNum']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          S.current.total_projects,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${projectData['ytyNum']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          S.current.normal,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${projectData['djNum']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          S.current.abnormal,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${projectData['xxNum']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          S.current.offline,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    itemName = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  hintText: S.current.please_input_name,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: projectList.length,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                        onTap: () async {
                                          Map datemap = projectList[i];
                                          _singlelogin(
                                              datemap['itemId'].toString());
                                          // await Navigator.push<void>(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (BuildContext context) =>
                                          //         ProjectdetailPage(
                                          //             projectInfo:
                                          //                 projectList[i],
                                          //             onGoBackToFirst: () {
                                          //               if (projectList[i][
                                          //                       'strategyType'] ==
                                          //                   7) {
                                          //                 widget
                                          //                     .onGoBackToFirst(
                                          //                         true);
                                          //               } else {
                                          //                 widget
                                          //                     .onGoBackToFirst(
                                          //                         false);
                                          //               }
                                          //             }),
                                          //   ),
                                          // );

                                          setState(() {});
                                        },
                                        child: prejectCell(projectList[i]));
                                  }),
                            ),
                          ],
                        ),
                      );
                    } else {
                      List plist = projectData['items'];
                      Map pdata = plist[0];
                      Map pvInfo = {};
                      if (pdata['pvInfo'] != null) {
                        pvInfo = pdata['pvInfo'];
                      }
                      Map cnInfo = {};
                      if (pdata['cnInfo'] != null) {
                        cnInfo = pdata['cnInfo'];
                      }
                      return Column(
                        children: [
                          Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Image(
                                height: 50,
                                image: AssetImage(LanguageResource.getImagePath(
                                    'assets/logintext'))),
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: getProjectInfoUrl,
                              child: ListView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                pdata['itemName'],
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            ((isOperator == true))
                                                ? Container()
                                                : TextButton.icon(
                                                    icon: const Icon(
                                                        Icons.keyboard_return,
                                                        color: Colors.black),
                                                    label: Text(
                                                        S.current.back_to_home,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    onPressed: () async {
                                                      await GlobalStorage
                                                          .deleteKeyValue(
                                                              'single');
                                                      _login(_getPassword());
                                                      // widget.onGoBackToFirst(false);
                                                    },
                                                  ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Image(
                                                image: AssetImage(
                                                    'assets/location_green.png')),
                                            const SizedBox(width: 3),
                                            Expanded(
                                              child: Text(
                                                pdata['detailAddress'] ?? '--',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${S.current.grid_connection_time}:${pdata['useTime'] ?? "--"}',
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
                                                    pdata["statusMsg"] ?? "--",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: pdata[
                                                                    "statusMsg"] ==
                                                                S.current.normal
                                                            ? const Color(
                                                                0xFF24C18F)
                                                            : pdata["statusMsg"] ==
                                                                    S.current
                                                                        .offline
                                                                ? Colors.grey
                                                                : Colors.red))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  pvInfo.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
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
                                                    Text(S.current.pv_info,
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Image(
                                                        image: const AssetImage(
                                                            'assets/pvlog.png'),
                                                        width: ScreenDimensions
                                                                .screenWidth(
                                                                    context) *
                                                            0.25,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "${S.current.site_name} :",
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF8693AB)),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                    pvInfo['stationName'] ??
                                                                        '--'),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                S.current
                                                                    .power_station_status,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF8693AB)),
                                                              ),
                                                              Text(
                                                                pvInfo["statusMsg"] ??
                                                                    "--",
                                                                style: TextStyle(
                                                                    color: cnInfo["statusMsg"] == S.current.normal
                                                                        ? const Color(0xFF24C18F)
                                                                        : cnInfo["statusMsg"] == S.current.offline
                                                                            ? Colors.grey
                                                                            : Colors.red),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                S.current
                                                                    .installed_capacity_kWp,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF8693AB)),
                                                              ),
                                                              Text(
                                                                  '${pvInfo['volume']}')
                                                            ],
                                                          ),
                                                          // const SizedBox(height: 6),
                                                          // Row(
                                                          //   mainAxisAlignment:
                                                          //       MainAxisAlignment
                                                          //           .spaceBetween,
                                                          //   children: [
                                                          //     const Text(
                                                          //       "接入方式",
                                                          //       style: TextStyle(
                                                          //           color: Color(
                                                          //               0xFF8693AB)),
                                                          //     ),
                                                          //     Text(pvInfo['typeName'] ??
                                                          //         "--")
                                                          //   ],
                                                          // ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                S.current
                                                                    .device,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF8693AB)),
                                                              ),
                                                              Expanded(
                                                                  child: Text(
                                                                pvInfo['accessDeviceNames'] ??
                                                                    '--',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  cnInfo.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
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
                                                    Text(S.current.ess_info,
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: Image(
                                                        image: const AssetImage(
                                                            'assets/sclogo.png'),
                                                        width: ScreenDimensions
                                                                .screenWidth(
                                                                    context) *
                                                            0.25,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "${S.current.site_name} :",
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF8693AB)),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                    cnInfo['stationName'] ??
                                                                        "--"),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                S.current
                                                                    .power_station_status,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF8693AB)),
                                                              ),
                                                              Text(
                                                                cnInfo["statusMsg"] ??
                                                                    "--",
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: cnInfo["statusMsg"] == S.current.normal
                                                                        ? const Color(0xFF24C18F)
                                                                        : cnInfo["statusMsg"] == S.current.offline
                                                                            ? Colors.grey
                                                                            : Colors.red),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                S.current
                                                                    .rated_power_kW,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF8693AB)),
                                                              ),
                                                              Text(
                                                                  '${cnInfo['ratePower']}')
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                S.current
                                                                    .installed_capacity_kWh,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF8693AB)),
                                                              ),
                                                              // Text(pvInfo['volume']
                                                              //     .toString())
                                                              Text(
                                                                  '${cnInfo['volume']}')
                                                            ],
                                                          ),
                                                          // SizedBox(height: 6),
                                                          // Row(
                                                          //   mainAxisAlignment:
                                                          //       MainAxisAlignment
                                                          //           .spaceBetween,
                                                          //   children: [
                                                          //     Text(
                                                          //       "接入方式",
                                                          //       style: TextStyle(
                                                          //           color: Color(
                                                          //               0xFF8693AB)),
                                                          //     ),
                                                          //     Text(cnInfo['typeName'] ??
                                                          //         '--')
                                                          //   ],
                                                          // ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                S.current
                                                                    .device,
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF8693AB)),
                                                              ),
                                                              Expanded(
                                                                  child: Text(
                                                                cnInfo['accessDeviceNames'] ??
                                                                    '--',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return const SizedBox(
                        height: 280,
                        child: Center(child: CircularProgressIndicator()));
                  }
                }),
          )),
    );
  }

  prejectCell(Map data) {
    Map pvInfo = {};
    if (data['pvInfo'] != null) {
      pvInfo = data['pvInfo'];
    }
    Map cnInfo = {};
    if (data['cnInfo'] != null) {
      cnInfo = data['cnInfo'];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        // height: 130,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.network(
                    // ignore: prefer_interpolation_to_compose_strings
                    'https://api.smartwuxi.com' + (data["logoUrl"] ?? ''),
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image(
                        image: data['itemType'] == 1
                            ? const AssetImage('assets/wwPIcon.png')
                            : data['itemType'] == 2
                                ? const AssetImage('assets/cnzPIcon.png')
                                : data['itemType'] == 3
                                    ? const AssetImage('assets/gfzPIcon.png')
                                    : const AssetImage('assets/cdzPIcon.png'),
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          getTextColor(data['itemType']),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text('${data['itemName']}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 5),
                          Text('${data['statusMsg']}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: data["statusMsg"] == S.current.normal
                                      ? const Color(0xFF24C18F)
                                      : data["statusMsg"] == S.current.offline
                                          ? Colors.grey
                                          : Colors.red))
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Visibility(
                            visible:
                                (data['itemType'] != 3 && data['itemType'] != 1)
                                    ? false
                                    : true,
                            child: Column(
                              children: [
                                Text(S.current.pv,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8693AB))),
                                Text('${pvInfo['volume']}kWp',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8693AB))),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Visibility(
                            visible:
                                (data['itemType'] != 2 && data['itemType'] != 1)
                                    ? false
                                    : true,
                            child: Column(
                              children: [
                                Text(S.current.ess,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8693AB))),
                                Text(
                                    '${cnInfo['ratePower']}kW/${cnInfo['volume']}kWh',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8693AB))),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text(S.current.grid_connection_time,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF8693AB))),
                              Text('${data['useTime']}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF8693AB))),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Image(image: AssetImage('assets/location_green.png')),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    data['detailAddress'] ?? "--",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 5),
                Visibility(
                  visible: (data['itemType'] != 4) ? true : false,
                  child: InkWell(
                      onTap: () async {
                        // await GlobalStorage.saveSingleId(
                        //     data['itemId'].toString());
                        // loginType = data['itemType'];
                        // if (data['strategyType'] == 7) {
                        //   widget.onGoBackToFirst(true);
                        // } else {
                        //   widget.onGoBackToFirst(false);
                        // }
                        // setState(() {});
                        _singlelogin(data['itemId'].toString());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15), // 设置圆角
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.navigation_outlined,
                              color: Colors.green,
                              size: 12,
                            ),
                            Text(
                              S.current.single_view,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.green),
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _login(Map<String, dynamic> pw) async {
    SVProgressHUD.show();
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    Map<String, dynamic> params = pw;
    // pw['isVerifyCode'] = false;
    var data = await LoginDao.login(params); //用户类型 1单站用户 2投资商 3运行分析 4运维人员 5设备商
    // log(data.toString());
    if (data["code"] == 200) {
      Map result = data["data"];
      await GlobalStorage.clearUserInfo();
      GlobalStorage.saveToken(result["token"]);
      SVProgressHUD.dismiss();
      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
      // SVProgressHUD.showSuccess(status: '登录成功');
      GlobalStorage.saveLoginInfo(result["user"]);
      GlobalStorage.saveUserPassWord(pw);
      if (result["user"]["userType"] == 1) {
        isOperator = false;
        List itemIds = result["user"]["itemIds"];
        GlobalStorage.saveSingleId(itemIds[0].toString());
        var data = await LoginDao.getAppMenuTree();

        Map datakk = data['data'];
        List menuList = datakk['menuList'];
        String path = menuList[0]['path'];
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => IndexPage(path: path)),
            // ignore: unnecessary_null_comparison
            (route) => route == null);
      }
      if (result["user"]["userType"] == 2 || result["user"]["userType"] == 0) {
        isOperator = true;
        var data = await LoginDao.getProjectListUrl();
        if (data["code"] == 200) {
          if (data['data'] != null) {
            GlobalStorage.saveCompanyList(data['data']);
          } else {}
        }
        String path = '';
        var data1 = await LoginDao.getAppMenuTree();
        if (data1["code"] == 200) {
          Map pathdata = data1['data'];
          List menuList = pathdata['menuList'];
          path = menuList[0]['path'];
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (ctx) => IndexPage(path: path, showIndex: 2)),
            // ignore: unnecessary_null_comparison
            (route) => route == null);
      }
    } else {
      SVProgressHUD.dismiss();
      SVProgressHUD.setMaximumDismissTimeInterval(1.0);
      SVProgressHUD.showError(status: data['msg']);
    }
  }

  //单站登录
  _singlelogin(String id) async {
    SVProgressHUD.show();
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    Map<String, dynamic> params = {};
    params['stationId'] = id;
    var data =
        await LoginDao.cnLogin(params); //用户类型 1单站用户 2投资商 3运行分析 4运维人员 5设备商
    // log(data.toString());
    if (data["code"] == 200) {
      Map result = data["data"];
      // GlobalStorage.clearUserInfo();
      GlobalStorage.saveToken(result["token"]);
      SVProgressHUD.dismiss();
      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
      SVProgressHUD.showSuccess(status: S.current.login_success);
      GlobalStorage.saveLoginInfo(result["user"]);
      if (result["user"]["userType"] == 1) {
        isOperator = false;
        List itemIds = result["user"]["itemIds"];
        GlobalStorage.saveSingleId(itemIds[0].toString());
        var data = await LoginDao.getAppMenuTree();

        Map datakk = data['data'];
        List menuList = datakk['menuList'];
        String path = menuList[0]['path'];
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => IndexPage(path: path)),
            // ignore: unnecessary_null_comparison
            (route) => route == null);
      }
    } else {
      SVProgressHUD.dismiss();
      SVProgressHUD.setMaximumDismissTimeInterval(1.0);
      SVProgressHUD.showError(status: data['msg']);
    }
  }

  getTextColor(int itemType) {
    if (itemType == 1) {
      return Container(
          width: 40,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFEEEEFD)),
          child: Text(S.current.mg,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Color(0xFF545DE9))));
    } else if (itemType == 2) {
      return Container(
          width: 40,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFE9F9F4)),
          child: Text(S.current.ess,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Color(0xFF24C18F))));
    } else if (itemType == 3) {
      return Container(
          width: 40,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFFFF2E6)),
          child: Text(S.current.pv,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Color(0xFFFB8209))));
    } else if (itemType == 4) {
      return Container(
          width: 40,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFEAF2FD)),
          child: Text(S.current.charger,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Color(0xFF327DEE))));
    } else {
      return Container(
        width: 50,
        height: 15,
      );
    }
  }
}
