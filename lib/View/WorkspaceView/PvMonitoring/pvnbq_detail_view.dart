import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:suncloudm/toolview/appColor.dart';
import 'package:suncloudm/toolview/imports.dart';

class PvnbqDetailView extends StatefulWidget {
  final Map nbqInfo;

  const PvnbqDetailView({super.key, required this.nbqInfo});

  @override
  State<PvnbqDetailView> createState() => _PvnbqDetailViewState();
}

class _PvnbqDetailViewState extends State<PvnbqDetailView> {
  List<Map<String, dynamic>> measureList = [];
  List selectMeasureList = [];
  DateTime seleteTime = DateTime.now();

  Map<String, dynamic> detailData = {};

  @override
  void initState() {
    super.initState();
    print(widget.nbqInfo);
    getYCList();
    getDetailNbq();
  }

  getYCList() async {
    Map<String, dynamic> params = {};
    params['deviceCode'] = widget.nbqInfo['deviceCode'];
    var data = await IndexDao.getycList(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        measureList = List<Map<String, dynamic>>.from(data['data']);
        setState(() {});
      } else {}
    } else {}
  }

  // getDetailNbq() async {
  //   Map<String, dynamic> params = {};
  //   params['dateStr'] = formatDate(seleteTime, [yyyy, '-', mm, '-', dd]);
  //   params['deviceCode'] = widget.nbqInfo['deviceCode'];
  //   params['fieldIdList'] = selectMeasureList;
  //   print(params);
  //   var data = await IndexDao.getDetailNbq(params: params);
  //   if (data["code"] == 200) {
  //     if (data['data'] != null) {
  //       detailData = (data['data']);
  //       setState(() {});
  //     } else {}
  //   } else {}
  // }

  Future<Map<String, dynamic>> getDetailNbq() async {
    Map<String, dynamic> params = {};
    params['dateStr'] = date_format.formatDate(seleteTime,
        [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
    params['deviceCode'] = widget.nbqInfo['deviceCode'];
    params['fieldIdList'] = selectMeasureList;
    print(params);
    var data = await IndexDao.getDetailNbq(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return detailData = (data['data']);
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    List xlist = [];
    List ylist = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          S.current.inverter_details,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [],
        // 移除AppBar的阴影
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      seleteTime = seleteTime.subtract(const Duration(days: 1));
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_back_ios_sharp)),
                Expanded(
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          date_format.formatDate(seleteTime, [
                            date_format.yyyy,
                            '-',
                            date_format.mm,
                            '-',
                            date_format.dd
                          ]),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black),
                        ))),
                IconButton(
                    onPressed: () {
                      seleteTime = seleteTime.add(const Duration(days: 1));
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_forward_ios_sharp))
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10.0),
              // height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
                MultiSelectDropdown(
                  idKey: 'id',
                  nameKey: 'measureName',
                  title: S.current.please_select_parameter,
                  options: measureList,
                  selectedIds: selectMeasureList,
                  onChanged: (List newIds) {
                    setState(() {
                      selectMeasureList = newIds;
                      // if (selectedDeviceModels.isNotEmpty) {
                      //   getDeviceList();
                      // }
                    });
                  },
                  onConfirm: getDetailNbq,
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                    future: getDetailNbq(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        xlist = detailData['xlist'];
                        ylist = detailData['ylist'];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {
                              "trigger": 'axis',
                            },
                            "grid": {
                              "left": "3%",
                              "right": "4%",
                              'bottom': '3%',
                              "containLabel": true
                            },
                            "confine": true,
                            "legend": {
                              "type": 'scroll',
                              "textStyle": {"fontSize": 10, "color": '#333'},
                              "itemGap": 2,
                              "data": ylist
                                  .map((e) =>
                                      '${e['measureName']}(${e['unit']})')
                                  .toList(),
                              "inactiveColor": '#ccc',
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xlist,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                // "name": "V",
                              }
                            ],
                            "series": ylist
                                .map(
                                  (e) => {
                                    "name": '${e['measureName']}(${e['unit']})',
                                    "data": e['ylist'],
                                    "type": 'line',
                                    "smooth": true,
                                    "symbol": 'none', // 是否让线条圆滑显示
                                    "color": ColorList()
                                        .lineColorList[ylist.indexOf(e)]
                                  },
                                )
                                .toList()
                          })),
                        );
                      } else {
                        return SizedBox(
                            height: 250,
                            child: Center(
                                child: Text(
                                    S.current.please_select_telemetry_field)));
                      }
                    })
              ]),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// 自定义多选下拉组件，处理包含 id 和 name 的数据
class MultiSelectDropdown extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> options;
  final List selectedIds;
  final Function(List) onChanged;
  final String idKey; // 新增 id 字段名变量
  final String nameKey; // 新增 name 字段名变量
  final Function()? onConfirm; // 新增 onConfirm 参数

  const MultiSelectDropdown({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedIds,
    required this.onChanged,
    required this.idKey,
    required this.nameKey,
    this.onConfirm, // 新增参数
  }) : super(key: key);

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  void _toggleItem(var id) {
    setState(() {
      if (widget.selectedIds.contains(id)) {
        widget.selectedIds.remove(id);
      } else {
        widget.selectedIds.add(id);
      }
      widget.onChanged(widget.selectedIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 获取选中的 stationName 列表
    List<String> selectedNames = widget.options
        .where((item) => widget.selectedIds.contains(item[widget.idKey]))
        .map((item) => item[widget.nameKey] as String)
        .toList();
    // 将选中的 stationName 以逗号分隔成字符串
    String selectedNamesString = selectedNames.join(', ');
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // 设置边框颜色为灰色
        borderRadius: BorderRadius.circular(40), // 设置边框圆角
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            if (selectedNamesString.isNotEmpty)
              Text(
                selectedNamesString,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, state) {
                return AlertDialog(
                  title: Text(widget.title),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: widget.options.map((Map<String, dynamic> item) {
                        return CheckboxListTile(
                          title: Text(item[widget.nameKey]),
                          value:
                              widget.selectedIds.contains(item[widget.idKey]),
                          onChanged: (bool? checked) {
                            _toggleItem(item[widget.idKey]);
                            state(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('确定'),
                      onPressed: () {
                        if (widget.onConfirm != null) {
                          widget.onConfirm!();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
            },
          );
        },
      ),
    );
  }
}
