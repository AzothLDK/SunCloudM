import 'package:date_format/date_format.dart';
import 'package:tab_container/tab_container.dart';
import '../PvMonitoring/pvoverview_view.dart';
import 'emMonitor_view.dart';
import 'package:suncloudm/toolview/imports.dart';

class EmMonitorPage extends StatefulWidget {
  const EmMonitorPage({super.key});

  @override
  State<EmMonitorPage> createState() => _EmMonitorPageState();
}

class _EmMonitorPageState extends State<EmMonitorPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String seleteTime = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  List formList = [];
  String deviceId = '';
  String deviceName = '选择电表';

  getCommonDropList() async {
    Map<String, dynamic> params = {};
    params['deviceType'] = 6;
    var data = await ChartDao.getCommonDropList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        formList = data['data'];
        if (formList.length > 0) {
          deviceName = formList[0]['name'];
          deviceId = formList[0]['id'];
        }
        setState(() {});
      } else {}
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 7,
      vsync: this,
    );
    getCommonDropList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('电表监测'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        showRadioDialog(context, formList).then((value) async {
                          if (value != null) {
                            print(value);
                            deviceName = value['name'];
                            deviceId = value['id'];
                            setState(() {});
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 40),
                        shape: const StadiumBorder(),
                        side: const BorderSide(
                            color: Color.fromRGBO(212, 212, 212, 1), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(deviceName,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54)),
                          const Icon(Icons.keyboard_arrow_down,
                              color: Colors.black54, size: 14)
                        ],
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        DateTime? d = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2030),
                          locale: savedLanguage == 'zh'
                              ? const Locale('zh')
                              : const Locale('en'),
                        );
                        seleteTime = formatDate(d!, [yyyy, '-', mm, '-', dd]);
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 40),
                        shape: const StadiumBorder(),
                        side: const BorderSide(
                            color: Color.fromRGBO(212, 212, 212, 1), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            seleteTime,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                            size: 14,
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabContainer(
              // tabMinLength:70,
              controller: _tabController,
              // color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              tabBorderRadius: BorderRadius.circular(10),
              childPadding: const EdgeInsets.all(0.0),
              selectedTextStyle: const TextStyle(
                color: Color(0xFF24C18F),
                fontSize: 15.0,
              ),
              unselectedTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 13.0,
              ),
              // colors: [
              //   Colors.red,
              //   Colors.green,
              //   Colors.blue,
              // ],
              tabs: [
                Text('电量'),
                Text('功率'),
                Text('无功功率'),
                Text('功率因素'),
                Text('电流'),
                Text('电压'),
                Text('示数'),
              ],
              children: [
                SingleChildScrollView(
                    child:
                        EMEleDLPage(loopId: deviceId, seleteTime: seleteTime)),
                SingleChildScrollView(
                    child:
                        EMEleGLPage(loopId: deviceId, seleteTime: seleteTime)),
                SingleChildScrollView(
                    child: EMEleWGGLPage(
                        loopId: deviceId, seleteTime: seleteTime)),
                SingleChildScrollView(
                    child: EMEleGLYSPage(
                        loopId: deviceId, seleteTime: seleteTime)),
                SingleChildScrollView(
                    child:
                        EMEleIPage(loopId: deviceId, seleteTime: seleteTime)),
                SingleChildScrollView(
                    child:
                        EMEleVPage(loopId: deviceId, seleteTime: seleteTime)),
                SingleChildScrollView(
                    child: PvOverView(
                  "",
                  pageData: {},
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 自定义单选框对话框
  Future<Map<String, dynamic>?> showRadioDialog(
      BuildContext context, List dataList) async {
    List<String> personName = [];
    for (var v in dataList) {
      personName.add(v['name']);
    }

    return showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (BuildContext context) {
        final List<String> options = personName;
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: const Text('选择电表',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 260,
              height: 300,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      print(index);
                      String deviceIdstr = dataList[index]['id'].toString();
                      String namestr = dataList[index]['name'].toString();
                      Map<String, dynamic> returnData = {
                        'name': namestr,
                        'id': deviceIdstr
                      };
                      Navigator.of(context).pop(returnData);
                    },
                    child: ListTile(
                      leading:
                          const Icon(Icons.table_chart, color: Colors.blue),
                      title: Text(options[index]),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
