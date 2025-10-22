import 'dart:convert';
import 'dart:io';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/asset_widget_builder.dart';
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/getOrder_page.dart';
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/preview_networkfile_view.dart'
    show PreviewNetworkWidget;
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/refuseRe_page.dart';
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/toOher_page.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/dao/storage.dart';
import 'package:suncloudm/utils/screentool.dart';
import 'package:suncloudm/View/OAM/model/work_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suncloudm/generated/l10n.dart';

class OplWorkinfoPage extends StatefulWidget {
  String workNumber;

  OplWorkinfoPage(this.workNumber, {super.key});

  @override
  State<OplWorkinfoPage> createState() => _OplWorkinfoPageState();
}

class _OplWorkinfoPageState extends State<OplWorkinfoPage>
    with SingleTickerProviderStateMixin {
  @override
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dealController = TextEditingController();

  late final TabController mController;

  late WorkEntity model = WorkEntity();
  Map? correlationAlarm;

  ///是否使用配件
  int isSpare = 1;

  ///是否有内外部投入
  int input = 1;
  List eventList = [];

  Future<dynamic>? _workInfoFuture;
  Future<dynamic>? _eventListFuture;

  StateSetter? bjSetter;
  StateSetter? nwSetter;

  @override
  void initState() {
    super.initState();
    mController = TabController(initialIndex: 0, length: 2, vsync: this);
    _workInfoFuture = getDetailInfo();
    _eventListFuture = getEventList();
  }

  Future<WorkEntity> getDetailInfo() async {
    Map<String, dynamic> paramdata = {'workNumber': widget.workNumber};
    var data = await WorkDao.getdetailsByWorkNumber(params: paramdata);
    debugPrint(paramdata.toString());
    if (data["code"] == 200) {
      return model = WorkEntity.fromJson(data['data']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  ///获取流转详情
  Future<List> getEventList() async {
    Map<String, dynamic> paramdata2 = {'workNumber': widget.workNumber};
    var data2 = await WorkDao.getworkEventList(params: paramdata2);
    debugPrint(paramdata2.toString());
    if (data2["code"] == 200) {
      return eventList = data2['data'];
    } else {
      throw Exception('暂时没有流转详情');
    }
  }

  // _submit(Map<String, dynamic> paramdata) async {
  //   debugPrint(paramdata.toString());
  //   var data = await WorkDao.saveWorkEvent(params: paramdata);
  //   debugPrint(data.toString());
  //   if (data["code"] == 200) {
  //     SVProgressHUD.showSuccess(status: '提交成功');
  //     // Navigator.of(context).pop();
  //     setState(() {});
  //   } else {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          S.current.work_order_details,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFEDF1F7),
          child: FutureBuilder(
              future: _workInfoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  return SizedBox(
                      height: 80,
                      child: Center(child: Text(S.current.no_data)));
                } else {
                  if ((model.status == 4 || model.status == 5) &&
                      model.isTake == 1) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 35.0,
                                child: ButtonsTabBar(
                                  width:
                                      (ScreenDimensions.screenWidth(context) -
                                              30) /
                                          2,
                                  contentCenter: true,
                                  tabs: [
                                    Tab(text: S.current.work_order_content),
                                    Tab(text: S.current.result),
                                  ],
                                  onTap: (index) {
                                    setState(() {});
                                  },
                                  controller: mController,
                                  backgroundColor: const Color(0xFF24C18F),
                                  unselectedBackgroundColor: Colors.white,
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  unselectedLabelStyle:
                                      const TextStyle(color: Color(0xFF8693AB)),
                                  buttonMargin: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  elevation: 0.5,
                                  radius: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                // height: 1200,
                                child: TabBarView(
                                    controller: mController,
                                    children: [
                                      workInfoView(),
                                      getDealStatus(model.status, context)
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        _bottomButton(),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: model.status == 2 ? 62 : 0),
                            child: workInfoView()),
                        _bottomButton(),
                      ],
                    );
                  }
                }
              }),
        ),
      ),
    );
  }

  Widget workInfoView() {
    return ListView(
      children: [
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  getworklevel(model.priority),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      model.alarmId != null
                          ? (model.alarmName ?? "--")
                          : (model.stationName ?? "--") +
                              (model.deviceName ?? "--"),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Expanded(child: Container()),
                  getworkStatus(model.status),
                  const SizedBox(width: 10)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    S.current.creator,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${model.createName ?? "--"} ',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    S.current.create_date,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${model.createTime}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.station_name,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    model.stationName ?? "--",
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.device_name,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    model.deviceName ?? "--",
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.station_address,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      model.stationAddress ?? "--",
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.unit,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    model.groupName ?? "--",
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.personnel,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    model.personnelName ?? "--",
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.work_order_content,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      model.alarmContent ?? "--",
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: model.workSource == 1 ? true : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.correlation_alarm,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    InkWell(
                      onTap: () {
                        // showModalBottomSheet(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return WaringText(correlationAlarm!);
                        //     });
                      },
                      child: const Text(
                        '关联告警>',
                        style:
                            TextStyle(fontSize: 14, color: Colors.lightGreen),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        FutureBuilder(
            future: _eventListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return SizedBox(
                    height: 80, child: Center(child: Text(S.current.no_data)));
              } else if (snapshot.hasData) {
                return Container(
                  height: 71 + (eventList.length) * 60,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: 10),
                      Text(
                        S.current.result,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: eventList.length,
                            itemBuilder: (context, index) {
                              String result = insertAtIndex(
                                  eventList[index]['triggerTime'].toString(),
                                  '\n',
                                  10);
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    result,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 10),
                                  const Image(
                                      image: AssetImage('assets/circley.png')),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          eventList[index]['createName'],
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          eventList[index]['statusMessage'],
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Row(
                                          children: [
                                            Visibility(
                                                visible: (eventList[index]
                                                            ['status'] ==
                                                        11)
                                                    ? true
                                                    : false,
                                                child: const Icon(
                                                  Icons.location_on_outlined,
                                                  size: 12,
                                                  color: Colors.grey,
                                                )),
                                            Expanded(
                                              child: Text(
                                                (eventList[index]['remark']) ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey),
                                                textAlign: TextAlign.start,
                                                // overflow: TextOverflow.ellipsis,
                                                // maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              }
              return Container();
            }),
      ],
    );
  }

  _makeCall() async {
    String phoneNumber = 'tel:${model.stationResponsiblePhone}';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  ///获取处理页面
  Widget getDealStatus(int? status, BuildContext context) {
    switch (status) {
      case 4:
      case 5:
        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  S.current.process_content,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.cause,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.right,
                        model.reason ?? "--",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.solution,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.right,
                        model.programme ?? "--",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.is_use_spare,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      model.isSpare == 1 ? '是' : '否',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.internal_external_investment,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      model.input == 1
                          ? S.current.internal
                          : S.current.external,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.investment_details,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      model.inputDetails ?? "--",
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.processing_photos_videos,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                        height: 75,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            List? picList = model.pictureUrl;
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                GestureDetector(
                                    child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: ClipRRect(
                                          //是ClipRRect，不是ClipRect
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // child: Container(width: 40,height: 40,color: Colors.green,),
                                          child: AssetSmallView(
                                            urlStr: picList![index]
                                                ['smallImage'],
                                            type: picList![index]['type'],
                                          ),
                                        )),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            GestureDetector(
                                          onTap: Navigator.of(context).pop,
                                          child: Center(
                                              child: PreviewNetworkWidget(
                                                  picList![index]
                                                      ['originalImage'],
                                                  picList![index]['type'])),
                                        ),
                                      );
                                    }),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) =>
                              Container(width: 15),
                          scrollDirection: Axis.horizontal,
                          itemCount: model.pictureUrl!.length,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  ///底部按钮
  Widget _bottomButton() {
    switch (model.status) {
      case 2:
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: Colors.white, // 设置背景颜色，可根据需求修改
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Row(
              children: [
                const SizedBox(width: 5),
                InkWell(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Column(
                      children: [
                        Icon(Icons.phone),
                        Text(
                          S.current.platform,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Column(
                      children: [
                        Icon(Icons.people),
                        Text(
                          S.current.applicant,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(24, 20, 24, 0),
                              backgroundColor: Colors.white,
                              content: RefuserePage(model),
                            );
                          });
                      setState(() {
                        _workInfoFuture = getDetailInfo();
                        _eventListFuture = getEventList();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: const Color(0xFF3BBAAF), width: 1)),
                      child: Text(
                        S.current.refuse,
                        style: TextStyle(
                            fontSize: 16, color: const Color(0xFF3BBAAF)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(24, 20, 24, 0),
                              backgroundColor: Colors.white,
                              content: ToOtherPage(model),
                            );
                          });
                      // await getDetailInfo();
                      setState(() {
                        _workInfoFuture = getDetailInfo();
                        _eventListFuture = getEventList();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3BBAAF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        S.current.pass,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return Container(height: 0);
    }
  }

  ///获取工单等级
  Widget getworklevel(int? priority) {
    switch (priority) {
      case 1:
        return Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 62, 68, 1),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.immediate_priority,
                  style: TextStyle(color: Colors.white))),
        );
      case 2:
        return Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFFA7800),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.high_priority,
                  style: TextStyle(color: Colors.white))),
        );
      case 3:
        return Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 161, 68, 1),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.medium_priority,
                  style: TextStyle(color: Colors.white))),
        );
      default:
        return Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(205, 178, 64, 1),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.low_priority,
                  style: TextStyle(color: Colors.white))),
        );
    }
  }

  ///获取工单状态
  ///status 状态
  Widget getworkStatus(int? status) {
    switch (status) {
      case 1:
        return Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFFEF3E9),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.processing,
                  style: TextStyle(color: Color(0xFFF68A26)))),
        );
      case 2:
        return Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.return_d,
                  style: TextStyle(color: Color(0xFFA5A5A5)))),
        );
      case 3:
        return Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFE9F2FC),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.receive,
                  style: TextStyle(color: Color(0xFF237DE6)))),
        );
      case 4:
        return Container(
          width: 80,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFFEF0E9),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.confirming,
                  style: TextStyle(color: Color(0xFFF66B26)))),
        );
      case 5:
        return Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFEDFAEB),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.completed,
                  style: TextStyle(color: Color(0xFF4DCF37)))),
        );
      default:
        return Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFFAF5F8),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.discarded,
                  style: TextStyle(color: Color(0xFFCB9CB9)))),
        );
    }
  }

  //检查索引是否在字符串的有效范围内
  String insertAtIndex(String original, String toInsert, int index) {
    // 检查索引是否在字符串的有效范围内
    if (index < 0 || index > original.length) {
      throw RangeError.range(index, 0, original.length, 'Index out of range');
    }
    // 使用切片获取插入点前后的子字符串，并拼接插入的字符串
    return '${original.substring(0, index)}$toInsert${original.substring(index)}';
  }

  Widget _buildRadioButton(int value, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          bjSetter!(() {
            isSpare = value;
          });
        },
        child: SizedBox(
          width: 60,
          height: 30,
          child: Row(
            children: [
              Image(
                  image: isSpare == value
                      ? const AssetImage('assets/singelselete.png')
                      : const AssetImage('assets/singelunselete.png')),
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: 14,
                  color: isSpare == value
                      ? const Color(0xFF3BBAAF)
                      : const Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNWRadioButton(int value, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          nwSetter!(() {
            input = value;
          });
        },
        child: SizedBox(
          width: 60,
          height: 30,
          child: Row(
            children: [
              Image(
                  image: input == value
                      ? const AssetImage('assets/singelselete.png')
                      : const AssetImage('assets/singelunselete.png')),
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: 14,
                  color: input == value
                      ? const Color(0xFF3BBAAF)
                      : const Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _locationAction() async {
    /// 设置android端和ios端定位参数
    /// android 端设置定位参数
    /// ios 端设置定位参数
    // Map iosMap = initIOSOptions().getMap();
    // Map androidMap = initAndroidOptions().getMap();
    // _suc = await _myLocPlugin.prepareLoc(androidMap, iosMap);
    // print('设置定位参数：$iosMap');
  }

  /// 启动定位
  Future<void> _startLocation() async {
    // if (Platform.isIOS) {
    //   _suc = await _myLocPlugin
    //       .singleLocation({'isReGeocode': true, 'isNetworkState': true});
    //   print('开始单次定位：$_suc');
    // } else if (Platform.isAndroid) {
    //   _suc = await _myLocPlugin.startLocation();
    // }
  }

  // /// 设置地图参数
  // BaiduLocationAndroidOption initAndroidOptions() {
  //   BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
  //       coorType: 'bd09ll',
  //       locationMode: BMFLocationMode.hightAccuracy,
  //       isNeedAddress: true,
  //       isNeedAltitude: true,
  //       isNeedLocationPoiList: true,
  //       isNeedNewVersionRgc: true,
  //       isNeedLocationDescribe: true,
  //       openGps: true,
  //       locationPurpose: BMFLocationPurpose.sport,
  //       coordType: BMFLocationCoordType.bd09ll);
  //   return options;
  // }

  // BaiduLocationIOSOption initIOSOptions() {
  //   BaiduLocationIOSOption options = BaiduLocationIOSOption(
  //       coordType: BMFLocationCoordType.bd09ll,
  //       BMKLocationCoordinateType: 'BMKLocationCoordinateTypeBMK09LL',
  //       desiredAccuracy: BMFDesiredAccuracy.best);
  //   return options;
  // }

  // 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      // 权限申请通过
    } else {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("温馨提示!"),
              content: const Text("请开启定位授权进行下一步"),
              actions: [
                CupertinoDialogAction(
                    child: const Text('取消'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoDialogAction(
                    child: const Text('设置'),
                    onPressed: () {
                      openAppSettings();
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
      return;
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
