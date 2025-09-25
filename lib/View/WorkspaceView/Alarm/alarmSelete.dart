import 'package:suncloudm/toolview/imports.dart';

class AlarmSelete extends StatefulWidget {
  const AlarmSelete({super.key});

  @override
  State<AlarmSelete> createState() => _AlarmSeleteState();
}

class _AlarmSeleteState extends State<AlarmSelete> {
  String? singleId = GlobalStorage.getSingleId();
  int allAlarm = 0;

  getAlarmList() async {
    Map<String, dynamic> params = {};
    params['pageNum'] = 1;
    params['pageSize'] = 999;
    if (singleId != null) {
      params['itemIdList'] = [singleId];
    }
    print(params);
    var data = await AlarmDao.getAlarmList(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        List dataList = data['data']['records'];
        if (mounted) {
          setState(() {
            allAlarm = dataList.length;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAlarmList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.fault_alarm,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [],
        // 移除AppBar的阴影
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          CommonButton.build(
              context: context,
              text: S.current.real_time_alarm,
              num: allAlarm.toString(),
              imageAssetPath: 'assets/ssgj.png',
              routeName: Routes.alarmRLPage),
          const SizedBox(height: 10),
          CommonButton.build(
              context: context,
              text: S.current.historical_alarm,
              imageAssetPath: 'assets/lsgj.png',
              routeName: Routes.alarmHSPage),
          const SizedBox(height: 10),
          // CommonButton.build(context: context, text: '统计分析', imageAssetPath: 'assets/tjfx.png', routeName: Routes.whitePage),
          // const SizedBox(height: 10),
          // CommonButton.build(context: context, text: '周期推荐', imageAssetPath: 'assets/zqtj.png', routeName: Routes.whitePage),
        ],
      ),
    );
  }
}
