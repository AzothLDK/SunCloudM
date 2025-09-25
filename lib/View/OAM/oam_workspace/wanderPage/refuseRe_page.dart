import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/work_entity.dart';
import 'package:suncloudm/generated/l10n.dart';

class RefuserePage extends StatefulWidget {
  WorkEntity model;

  RefuserePage(this.model, {super.key});

  @override
  State<RefuserePage> createState() => _RefuserePageState();
}

class _RefuserePageState extends State<RefuserePage> {
  final TextEditingController _reasonController = TextEditingController();
  String _seleteTime = S.current.please_select;

  _submit() async {
    if (_reasonController.text.isEmpty) {
      SVProgressHUD.showInfo(status: S.current.please_input_reason);
      return;
    }
    Map<String, dynamic> paramdata = {};
    paramdata['nowStatus'] = widget.model.status;
    paramdata['workNumber'] = widget.model.workNumber;
    paramdata['remark'] = _reasonController.text;
    paramdata['isApproved'] = 0;
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
      height: 200,
      width: 200,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                S.current.refuse_return_work_order,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 80,
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
                Expanded(
                  child: InkWell(
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
}
