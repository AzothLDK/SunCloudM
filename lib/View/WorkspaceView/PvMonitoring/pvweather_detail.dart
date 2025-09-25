import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter_svg/svg.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:suncloudm/toolview/imports.dart';

class PvweatherDetail extends StatefulWidget {
  final Map pageData;
  const PvweatherDetail({super.key, required this.pageData});

  @override
  State<PvweatherDetail> createState() => _PvweatherDetailState();
}

class _PvweatherDetailState extends State<PvweatherDetail> {
  String seletetime = date_format.formatDate(DateTime.now(),
      [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
  int _currentDateType = 0;
  List weatherDataList = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    getPvStationInfo();
  }

  Future<List> getPvStationInfo() async {
    Map<String, dynamic> params = {};
    params['itemId'] = widget.pageData['itemId'];
    params['date'] = seletetime;
    var data = await IndexDao.getWeather(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return weatherDataList = data['data']['hourList'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new)),
                Expanded(
                  child: Center(
                    child: Text(S.current.weather_details,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none)),
                  ),
                ),
                const SizedBox(
                  width: 40,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Image(image: AssetImage('assets/location_green.png')),
                const SizedBox(width: 3),
                Text('${widget.pageData['detailAddress'] ?? "--"}',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_currentDateType == 0) {
                          DateTime? d = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035),
                            locale: savedLanguage == 'zh'
                                ? const Locale('zh')
                                : const Locale('en'),
                          );
                          if (d != null) {
                            seletetime = date_format.formatDate(d, [
                              date_format.yyyy,
                              '-',
                              date_format.mm,
                              '-',
                              date_format.dd
                            ]);
                            setState(() {});
                          }
                        } else {
                          DateTime? d = await showMonthYearPicker(
                            context: context,
                            initialMonthYearPickerMode:
                                MonthYearPickerMode.month,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035),
                            locale: savedLanguage == 'zh'
                                ? const Locale('zh')
                                : const Locale('en'),
                          );
                          if (d != null) {
                            seletetime = date_format.formatDate(d, [
                              date_format.yyyy,
                              '-',
                              date_format.mm,
                              '-',
                              date_format.dd
                            ]);
                            setState(() {});
                          }
                        }
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
                            seletetime,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black26),
                          ),
                          const SizedBox(width: 15),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black26,
                            size: 14,
                          )
                        ],
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 120,
                  child: MaterialSegmentedControl(
                    verticalOffset: 5,
                    children: {
                      0: Text(S.current.day),
                      1: Text(S.current.month)
                    },
                    selectionIndex: _currentDateType,
                    borderColor: const Color.fromRGBO(36, 193, 143, 1),
                    selectedColor: const Color.fromRGBO(36, 193, 143, 1),
                    unselectedColor: Colors.white,
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    unselectedTextStyle: const TextStyle(
                        color: Color.fromRGBO(36, 193, 1435, 1)),
                    borderWidth: 0.7,
                    borderRadius: 32.0,
                    onSegmentTapped: (index) {
                      switch (index) {
                        case 0:
                          {
                            _currentDateType = 0;
                            seletetime = date_format.formatDate(
                                DateTime.now(), [
                              date_format.yyyy,
                              '-',
                              date_format.mm,
                              '-',
                              date_format.dd
                            ]);
                            setState(() {});
                          }
                        case 1:
                          {
                            _currentDateType = 1;
                            seletetime = date_format.formatDate(DateTime.now(),
                                [date_format.yyyy, '-', date_format.mm]);
                            setState(() {});
                          }
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 替换 DataTable 为 ListView
            FutureBuilder<Object>(
                future: getPvStationInfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView(
                        children: [
                          // 表头
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(child: Center(child: Text('时间'))),
                              Expanded(child: Center(child: Text('天气'))),
                              Expanded(child: Center(child: Text('温度'))),
                              Expanded(child: Center(child: Text('湿度'))),
                            ],
                          ),
                          // const Divider(),
                          // 数据行
                          ...weatherDataList.map((data) {
                            return Container(
                              height: 40,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                          child: Center(
                                              child:
                                                  Text(data['time'] ?? '--'))),
                                      Expanded(
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/${data['icon'] ?? "100"}.svg',
                                                width: 20,
                                                height: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(data['text'] ?? '--'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Center(
                                              child:
                                                  Text(data['temp'] ?? '--'))),
                                      Expanded(
                                          child: Center(
                                              child: Text(
                                                  data['humidity'] ?? '--'))),
                                    ],
                                  ),
                                  // const Divider(),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                        child: Text(S.current.no_data,
                            style: TextStyle(fontSize: 20)));
                  }
                }),
          ]),
        ),
      ),
    );
  }
}
