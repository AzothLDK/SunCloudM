import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/View/OAM/model/work_entity.dart';
import 'package:suncloudm/generated/l10n.dart';

class ToOtherPage extends StatefulWidget {
  WorkEntity model;

  ToOtherPage(this.model, {super.key});

  @override
  State<ToOtherPage> createState() => _ToOtherPageState();
}

class _ToOtherPageState extends State<ToOtherPage> {
  final TextEditingController _reasonController = TextEditingController();

  List teamList = [];
  List<String> teamNameList = [];
  List memberList = [];
  List<String> memberNameList = [];

  String _seleteteamName = S.current.please_select;
  int? _seleteteamId; // 班组id

  String _seleteMemberName = S.current.please_select;
  int? _seleteMemberId; // 班组人员id

  String? _selectedOption = 'A';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getworkMemberList(widget.model.groupId!);
    // _getworkTeamList();
  }

  _otOther() async {
    if (_selectedOption == 'A') {
      if (_reasonController.text.isEmpty) {
        SVProgressHUD.showInfo(status: S.current.please_input_reason);
        return;
      }
    }
    if (_selectedOption == 'B') {
      if (_seleteMemberId == null) {
        SVProgressHUD.showInfo(status: S.current.please_select_om_personnel);
        return;
      }
    }
    Map<String, dynamic> paramdata = {};
    paramdata['nowStatus'] = widget.model.status;
    paramdata['workNumber'] = widget.model.workNumber;

    paramdata['isApproved'] = 1;
    if (_selectedOption == 'A') {
      paramdata['remark'] = _reasonController.text;
    } else {
      paramdata['personnelId'] = _seleteMemberId;
    }
    // paramdata['teamId'] = _seleteteamId;
    // paramdata['personnelId'] = _seleteMemberId;
    debugPrint(paramdata.toString());
    var data = await WorkDao.saveWorkEvent(params: paramdata);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      SVProgressHUD.showSuccess(status: S.current.submit_success);
      Navigator.of(context).pop();
    } else {
      SVProgressHUD.showError(status: data['msg']);
    }
  }

  // //获取运维班组
  // _getworkTeamList() async {
  //   var data = await PersonDao.getworkTeamList();
  //   debugPrint(data.toString());
  //   if (data["code"] == 200) {
  //     if (data['data'] != null) {
  //       teamNameList = [];
  //       teamList = data['data'];
  //       for (var v in teamList) {
  //         teamNameList!.add(v['teamName']);
  //       }
  //     }
  //     setState(() {});
  //   } else {}
  // }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Center(
              child: Text(
                S.current.apply_return_work_order,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 15),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
                          S.current.return_platform,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                // 第二个选项
                InkWell(
                  onTap: () => setState(() => _selectedOption = 'B'),
                  splashColor: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
                          S.current.send_to_other_group_members,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _selectedOption == 'A'
                ? SizedBox(
                    height: 70,
                    child: TextField(
                      maxLines: null,
                      controller: _reasonController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: S.current.please_input_reason,
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: -10),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        S.current.please_select_om_personnel,
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () {
                          showRadioDialog(context, memberNameList,
                                  S.current.please_select_om_personnel)
                              .then((value) async {
                            if (value != null) {
                              _seleteMemberName = memberNameList[value];
                              _seleteMemberId = memberList[value]['userId'];
                              setState(() {});
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _seleteMemberName,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.grey,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF1F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        S.current.cancel,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _otOther();
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
                        S.current.submit,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
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
        const int initialSelectedIndex = 0;

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
                      print('选择了${index}');
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
}
