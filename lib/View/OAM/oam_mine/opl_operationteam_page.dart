import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/generated/l10n.dart';
import 'package:suncloudm/routes/Routes.dart';
import 'package:suncloudm/View/OAM/oam_mine/opl_operationteam_detail_page.dart';

class OplOperationteamPage extends StatefulWidget {
  const OplOperationteamPage({super.key});

  @override
  State<OplOperationteamPage> createState() => _OplOperationteamPageState();
}

class _OplOperationteamPageState extends State<OplOperationteamPage> {
  List teamList = [];

  @override
  void initState() {
    super.initState();
    _getworkTeamList();
  }

  _getworkTeamList() async {
    var data = await WorkDao.getTeamList();
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        teamList = data['data'];
        log(teamList.toString());
      }
      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          S.current.OM_team,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFEDF1F7),
        child: ListView.builder(
            itemCount: teamList.length,
            itemBuilder: (context, i) {
              return _buildTeamHierarchy(teamList[i]);
            }),
      ),
    );
  }

  // 构建团队层级结构的方法
  Widget _buildTeamHierarchy(Map teamData, {int level = 0}) {
    bool hasChildren = teamData.containsKey('childList') &&
        teamData['childList'] != null &&
        teamData['childList'].isNotEmpty;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 14 + (level * 20.0), // 根据层级添加缩进
            right: 14,
            top: 6,
            bottom: 6,
          ),
          // 添加InkWell作为可点击容器
          child: InkWell(
            onTap: () {
              // 跳转到团队详情页并传递teamId
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OplOperationteamDetailPage(
                    teamId: teamData['id'],
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    // 显示团队名称
                    Text(
                      teamData['teamName'] ?? '暂无',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        // 根层级使用不同的颜色以示区分
                        color: level == 0 ? Colors.black : Colors.blue.shade700,
                      ),
                    ),
                    // 显示团队人数
                    if (teamData.containsKey('workerCount') &&
                        teamData['workerCount'] != null &&
                        teamData['workerCount'] > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${teamData['workerCount']}人',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    Expanded(child: Container()),
                    // 如果有子团队，显示箭头
                    if (hasChildren)
                      Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.grey,
                        size: 16,
                      ),
                  ],
                )),
          ),
        ),
        // 递归显示子团队
        if (hasChildren)
          Column(
            children: (teamData['childList'] as List).map((childTeam) {
              return _buildTeamHierarchy(childTeam, level: level + 1);
            }).toList(),
          ),
      ],
    );
  }

  void navigate(int? id) {
    // Map params = {};
    // params['id'] = teamList[id!]['id'].toString();
    // params['name'] = teamList[id!]['teamName'];
    // String encodedName = jsonEncode(params);
    // Routes.instance!.navigateTo(context, Routes.adopteammember, encodedName);
  }

  Widget _messagecardView(int i) {
    Map teamData = teamList[i];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 60,
          child: Row(
            children: [
              Text(
                teamData['teamName'] ?? '暂无',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 10),
              Visibility(
                visible: teamData['positionId'] == 1 ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 45,
                    decoration: BoxDecoration(
                        color: Color(0xFFEBF8F7), // 背景颜色
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                            color: Color(0xFF3BBAAF), width: 1) // 圆角半径
                        ),
                    child: Text(
                      '组长',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF3BBAAF)), // 文字颜色
                    ),
                  ),
                ),
              ),
              Container(
                width: 55,
                decoration: BoxDecoration(
                  color: teamData['status'] == 0
                      ? Color(0xFFF3F4F6)
                      : Color(0xFFEDFAEB), // 背景颜色
                  borderRadius: BorderRadius.circular(10.0), // 圆角半径
                ),
                child: Text(
                  teamData['status'] == 0 ? '禁用' : '启用',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: teamData['status'] == 0
                          ? Color(0xFF8692A3)
                          : Color(0xFF4DCF37)), // 文字颜色
                ),
              ),
              Expanded(child: Container()),
            ],
          )),
    );
  }

  Widget _messagecard111View(int i) {
    Map teamData = teamList[i];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          // height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    teamData['teamName'] ?? '暂无',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: teamData['status'] == 0
                          ? Color(0xFFF3F4F6)
                          : Color(0xFFEDFAEB), // 背景颜色
                      borderRadius: BorderRadius.circular(10.0), // 圆角半径
                    ),
                    child: Text(
                      teamData['status'] == 0 ? '禁用' : '启用',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: teamData['status'] == 0
                              ? Color(0xFF8692A3)
                              : Color(0xFF4DCF37)), // 文字颜色
                    ),
                  ),
                  Expanded(child: Container()),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.grey,
                    size: 18,
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '电站名称',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      teamData['stationNameList'] ?? '暂无',
                      style: const TextStyle(fontSize: 16),
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 2,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
