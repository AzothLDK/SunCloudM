import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:suncloudm/toolview/imports.dart';

class ProfitanalysisWw extends StatefulWidget {
  final Map? companyinfo;
  const ProfitanalysisWw({super.key, this.companyinfo});

  @override
  State<ProfitanalysisWw> createState() => _ProfitanalysisWwState();
}

class _ProfitanalysisWwState extends State<ProfitanalysisWw>
    with TickerProviderStateMixin {
  final List<Tab> selTabs = <Tab>[
    Tab(text: S.current.mg),
    Tab(text: S.current.pv),
    Tab(text: S.current.ess),
  ];
  TabController? selController;
  int _currentDateType = 0;
  String startDate = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
  String endDate = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
  int _viewType = 0;
  Map infoincomeData = {};

  ///图表数据
  List xdata = [];
  List totalPriceList = [];
  List photovoltaicPriceList = [];
  List energyStoragePriceList = [];
  List companyList = [];

  final List<Tab> radarTabs = <Tab>[
    Tab(text: S.current.revenue),
    Tab(text: S.current.elec),
  ];
  String radarstartDate = date_format.formatDate(
      DateTime(DateTime.now().year, DateTime.now().month - 1),
      [date_format.yyyy, '-', date_format.mm]);
  String radarendDate = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
  TabController? radarController;
  Map<String, dynamic> radarData = {};
  String? singleId = GlobalStorage.getSingleId();
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);

  @override
  void initState() {
    super.initState();
    selController = TabController(
      length: selTabs.length,
      vsync: this,
    );
    radarController = TabController(
      length: radarTabs.length,
      vsync: this,
    );
    getincomeinfoData();
    getIncomeChartsData();
  }

  @override
  void didUpdateWidget(covariant ProfitanalysisWw oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.companyinfo != oldWidget.companyinfo) {
      getincomeinfoData();
      getIncomeChartsData();
    }
  }

  getincomeinfoData() async {
    Map<String, dynamic> params = {};

    if (widget.companyinfo?['id'] != null) {
      params['stationId'] = widget.companyinfo?['id'];
    }
    if (singleId != null) {
      params["stationId"] = singleId;
    }
    var data = await ReportDao.getincomeinfoData(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        infoincomeData = data['data'];
        setState(() {});
      } else {}
    } else {}
  }

  getIncomeChartsData() async {
    Map<String, dynamic> params = {};
    params['startTime'] = startDate;
    params['endTime'] = endDate;
    if (widget.companyinfo?['id'] != null) {
      params['stationId'] = widget.companyinfo?['id'];
    }
    if (singleId != null) {
      params["stationId"] = singleId;
    }
    var data = await ReportDao.getincomeChartData(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        Map datamap = data['data']['echarts'];
        xdata = datamap['xdata'];
        totalPriceList = datamap['totalPriceList'];
        photovoltaicPriceList = datamap['photovoltaicPriceList'];
        energyStoragePriceList = datamap['energyStoragePriceList'];
        setState(() {});
      } else {}
    } else {}
  }

  Future<Map<String, dynamic>> getincomeRadarData() async {
    Map<String, dynamic> params = {};
    params['startTime'] = radarstartDate;
    params['endTime'] = radarendDate;
    if (widget.companyinfo?['id'] != null) {
      params['stationId'] = widget.companyinfo?['id'];
    }
    if (singleId != null) {
      params["stationId"] = singleId;
    }
    var data = await ReportDao.getincomeRadarData(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return radarData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                    Text(S.current.mg_revenue,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        width: 300,
                                        height: 400,
                                        child: SfDateRangePicker(
                                          confirmText: S.current.confirm,
                                          cancelText: S.current.cancel,
                                          backgroundColor: Colors.transparent,
                                          showActionButtons: true,
                                          // initialSelectedRange: PickerDateRange(
                                          //     DateTime(2020), DateTime(2050)),
                                          selectionMode:
                                              DateRangePickerSelectionMode
                                                  .range,
                                          view: _currentDateType == 0
                                              ? DateRangePickerView.year
                                              : DateRangePickerView.decade,
                                          allowViewNavigation: false,
                                          headerStyle:
                                              const DateRangePickerHeaderStyle(
                                                  backgroundColor:
                                                      Colors.transparent),
                                          startRangeSelectionColor:
                                              const Color.fromRGBO(
                                                  36, 193, 143, 1),
                                          endRangeSelectionColor:
                                              const Color.fromRGBO(
                                                  36, 193, 143, 1),
                                          rangeSelectionColor:
                                              const Color.fromRGBO(
                                                  36, 193, 143, 0.3),
                                          onCancel: () {
                                            Navigator.of(context).pop();
                                          },
                                          onSubmit: (Object? value) {
                                            print(value);
                                            if (value is PickerDateRange) {
                                              List<String> formats =
                                                  _currentDateType == 0
                                                      ? [
                                                          date_format.yyyy,
                                                          '-',
                                                          date_format.mm
                                                        ]
                                                      : [date_format.yyyy];
                                              startDate =
                                                  date_format.formatDate(
                                                      value.startDate!,
                                                      formats);
                                              if (value.endDate == null) {
                                                endDate =
                                                    date_format.formatDate(
                                                        value.startDate!,
                                                        formats);
                                              } else {
                                                endDate =
                                                    date_format.formatDate(
                                                        value.endDate!,
                                                        formats);
                                              }
                                              getIncomeChartsData();
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          onSelectionChanged:
                                              (DateRangePickerSelectionChangedArgs
                                                  args) {
                                            if (args.value is PickerDateRange) {
                                              // startDate = formatDate(args.value.startDate, [yyyy]);
                                              // endDate = formatDate(args.value.endDate, [yyyy]);
                                              // print(args.value.startDate);
                                              // seleteDate=formatDate(args.value.startDate, [yyyy])+formatDate(args.value.endDate, [yyyy]);
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              minimumSize: const Size(0, 40),
                              shape: const StadiumBorder(),
                              side: const BorderSide(
                                  color: Color.fromRGBO(212, 212, 212, 1),
                                  width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "$startDate  -  $endDate",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black26),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black26,
                                  size: 14,
                                )
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      child: MaterialSegmentedControl(
                        verticalOffset: 5,
                        children: {
                          0: Text(S.current.month),
                          1: Text(S.current.year)
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
                                startDate = date_format.formatDate(
                                    DateTime.now(),
                                    [date_format.yyyy, '-', date_format.mm]);
                                endDate = date_format.formatDate(DateTime.now(),
                                    [date_format.yyyy, '-', date_format.mm]);
                                getIncomeChartsData();
                              }
                            case 1:
                              {
                                _currentDateType = 1;
                                startDate = date_format.formatDate(
                                    DateTime.now(), [date_format.yyyy]);
                                endDate = date_format.formatDate(
                                    DateTime.now(), [date_format.yyyy]);
                                getIncomeChartsData();
                              }
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Material(
                  color: Colors.transparent,
                  child: Theme(
                    data: ThemeData(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        tabBarTheme: const TabBarThemeData(
                            dividerColor: Colors.transparent)),
                    child: TabBar(
                      tabs: selTabs,
                      onTap: (index) {
                        _viewType = index;
                        setState(() {});
                      },
                      unselectedLabelColor:
                          const Color.fromRGBO(104, 104, 104, 1),
                      labelColor: const Color.fromRGBO(36, 193, 143, 1),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: const Color.fromRGBO(36, 193, 143, 1),
                      labelStyle: const TextStyle(fontSize: 17),
                      controller: selController,
                    ),
                  ),
                ),
                SizedBox(
                  height: (_viewType == 0) ? 100 : 160,
                  child: TabBarView(
                    controller: selController,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _cellView(
                              "${S.current.todayRevenue}(${S.current.yuan})",
                              (infoincomeData["todayPrice"] ?? "").toString()),
                          const SizedBox(width: 15),
                          _cellView(
                              "${S.current.totalRevenue}(${S.current.tenk_RMB})",
                              (infoincomeData["totalPrice"] ?? "").toString()),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _cellView(
                                  "${S.current.todayRevenue}(${S.current.yuan})",
                                  (infoincomeData["photovoltaicTodayPrice"] ??
                                          "")
                                      .toString()),
                              const SizedBox(width: 15),
                              _cellView(
                                  "${S.current.totalRevenue}(${S.current.tenk_RMB})",
                                  (infoincomeData["photovoltaicTotalPrice"] ??
                                          "")
                                      .toString()),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _cellView(
                                  "${S.current.totalGeneration}(MWh)",
                                  (infoincomeData["photovoltaicTotalPower"] ??
                                          "")
                                      .toString()),
                              const SizedBox(width: 15),
                              _cellView(
                                  "${S.current.totalOnGrid}(MWh)",
                                  (infoincomeData["photovoltaicTotalOnGrid"] ??
                                          "")
                                      .toString()),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _cellView(
                                  "${S.current.todayRevenue}(${S.current.yuan})",
                                  (infoincomeData["energyStorageTodayPrice"] ??
                                          "")
                                      .toString()),
                              const SizedBox(width: 15),
                              _cellView(
                                  "${S.current.totalRevenue}(${S.current.tenk_RMB})",
                                  (infoincomeData["energyStorageTotalPrice"] ??
                                          "")
                                      .toString()),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _cellView(
                                  "${S.current.totalCharging}(MWh)",
                                  (infoincomeData["energyStorageTotalCharge"] ??
                                          "")
                                      .toString()),
                              const SizedBox(width: 15),
                              _cellView(
                                  "${S.current.totalDischarge}(MWh)",
                                  (infoincomeData[
                                              "energyStorageTotalDischarge"] ??
                                          "")
                                      .toString()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Echarts(
                      option: jsonEncode({
                    "zlevel": 11,
                    "grid": {"left": 60, 'right': 10},
                    "tooltip": {"trigger": 'axis'},
                    "legend": {
                      "textStyle": {
                        //图例的公用文本样式。
                        "fontSize": 12,
                        "color": '#333'
                      },
                      "itemGap": 10,
                      //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                      "data": [
                        (S.current.totalRevenue),
                        (S.current.PV_revenue),
                        (S.current.ESS_revenue)
                      ],
                      //图例的数据数组。
                      "inactiveColor": '#ccc',
                    },
                    "xAxis": {
                      "type": 'category',
                      "data": xdata,
                      "axisLabel": {
                        "rotate": 45 // 将标签旋转45度
                      }
                    },
                    "yAxis": [
                      {
                        "type": 'value',
                        "name": _currentDateType == 0
                            ? S.current.yuan
                            : S.current.tenk_RMB,
                      }
                    ],
                    "series": [
                      {
                        'name': (S.current.totalRevenue),
                        "data": totalPriceList,
                        "type": 'line',
                        "smooth": true, // 是否让线条圆滑显示
                        "color": '#3D71FD',
                        "symbol": 'none'
                      },
                      {
                        'name': (S.current.PV_revenue),
                        "data": photovoltaicPriceList,
                        "type": 'line',
                        "smooth": true, // 是否让线条圆滑显示
                        "color": '#FBAF38',
                        "symbol": 'none'
                      },
                      {
                        'name': (S.current.ESS_revenue),
                        "data": energyStoragePriceList,
                        "smooth": true, // 是否让线条圆滑显示
                        "type": "line",
                        "color": '#2ED75A',
                        "symbol": 'none'
                      },
                    ]
                  })),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        ///环比分析
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                  Text((S.current.revenue_YoY_MoM_analysis),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          DateTime? d = await showMonthYearPicker(
                            context: context,
                            initialMonthYearPickerMode:
                                MonthYearPickerMode.month,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2019),
                            lastDate: DateTime(2030),
                            locale: savedLanguage == 'zh'
                                ? const Locale('zh')
                                : const Locale('en'),
                          );
                          if (d == null) {
                            return;
                          }
                          radarstartDate = date_format.formatDate(
                              d, [date_format.yyyy, '-', date_format.mm]);
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(0, 40),
                          shape: const StadiumBorder(),
                          side: const BorderSide(
                              color: Color.fromRGBO(212, 212, 212, 1),
                              width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              radarstartDate,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black26),
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
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          DateTime? d = await showMonthYearPicker(
                            context: context,
                            initialMonthYearPickerMode:
                                MonthYearPickerMode.month,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2019),
                            lastDate: DateTime(2030),
                            locale: savedLanguage == 'zh'
                                ? const Locale('zh')
                                : const Locale('en'),
                          );
                          if (d == null) {
                            return;
                          }
                          radarendDate = date_format.formatDate(
                              d!, [date_format.yyyy, '-', date_format.mm]);
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(0, 40),
                          shape: const StadiumBorder(),
                          side: const BorderSide(
                              color: Color.fromRGBO(212, 212, 212, 1),
                              width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              radarendDate,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black26),
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
                ],
              ),
              const SizedBox(height: 6),
              Material(
                color: Colors.transparent,
                child: Theme(
                  data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      tabBarTheme: const TabBarThemeData(
                          dividerColor: Colors.transparent)),
                  child: TabBar(
                    tabs: radarTabs,
                    unselectedLabelColor:
                        const Color.fromRGBO(104, 104, 104, 1),
                    labelColor: const Color.fromRGBO(36, 193, 143, 1),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: const Color.fromRGBO(36, 193, 143, 1),
                    labelStyle: const TextStyle(fontSize: 17),
                    controller: radarController,
                  ),
                ),
              ),
              SizedBox(
                height: 600,
                child: TabBarView(
                  controller: radarController,
                  children: [
                    FutureBuilder(
                        future: getincomeRadarData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                SizedBox(
                                  // width: ScreenDimensions.screenWidth(context)*0.3,
                                  height: 240,
                                  child: echarDadarView(radarData),
                                ),
                                getTableView(radarData)
                              ],
                            );
                          } else {
                            return const SizedBox(
                                height: 280,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                        }),
                    FutureBuilder(
                        future: getincomeRadarData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  height: 240,
                                  child: echarDadarView2(radarData),
                                ),
                                getTableView2(radarData)
                              ],
                            );
                          } else {
                            return const SizedBox(
                                height: 280,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  echarDadarView(Map radarData) {
    Map smp = radarData['left'][0];
    List startList = [
      smp["totalPrice"] ?? 0,
      smp["greenElectricityTrading"] ?? 0,
      smp["spotTrading"] ?? 0,
      smp["requirementResponse"] ?? 0,
      smp["peakValley"] ?? 0
    ];
    Map emp = radarData['left'][1];
    List endList = [
      emp["totalPrice"] ?? 0,
      emp["greenElectricityTrading"] ?? 0,
      emp["spotTrading"] ?? 0,
      emp["requirementResponse"] ?? 0,
      emp["peakValley"] ?? 0
    ];
    return Echarts(
        option: jsonEncode({
      "color": ['#FBAF38', '#3D71FD', '#E966D8'],
      "legend": {
        "textStyle": {
          //图例的公用文本样式。
          "fontSize": 12,
          "color": '#333'
        },
        "itemGap": 10,
        //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
        "data": [radarstartDate, radarendDate],
        //图例的数据数组。
        "inactiveColor": '#ccc',
      },
      "radar": {
        "center": ['50%', '60%'], // 外圆的位置
        "radius": '65%',
        "name": {
          "textStyle": {
            "color": '#333',
            "fontSize": 10,
            "fontWeight": 400,
            "fontFamily": 'PingFangSC-Regular,PingFang SC',
            "fontStyle": 'normal',
          }
        },
        "indicator": [
          {"name": S.current.totalRevenue},
          {"name": S.current.greenElectricityTrading},
          {"name": S.current.spotTrading},
          {"name": S.current.demandResponse},
          {"name": S.current.peakValleyRevenue},
        ],
      },
      "series": [
        {
          "type": 'radar',
          "symbolSize": 1,
          "data": [
            {
              // TODO:
              "value": startList,
              "name": radarstartDate,
              "areaStyle": {
                "normal": {"color": 'rgba(251, 175, 56, 0.3)'}
              },
              "lineStyle": {"width": 0.5},
            },
            {
              // TODO:
              "value": endList,
              "name": radarendDate,
              "areaStyle": {
                "normal": {"color": 'rgba(61, 113, 253, 0.3)'}
              },
              "lineStyle": {"width": 0.5},
            },
            // {
            //   // TODO:
            //   "value": [10, 40, 30, 88, 44, 76],
            //   "name": '去年同期',
            //   "areaStyle": {
            //     "normal": {"color": 'rgba(233, 102, 216, 0.3)'}
            //   },
            //   "lineStyle": {"width": 0.5},
            // }
          ]
        }
      ]
    }));
  }

  echarDadarView2(Map radarData) {
    Map smp = radarData['right'][0];
    List startList = [
      smp["consumption"] ?? 0,
      smp["energyStorageCharge"] ?? 0,
      smp["energyStorageDischarge"] ?? 0,
      smp["chargingPileCharge"] ?? 0,
      smp["onGrid"] ?? 0
    ];
    Map emp = radarData['right'][1];
    List endList = [
      emp["consumption"] ?? 0,
      emp["energyStorageCharge"] ?? 0,
      emp["energyStorageDischarge"] ?? 0,
      emp["chargingPileCharge"] ?? 0,
      emp["onGrid"] ?? 0
    ];

    return Echarts(
        option: jsonEncode({
      "color": ['#FBAF38', '#3D71FD', '#E966D8'],
      "legend": {
        "textStyle": {
          //图例的公用文本样式。
          "fontSize": 12,
          "color": '#333'
        },
        "itemGap": 10,
        //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
        "data": [radarstartDate, radarendDate],
        //图例的数据数组。
        "inactiveColor": '#ccc',
      },
      "radar": {
        "center": ['50%', '60%'], // 外圆的位置
        "radius": '65%',
        "name": {
          "textStyle": {
            "color": '#333',
            "fontSize": 10,
            "fontWeight": 400,
            "fontFamily": 'PingFangSC-Regular,PingFang SC',
            "fontStyle": 'normal',
          }
        },
        "indicator": [
          {"name": S.current.pvConsumption},
          {"name": S.current.essCharging},
          {"name": S.current.essDischarge},
          {"name": S.current.chargerCharging},
          {"name": S.current.onGrid},
        ],
      },
      "series": [
        {
          "type": 'radar',
          "symbolSize": 1,
          "data": [
            {
              // TODO:
              "value": startList,
              "name": radarstartDate,
              "areaStyle": {
                "normal": {"color": 'rgba(251, 175, 56, 0.3)'}
              },
              "lineStyle": {"width": 0.5},
            },
            {
              // TODO:
              "value": endList,
              "name": radarendDate,
              "areaStyle": {
                "normal": {"color": 'rgba(61, 113, 253, 0.3)'}
              },
              "lineStyle": {"width": 0.5},
            },
          ]
        }
      ]
    }));
  }

  getTableView(Map radarData) {
    Map smp = radarData['left'][0];
    Map emp = radarData['left'][1];
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 120,
              height: 40,
              color: const Color(0xFFF2F8F9),
            ),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text(
                      '${S.current.totalRevenue}(${S.current.tenk_RMB})',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text(
                      '${S.current.peakValleyRevenue}(${S.current.tenk_RMB})',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text(
                      '${S.current.greenElectricityTrading}(${S.current.tenk_RMB})',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.spotTrading}(${S.current.tenk_RMB})',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text(
                      '${S.current.demandResponse}(${S.current.tenk_RMB})',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                ))
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                  height: 40,
                  color: const Color(0xFFF2F8F9),
                  child: Center(
                    child: Text('${smp["time"] ?? "--"}',
                        style: const TextStyle(color: Color(0xFF8693AB))),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${smp["totalPrice"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${smp["peakValley"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${smp["greenElectricityTrading"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${smp["spotTrading"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${smp["requirementResponse"] ?? 0}'),
                  ))
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                  height: 40,
                  color: const Color(0xFFF2F8F9),
                  child: Center(
                    child: Text('${emp["time"] ?? "--"}',
                        style: const TextStyle(color: Color(0xFF8693AB))),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${emp["totalPrice"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${emp["peakValley"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${emp["greenElectricityTrading"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${emp["spotTrading"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${emp["requirementResponse"] ?? 0}'),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  getTableView2(Map radarData) {
    Map smp = radarData['right'][0];
    Map emp = radarData['right'][1];
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 140,
              height: 40,
              color: const Color(0xFFF2F8F9),
            ),
            Container(
                width: 140,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.pvConsumption}(kWh)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 140,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.onGrid}(kWh)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 140,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.chargerCharging}(kWh)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 140,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.essDischarge}(kWh)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 140,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.essCharging}(kWh)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                ))
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                  height: 40,
                  color: const Color(0xFFF2F8F9),
                  child: Center(
                    child: Text('${smp["time"] ?? "--"}',
                        style: const TextStyle(color: Color(0xFF8693AB))),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${smp["consumption"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${smp["onGrid"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${smp["chargingPileCharge"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${smp["energyStorageDischarge"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${smp["energyStorageCharge"] ?? 0}'),
                  ))
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                  height: 40,
                  color: const Color(0xFFF2F8F9),
                  child: Center(
                    child: Text('${emp["time"] ?? "--"}',
                        style: const TextStyle(color: Color(0xFF8693AB))),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${emp["consumption"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${emp["onGrid"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${emp["chargingPileCharge"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${emp["energyStorageDischarge"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${emp["energyStorageCharge"] ?? 0}'),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  // _pointView(Color color, String num) {
  //   return Row(
  //     children: [
  //       Container(
  //         width: 8.0,
  //         height: 8.0,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: color,
  //         ),
  //       ),
  //       const SizedBox(width: 5),
  //       Text(
  //         num,
  //         style: const TextStyle(fontSize: 12),
  //       ),
  //     ],
  //   );
  // }

  _cellView(String title, String num) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 70,
        decoration: BoxDecoration(
            color: const Color(0xFFF2F8F9),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8693AB)),
            ),
            const SizedBox(height: 6),
            Text(
              num,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
