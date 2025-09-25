import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/generated/l10n.dart';

class OplOperationteamDetailPage extends StatefulWidget {
  const OplOperationteamDetailPage({super.key, required this.teamId});

  final int teamId;

  @override
  State<OplOperationteamDetailPage> createState() =>
      _OplOperationteamDetailPageState();
}

class _OplOperationteamDetailPageState
    extends State<OplOperationteamDetailPage> {
  List stationList = [];

  @override
  void initState() {
    super.initState();
    _getworkTeamList();
  }

  _getworkTeamList() async {
    var data = await WorkDao.selectStationById(params: {"id": widget.teamId});
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        stationList = data['data'];
        log(stationList.toString());
      }
      setState(() {});
    } else {
      stationList.clear();
      setState(() {});
    }
  }

  // 获取电站类型文本
  String getStationTypeText(int type) {
    switch (type) {
      case 1:
        return S.current.mg;
      case 2:
        return S.current.ess;
      case 3:
        return S.current.pv;
      case 4:
        return S.current.charger;
      default:
        return S.current.unknown_type;
    }
  }

  // 获取电站类型对应的颜色
  Color getStationTypeColor(int type) {
    switch (type) {
      case 1:
        return Colors.purple.shade600;
      case 2:
        return Colors.blue.shade600;
      case 3:
        return Colors.green.shade600;
      case 4:
        return Colors.orange.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: EdgeInsets.all(16),
        child: stationList.isEmpty
            ? Center(child: Text(S.current.loading))
            : ListView.builder(
                itemCount: stationList.length,
                itemBuilder: (context, index) {
                  Map stationData = stationList[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 电站信息头部
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  stationData['itemName'] ??
                                      S.current.no_data_available,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: getStationTypeColor(
                                            stationData['itemType'] ?? 0)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    getStationTypeText(
                                        stationData['itemType'] ?? 0),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: getStationTypeColor(
                                          stationData['itemType'] ?? 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),

                            // 公司和地区信息
                            Row(
                              children: [
                                Icon(Icons.business,
                                    size: 14, color: Colors.grey),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${stationData['companyName'] ?? S.current.no_data_available} - ${stationData['provinceName'] ?? ''}${stationData['cityName'] ?? ''}${stationData['areaName'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),

                            // 运维人员列表
                            Text(
                              S.current.personnel,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  (stationData['userList'] as List).map((user) {
                                        return Chip(
                                          label: Text(user['lastName'] ??
                                              S.current.unknown_user),
                                          backgroundColor: Colors.blue.shade50,
                                          labelStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue.shade700,
                                          ),
                                          elevation: 1,
                                        );
                                      }).toList() ??
                                      [],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
