import 'package:suncloudm/View/WorkspaceView/CnMonitoring/cnmonitoring_view.dart';
import 'package:suncloudm/toolview/imports.dart';

class CnmonitoringPageSingle extends StatefulWidget {
  const CnmonitoringPageSingle({super.key});

  @override
  State<CnmonitoringPageSingle> createState() => _CnmonitoringPageSingleState();
}

class _CnmonitoringPageSingleState extends State<CnmonitoringPageSingle> {
  List deviceList = [];
  String? singleId = GlobalStorage.getSingleId();
  Map<String, dynamic> projectData = {};
  int _selectedIndex = 0;
  int todayCount = 0;

  @override
  void initState() {
    super.initState();
    getTodayCount();
    getProjectInfoUrl();
    getCnMonitorTabList();
  }

  getTodayCount() async {
    Map<String, dynamic> params = {};
    params['itemId'] = singleId;
    var data = await AlarmDao.getTodayCount(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        todayCount = data['data'];
        setState(() {});
      } else {}
    }
  }

  getCnMonitorTabList() async {
    Map<String, dynamic> params = {};
    params['itemId'] = singleId;
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

  getProjectInfoUrl() async {
    Map<String, dynamic> params = {};
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    var data = await IndexDao.getProjectInfoUrl(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        projectData = data['data']['items'][0];
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
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios_new)),
                        getTextColor(projectData['itemType']),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Text("${projectData['itemName']}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        InkWell(
                          onTap: () {
                            Routes.instance!.navigateTo(context,
                                Routes.alarmRLPage, singleId.toString());
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
                            projectData['detailAddress'] ?? "--",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${S.current.grid_connection_time}:${projectData['useTime'] ?? "--"}',
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
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
                                : const Color(0xFF8693AB),
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
        companyData: {'id': singleId},
        deviceData: deviceList[index],
      ));
    } else {
      // 这里可以根据 index 显示不同的页面
      switch (index) {
        case 0:
          return SingleChildScrollView(
              child: OverViewSegement(
            companyData: {'id': singleId},
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
            companyData: {'id': singleId},
            deviceData: deviceList[index],
          ));
      }
    }
  }
}
