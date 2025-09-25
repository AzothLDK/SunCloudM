import 'package:suncloudm/toolview/imports.dart';

class OplStationPage extends StatefulWidget {
  const OplStationPage({super.key});

  @override
  State<OplStationPage> createState() => _OplStationPageState();
}

class _OplStationPageState extends State<OplStationPage> {
  Map<String, dynamic> projectData = {};
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> getProjectInfoUrl() async {
    Map<String, dynamic> params = {};
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

  List<String> operationTeams = ['班组1', '班组2', '班组3'];
  List<String> operationStaff = ['人员1', '人员2', '人员3'];

  String? selectedTeam;
  String? selectedStaff;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              '电站',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            // 移除AppBar的阴影
            centerTitle: true,
          ),
          body: FutureBuilder<Object>(
              future: getProjectInfoUrl(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List projectList = projectData['items'];
                  return RefreshIndicator(
                    onRefresh: getProjectInfoUrl,
                    child: Column(
                      children: [
                        // 在合适的位置添加下拉筛选框
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     DropdownButton<String>(
                        //       value: selectedTeam,
                        //       hint: Text('运维班组'),
                        //       items: operationTeams.map((String value) {
                        //         return DropdownMenuItem<String>(
                        //           value: value,
                        //           child: Text(value),
                        //         );
                        //       }).toList(),
                        //       onChanged: (newValue) {
                        //         setState(() {
                        //           selectedTeam = newValue;
                        //         });
                        //       },
                        //     ),
                        //     DropdownButton<String>(
                        //       value: selectedStaff,
                        //       hint: Text('运维人员'),
                        //       items: operationStaff.map((String value) {
                        //         return DropdownMenuItem<String>(
                        //           value: value,
                        //           child: Text(value),
                        //         );
                        //       }).toList(),
                        //       onChanged: (newValue) {
                        //         setState(() {
                        //           selectedStaff = newValue;
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${projectData['itemNum'] ?? "--"}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      S.current.maintenance,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${projectData['ytyNum'] ?? "--"}',
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${projectData['djNum'] ?? "--"}',
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
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${projectData['xxNum'] ?? "--"}',
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
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: projectList.length,
                              itemBuilder: (context, i) {
                                return InkWell(
                                    onTap: () async {},
                                    child: prejectCell(projectList[i]));
                              }),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox(
                      height: 280,
                      child: Center(child: CircularProgressIndicator()));
                }
              })),
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
                Image(
                    image: data['itemType'] == 1
                        ? const AssetImage('assets/wwPIcon.png')
                        : data['itemType'] == 2
                            ? const AssetImage('assets/cnzPIcon.png')
                            : data['itemType'] == 3
                                ? const AssetImage('assets/gfzPIcon.png')
                                : const AssetImage('assets/cdzPIcon.png')),
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
                                      ? Color(0xFF24C18F)
                                      : data["statusMsg"] == S.current.offline
                                          ? Colors.grey
                                          : Colors.red))
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Visibility(
                            visible: data['itemType'] != 2 ? true : false,
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
                            visible: data['itemType'] != 3 ? true : false,
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
                // InkWell(
                //     onTap: () async {
                //       // await GlobalStorage.saveSingleId(
                //       //     data['itemId'].toString());
                //       // loginType = data['itemType'];
                //       setState(() {});
                //     },
                //     child: Container(
                //       padding: EdgeInsets.all(3),
                //       decoration: BoxDecoration(
                //         border: Border.all(
                //           color: Colors.green,
                //           width: 1,
                //         ),
                //         borderRadius: BorderRadius.circular(15), // 设置圆角
                //       ),
                //       child: const Row(
                //         children: [
                //           Icon(
                //             Icons.navigation_outlined,
                //             color: Colors.green,
                //             size: 12,
                //           ),
                //           Text(
                //             '单站视图',
                //             style: TextStyle(fontSize: 12, color: Colors.green),
                //           ),
                //         ],
                //       ),
                //     ))
              ],
            ),
          ],
        ),
      ),
    );
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
