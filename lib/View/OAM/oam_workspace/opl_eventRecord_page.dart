import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class OplEventrecordPage extends StatefulWidget {
  const OplEventrecordPage({super.key});

  @override
  State<OplEventrecordPage> createState() => _OplEventrecordPageState();
}

class _OplEventrecordPageState extends State<OplEventrecordPage> {
  Map<String, dynamic> listparams = {};
  List eventList = [];

  List teamList = [];
  List<String> teamNameList = [];
  List memberList = [];
  List<String> memberNameList = [];

  String? _seleteTeamId;
  String? _seleteMemberName;
  String? _seleteMemberId;

  String? _seleteStartTime;
  String? _seleteEndTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _geteventList();
    _getworkTeamList();
  }

  _geteventList() async {
    // listparams['pageNum'] = 1;
    // listparams['teamId'] = _seleteTeamId;
    // listparams['userId'] = _seleteMemberId;
    // listparams['startTime'] = _seleteStartTime;
    // listparams['endTime'] = _seleteEndTime;
    // var data = await OPDao.geteventList(params: listparams);
    // debugPrint(listparams.toString());
    // if (data["code"] == 200) {
    //   eventList = [];
    //   if (data['data'] != null) {
    //     for (var v in (data['data']['records'])) {
    //       eventList.add(EventEntity.fromJson(v));
    //     }
    //   }
    //   setState(() {});
    // } else {}
  }

  //获取运维班组
  _getworkTeamList() async {
    // var data = await PersonDao.getworkTeamList();
    // debugPrint(data.toString());
    // if (data["code"] == 200) {
    //   if (data['data'] != null) {
    //     teamList = [];
    //     teamNameList = [];
    //     teamList = data['data'];
    //     // companyList = <CompanyModel>[];
    //     for (var v in teamList) {
    //       teamNameList!.add(v['teamName']);
    //     }
    //   }
    //   setState(() {});
    // } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/oambg.png'), fit: BoxFit.fill)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // 移除AppBar的阴影
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              '事件列表',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text(
                        '运维班组',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      items: teamNameList
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ))
                          .toList(),
                      validator: (value) {},
                      onChanged: (value) {
                        int selectedIndex = teamNameList.indexOf(value!);
                        if (_seleteTeamId !=
                            teamList[selectedIndex]['id'].toString()) {
                          _seleteTeamId =
                              teamList[selectedIndex]['id'].toString();
                          //获取下面人员列表
                          memberList = teamList[selectedIndex]['member'];
                          memberNameList = [];
                          _seleteMemberName = null;
                          _seleteMemberId = null;
                          for (var v in memberList) {
                            memberNameList!.add(v['lastName']);
                          }
                        }
                        _geteventList();
                      },
                      onSaved: (value) {},
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFF64B5F6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text(
                        '运维人员',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      value: _seleteMemberName,
                      items: memberNameList
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ))
                          .toList(),
                      validator: (value) {},
                      onChanged: (value) {
                        int selectedIndex = memberNameList.indexOf(value!);
                        _seleteMemberName = value;
                        _seleteMemberId =
                            memberList[selectedIndex]['userId'].toString();
                        _geteventList();
                      },
                      onSaved: (value) {},
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        width: 600,
                        offset: const Offset(-50, 0),
                        padding: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFF64B5F6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        DateTimeRange? d = await showDateRangePicker(
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            context: context,
                            firstDate: DateTime(2000, 1),
                            lastDate: DateTime(2030, 12),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData(
                                  colorScheme: ColorScheme.fromSeed(
                                      seedColor:
                                          const Color(0xFF3BBAAF)), // 举例颜色
                                ),
                                child: child!,
                              );
                            });
                        _seleteStartTime =
                            formatDate(d!.start, [yyyy, '-', mm, '-', dd]);
                        _seleteEndTime =
                            formatDate(d!.end, [yyyy, '-', mm, '-', dd]);
                        // _paramdata['expiryDate'] = _seleteTime;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Text(
                            _seleteStartTime != null
                                ? '$_seleteStartTime-$_seleteEndTime'
                                : '选择开始和结束时间',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: ListView.builder(
                        itemCount: eventList.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                              onTap: () => navigate(i),
                              child: _eventcardView(eventList[i]));
                        }),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void navigate(int? id) {
    // EventEntity model = eventList[id!];
    // // // debugPrint(model.toJson().toString());
    // // // var modelJson  =model.toJson();
    // // // String modelStr=convert.jsonEncode(modelJson);
    // Routes.instance!
    //     .navigateTo(context, Routes.opeventinfo, model.id.toString());
  }

  Widget _eventcardView(Map model) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        // height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xFF91BFF6),
                          Color(0xFF237DE6),
                        ],
                      ),
                    ),
                    child: Center(
                        child:
                            Text('储能', style: TextStyle(color: Colors.white)))),
                const SizedBox(width: 10),
                Text(
                  '123',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Container()),
                const SizedBox(width: 10),
                Text(
                  '---',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFE9F2FC)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'model.eventRemark!',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ));
  }
}
