import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart' as date_format;
import 'model/oplDataAnalysisProvider.dart';
import 'package:suncloudm/toolview/imports.dart';

class OplDataAnalysis extends StatelessWidget {
  const OplDataAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OplDataAnalysisProvider(),
      child: const OplDataAnalysisContent(),
    );
  }
}

class OplDataAnalysisContent extends StatefulWidget {
  const OplDataAnalysisContent({super.key});

  @override
  State<OplDataAnalysisContent> createState() => _OplDataAnalysisContentState();
}

class _OplDataAnalysisContentState extends State<OplDataAnalysisContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OplDataAnalysisProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/oambg.png'), fit: BoxFit.fill)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                '数据分析',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            body: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          createSeleteCard(context, provider),
                          createChartCard(context, provider),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget createSeleteCard(
      BuildContext context, OplDataAnalysisProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  hint: Text(
                    provider.selectedTeam,
                    style: const TextStyle(fontSize: 15),
                  ),
                  items: provider.teamList
                      .map((item) => DropdownMenuItem<String>(
                            value: item['id'].toString(),
                            child: Text(
                              item['teamName'],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return null;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value != null) {
                      int teamId = int.parse(value);
                      String teamName = provider.teamList.firstWhere(
                        (item) => item['id'] == teamId,
                        orElse: () => {'teamName': ''},
                      )['teamName'];
                      provider.updateSelectedTeam(teamId, teamName);
                    }
                  },
                  onSaved: (value) {},
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  hint: Text(
                    provider.selectedGroup,
                    style: const TextStyle(fontSize: 15),
                  ),
                  value: provider.groupList.isNotEmpty
                      ? provider.groupList
                              .firstWhere(
                                  (item) =>
                                      item['id'] == provider.selectedGroupId,
                                  orElse: () => {})['id']
                              ?.toString() ??
                          null
                      : null,
                  items: provider.groupList.isNotEmpty
                      ? provider.groupList
                          .map((item) => DropdownMenuItem<String>(
                                value: item['id'].toString(),
                                child: Text(
                                  item['teamName'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ))
                          .toList()
                      : [],
                  validator: (value) {
                    if (value == null) {
                      return null;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value != null) {
                      int groupId = int.parse(value);
                      String groupName = provider.groupList.firstWhere(
                        (item) => item['id'] == groupId,
                        orElse: () => {'teamName': ''},
                      )['teamName'];
                      provider.updateSelectedGroup(groupId, groupName);
                    }
                  },
                  onSaved: (value) {},
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              DateTime? d = await showMonthYearPicker(
                context: context,
                initialMonthYearPickerMode: MonthYearPickerMode.month,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
                locale: savedLanguage == 'zh'
                    ? const Locale('zh')
                    : const Locale('en'),
              );
              if (d != null) {
                String time = date_format
                    .formatDate(d, [date_format.yyyy, '-', date_format.mm]);
                provider.updateSelectedTime(time);
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
                  provider.seleteTime,
                  style: const TextStyle(fontSize: 16, color: Colors.black26),
                ),
                const SizedBox(width: 15),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black26,
                  size: 14,
                )
              ],
            )),
      ],
    );
  }

  Widget createChartCard(
      BuildContext context, OplDataAnalysisProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 10),
        // 工单汇总图表
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: provider.workSummaryData.isNotEmpty
                ? [
                    Row(
                      children: [
                        const SizedBox(
                          height: 18,
                          child: VerticalDivider(
                            thickness: 3,
                            color: Colors.green,
                          ),
                        ),
                        const Text('工单汇总',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Echarts(
                            option: jsonEncode({
                          "zlevel": 11,
                          "tooltip": {"trigger": 'axis'},
                          "legend": {
                            "textStyle": {"fontSize": 11, "color": '#333'},
                            "itemGap": 5,
                            "data": [
                              S.current.unprocessed,
                              S.current.completed,
                            ],
                            "inactiveColor": '#ccc'
                          },
                          "grid": {
                            "right": 10,
                            "left": 10,
                            "bottom": 10,
                            "containLabel": true
                          },
                          "xAxis": {
                            "type": 'category',
                            "data": provider.workSummaryData['time'] ?? [],
                          },
                          "yAxis": [
                            {
                              "type": 'value',
                              "name": '个',
                            }
                          ],
                          "series": [
                            {
                              'name': S.current.unprocessed,
                              "data": provider
                                      .workSummaryData['unprocessedCount'] ??
                                  [],
                              "type": 'bar',
                              "symbol": 'none',
                              "color": '#0F9CFF',
                            },
                            {
                              'name': S.current.completed,
                              "data":
                                  provider.workSummaryData['completedCount'] ??
                                      [],
                              "type": 'bar',
                              "symbol": 'none',
                              "color": '#C666DE',
                            },
                          ]
                        }))),
                    const SizedBox(height: 10),
                  ]
                : [
                    SizedBox(
                        height: 80,
                        child: Center(child: Text(S.current.no_data)))
                  ],
          ),
        ),

        const SizedBox(height: 10),
        // 接单统计图表
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: provider.acceptStatisticsData.isNotEmpty
                ? [
                    Row(
                      children: [
                        const SizedBox(
                          height: 18,
                          child: VerticalDivider(
                            thickness: 3,
                            color: Colors.green,
                          ),
                        ),
                        const Text('接单统计',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const Spacer()
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Echarts(
                            option: jsonEncode({
                          "zlevel": 11,
                          "tooltip": {"trigger": 'axis'},
                          "legend": {
                            "textStyle": {"fontSize": 11, "color": '#333'},
                            "itemGap": 5,
                            "data": [
                              S.current.accept,
                              S.current.collaboration,
                            ],
                            "inactiveColor": '#ccc'
                          },
                          "grid": {
                            "right": 10,
                            "left": 10,
                            "bottom": 10,
                            "containLabel": true
                          },
                          "xAxis": {
                            "type": 'category',
                            "data":
                                provider.acceptStatisticsData['userName'] ?? [],
                          },
                          "yAxis": [
                            {
                              "type": 'value',
                              "name": '个',
                            }
                          ],
                          "series": [
                            {
                              'name': S.current.accept,
                              "data": provider
                                      .acceptStatisticsData['acceptCount'] ??
                                  [],
                              "type": 'bar',
                              "stack": 'a',
                              "color": '#91CC75',
                            },
                            {
                              'name': S.current.collaboration,
                              "data": provider.acceptStatisticsData[
                                      'collaborationCount'] ??
                                  [],
                              "type": 'bar',
                              "stack": 'a',
                              "color": '#5AB5F4',
                            },
                          ]
                        }))),
                    const SizedBox(height: 10),
                  ]
                : [
                    SizedBox(
                        height: 80,
                        child: Center(child: Text(S.current.no_data)))
                  ],
          ),
        ),

        const SizedBox(height: 10),
        // 工单处理排名
        provider.workRankData.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('运维人员工单处理数排名',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.workRankData.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 5,
                        color: Colors.transparent,
                      ),
                      itemBuilder: (context, index) {
                        Map datamap = provider.workRankData[index];
                        return Container(
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              rankImage(index),
                              const SizedBox(width: 10),
                              Text(datamap['userName'] ?? '',
                                  style: const TextStyle()),
                              const SizedBox(width: 10),
                              Text(datamap['teamName'] ?? '',
                                  style: const TextStyle()),
                              const SizedBox(width: 10),
                              Spacer(),
                              Text(datamap['returnCount'].toString(),
                                  style: const TextStyle(
                                      color: Color(0xFF3BBAAF))),
                              const SizedBox(width: 15),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: 80, child: Center(child: Text(S.current.no_data))),
      ],
    );
  }

  Widget rankImage(int index) {
    switch (index) {
      case 0:
        return const Image(image: AssetImage('assets/rank1.png'));
      case 1:
        return const Image(image: AssetImage('assets/rank2.png'));
      case 2:
        return const Image(image: AssetImage('assets/rank3.png'));
      default:
        return Stack(
          alignment: Alignment.center,
          children: [
            const Image(image: AssetImage('assets/rank4.png')),
            Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
              ),
            )
          ],
        );
    }
  }

  Widget rankTeam(List teamNameList) {
    return Expanded(
      child: ListView.separated(
          separatorBuilder: (_, __) => const VerticalDivider(
                width: 5,
                color: Colors.transparent,
              ),
          itemCount: teamNameList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return Container(
              margin: const EdgeInsets.all(7),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: const Color(0xFFE9F2FC),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                teamNameList[i],
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              )),
            );
          }),
    );
  }
}
