import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/work_entity.dart';
import 'package:suncloudm/generated/l10n.dart';

class GetOrderPage extends StatefulWidget {
  WorkEntity model;

  GetOrderPage(this.model, {super.key});

  @override
  State<GetOrderPage> createState() => _GetOrderPageState();
}

class _GetOrderPageState extends State<GetOrderPage> {
  late int planTime; //优先级

  List memberList = [];
  List<String> memberNameList = [];
  String? _selectedOption = 'A';

  String _seleteMemberName = S.current.please_select;
  String? _seleteMemberId; // 班组人员id

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    planTime = widget.model.planTime ?? 2;
    _getworkMemberList(widget.model.groupId!);
  }

  _getworkMemberList(int groupId) async {
    Map<String, dynamic> params = {};
    params['id'] = groupId;
    var data = await WorkDao.getTeamMemberList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        memberList = [];
        memberNameList = [];
        // memberList = data['data'];
        // String str = widget.model.personnel!;
        for (var v in data['data']) {
          if (widget.model.personnel != v['userId'].toString()) {
            memberList.add(v);
            memberNameList.add(v['lastName']);
          }
        }
      }
      setState(() {});
    } else {}
  }

  _submit() async {
    // if (_reasonController.text.isEmpty && planTime>2) {
    //   SVProgressHUD.showInfo(status: '超过规定时间请写明备注');
    //   return;
    // }
    Map<String, dynamic> paramdata = {};
    paramdata['nowStatus'] = widget.model.status;
    paramdata['workNumber'] = widget.model.workNumber;
    // paramdata['createId'] = widget.model.createId;
    paramdata['planTime'] = planTime;
    if (_selectedOption == 'B') {
      paramdata['assistantsId'] = _seleteMemberId;
    }
    // paramdata['planRemark'] = _reasonController.text;
    debugPrint(paramdata.toString());
    var data = await WorkDao.saveWorkEvent(params: paramdata);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      SVProgressHUD.showSuccess(status: S.current.submit_success);
      Navigator.of(context).pop();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              S.current.order_confirmation,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            S.current.plan_presence_time,
            style: TextStyle(fontSize: 14),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (planTime == 1) {
                  } else {
                    planTime--;
                    setState(() {});
                  }
                },
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Color(0xFF3BBAAF),
                  size: 25,
                ),
              ),
              Text('${planTime}h', style: const TextStyle(fontSize: 22)),
              IconButton(
                onPressed: () {
                  planTime++;
                  setState(() {});
                },
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFF3BBAAF),
                  size: 25,
                ),
              )
            ],
          ),
          const SizedBox(height: 6),
          Column(
            children: [
              Text(
                S.current.is_there_cooperative_personnel,
              ),
              Row(
                // 横向排布时的对齐方式
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 第一个选项
                  InkWell(
                    // 点击整个区域触发选择
                    onTap: () => setState(() => _selectedOption = 'A'),
                    // 自定义点击反馈
                    splashColor: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      // 控制整体内边距，减小占用空间
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      child: Row(
                        children: [
                          Radio(
                            value: 'A',
                            groupValue: _selectedOption,
                            onChanged: (value) =>
                                setState(() => _selectedOption = 'A'),
                            // 缩小单选按钮大小
                            visualDensity: VisualDensity.compact,
                          ),
                          // 减小按钮与文字的间距
                          const SizedBox(width: 0),
                          Text(
                            S.current.no,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // 第二个选项
                  InkWell(
                    onTap: () => setState(() => _selectedOption = 'B'),
                    splashColor: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      child: Row(
                        children: [
                          Radio(
                            value: 'B',
                            groupValue: _selectedOption,
                            onChanged: (value) =>
                                setState(() => _selectedOption = 'B'),
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 0),
                          Text(
                            S.current.yes,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _selectedOption == 'B'
              ? InkWell(
                  onTap: () {
                    showCheckboxDialog(context, memberNameList,
                            S.current.please_select_om_personnel)
                        .then((value) async {
                      print(value);
                      List v = value;
                      _seleteMemberName = '';
                      List seleteNameList = [];
                      List seletePeopleList = [];
                      for (var index in v) {
                        seleteNameList.add(memberNameList[index]);
                        seletePeopleList.add(memberList[index]['userId']);
                      }
                      if (seleteNameList.isNotEmpty) {
                        _seleteMemberName = seleteNameList.join(',');
                        _seleteMemberId = seletePeopleList.join(',');
                        setState(() {});
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _seleteMemberName,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.grey,
                        size: 18,
                      )
                    ],
                  ),
                )
              : Container(),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              _submit();
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF3BBAAF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                S.current.accept,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 自定义单选框对话框
  Future<int?> showRadioDialog(
      BuildContext context, List<String> seleteNameList, String title) async {
    return showDialog<int?>(
      context: context,
      builder: (BuildContext context) {
        // 单选框选项
        final List<String> options = seleteNameList;

        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: Text(title),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              height: 300,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(index);
                    },
                    child: ListTile(
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

  // 自定义多选框对话框
  Future<List<int>> showCheckboxDialog(
      BuildContext context, List<String> selectNameList, String title) async {
    List<bool> _selected = List.filled(selectNameList.length, false);

    final result = await showDialog<List<int>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              title: Text(title),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 300,
                  height: 250,
                  child: ListView.builder(
                    itemCount: selectNameList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(selectNameList[index]),
                        value: _selected[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _selected[index] = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(S.current.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(S.current.confirm),
                  onPressed: () {
                    List<int> selectedIndices = [];
                    for (int i = 0; i < _selected.length; i++) {
                      if (_selected[i]) {
                        selectedIndices.add(i);
                      }
                    }
                    Navigator.of(context).pop(selectedIndices);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    return result ?? [];
  }
}
