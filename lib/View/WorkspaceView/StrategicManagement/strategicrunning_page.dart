import 'package:date_format/date_format.dart' as date_format;
import 'package:suncloudm/toolview/imports.dart';

class StrategicrunningPage extends StatefulWidget {
  const StrategicrunningPage({super.key});

  @override
  State<StrategicrunningPage> createState() => _StrategicrunningPageState();
}

class _StrategicrunningPageState extends State<StrategicrunningPage> {
  String seleteId = '';
  String seleteName = S.current.please_select;
  List companyList = [];
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  final TextEditingController searchController =
      TextEditingController(); // 新增控制器
  String? singleId = GlobalStorage.getSingleId();
  String seleteDate = date_format.formatDate(DateTime.now(),
      [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
  Map<String, dynamic> _pageData = {};
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (isOperator == true && singleId == null) {
      String? jsonStr = GlobalStorage.getCompanyList();
      companyList = jsonDecode(jsonStr!);
      seleteId = companyList[0]["id"].toString();
      seleteName = companyList[0]["itemName"].toString();
    }
  }

  Future<Map<String, dynamic>> _getStrategyList() async {
    Map<String, dynamic> params = {};
    params['date'] = seleteDate;
    if (singleId != null) {
      params['itemId'] = singleId;
    } else if (seleteId != "") {
      params['itemId'] = seleteId;
    }
    print(params);
    var data = await StrategyDao.getStrategy(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return _pageData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  _getSettingData(List? datelist) {
    if (datelist == null) {
      return [
        const DataRow(
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        )
      ];
    } else {
      return datelist
          .map((e) => DataRow(
                cells: [
                  DataCell(Text(e["startTime"] ?? "")),
                  DataCell(Text(e["endTime"] ?? "")),
                  DataCell(Text((e["pset"] ?? "").toString())),
                  DataCell(Text((e["socMax"] ?? "").toString())),
                  DataCell(Text((e["socMin"] ?? "").toString())),
                  DataCell(Text((e["pstopMax"] ?? "").toString())),
                  DataCell(Text((e["pstopMin"] ?? "").toString())),
                ],
              ))
          .toList();
    }
  }

  _getActualData(List? datelist) {
    if (datelist == null) {
      return [
        const DataRow(
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        )
      ];
    } else {
      return datelist
          .map((e) => DataRow(
                cells: [
                  DataCell(Text(e["startTime"] ?? "")),
                  DataCell(Text(e["endTime"] ?? "")),
                  DataCell(Text((e["minPower"] ?? "").toString())),
                  DataCell(Text((e["maxPower"] ?? "").toString())),
                  DataCell(Text((e["upperLimit"] ?? "").toString())),
                  DataCell(Text((e["lowerLimit"] ?? "").toString())),
                ],
              ))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 8,
        ),
        Visibility(
          visible: (isOperator == true && singleId == null) ? true : false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: SearchField(
              controller: searchController,
              maxSuggestionsInViewPort: 5,
              itemHeight: 60,
              hint: seleteName,
              searchInputDecoration: SearchInputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.white,
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
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              marginColor: Colors.grey.shade300,
              suggestions: companyList
                  .map((e) =>
                      SearchFieldListItem(e['itemName'].toString(), item: e))
                  .toList(),
              focusNode: focusNode,
              onTapOutside: (e) {
                focusNode.unfocus();
              },
              onSuggestionTap: (SearchFieldListItem x) {
                seleteId = x.item!['id'].toString();
                seleteName = x.item['itemName'].toString();
                searchController.text = seleteName;
                setState(() {});
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
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
                seleteDate = date_format.formatDate(d!, [
                  date_format.yyyy,
                  '-',
                  date_format.mm,
                  '-',
                  date_format.dd
                ]);
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 40),
                shape: const StadiumBorder(),
                side: const BorderSide(color: Colors.grey, width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    seleteDate,
                    style: const TextStyle(fontSize: 16, color: Colors.black45),
                  ),
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black45,
                  )
                ],
              )),
        ),
        FutureBuilder(
            future: _getStrategyList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _pageData["time"] ?? '',
                          style: const TextStyle(color: Color(0xFF24C18F)),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          S.current.set_strategy,
                          style: TextStyle(
                              color: Color(0xFF24C18F),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${S.current.strategy_name}：${_pageData["strategyName"] ?? '--'}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingTextStyle: const TextStyle(fontSize: 12),
                            headingRowColor: WidgetStateProperty.all(
                                const Color(0xFFF2F8F9)),
                            headingRowHeight: 40,
                            columnSpacing: 20,
                            dataTextStyle: const TextStyle(fontSize: 12),
                            columns: [
                              DataColumn(
                                label: Text(S.current.start_time),
                              ),
                              DataColumn(
                                label: Text(S.current.end_time),
                              ),
                              DataColumn(
                                label: Text('${S.current.power}(kW)'),
                              ),
                              DataColumn(
                                label: Text(S.current.soc_upper_limit),
                              ),
                              DataColumn(
                                label: Text(S.current.soc_lower_limit),
                              ),
                              DataColumn(
                                label:
                                    Text('${S.current.power_upper_limit}(kW)'),
                              ),
                              DataColumn(
                                label:
                                    Text('${S.current.power_lower_limit}(kW)'),
                              ),
                            ],
                            rows: _getSettingData(_pageData["setting"]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.execution,
                          style: TextStyle(
                              color: Color(0xFF24C18F),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${S.current.strategy_name}：${S.current.anti_backflow}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingTextStyle: const TextStyle(fontSize: 12),
                            headingRowColor: WidgetStateProperty.all(
                                const Color(0xFFF2F8F9)),
                            headingRowHeight: 40,
                            columnSpacing: 20,
                            dataTextStyle: const TextStyle(fontSize: 12),
                            columns: [
                              DataColumn(
                                label: Text(S.current.start_time),
                              ),
                              DataColumn(
                                label: Text(S.current.end_time),
                              ),
                              DataColumn(
                                label: Text('${S.current.min_power}(kW)'),
                              ),
                              DataColumn(
                                label: Text('${S.current.max_power}(kW)'),
                              ),
                              DataColumn(
                                label: Text(S.current.soc_start_value),
                              ),
                              DataColumn(
                                label: Text(S.current.soc_end_value),
                              ),
                            ],
                            rows: _getActualData(_pageData["actual"]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
              } else {
                return const SizedBox(
                    height: 280,
                    child: Center(child: CircularProgressIndicator()));
              }
            }),
      ]),
    );
  }
}
