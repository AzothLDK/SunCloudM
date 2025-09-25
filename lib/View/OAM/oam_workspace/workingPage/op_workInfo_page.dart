import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/asset_widget_builder.dart';
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/getOrder_page.dart';
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/preview_networkfile_view.dart';
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/return_page.dart';
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/seleteMedia_view.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/toolview/screentool.dart';
import 'package:suncloudm/work_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suncloudm/generated/l10n.dart';

class OpWorkinfoPage extends StatefulWidget {
  String workNumber;

  OpWorkinfoPage(this.workNumber, {super.key});

  @override
  State<OpWorkinfoPage> createState() => _OpWorkinfoPageState();
}

class _OpWorkinfoPageState extends State<OpWorkinfoPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dealController = TextEditingController();
  final TextEditingController _spareController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  late WorkEntity model = WorkEntity();

  Future<dynamic>? _workInfoFuture;
  Future<dynamic>? _eventListFuture;

  late final TabController mController;

  Map? correlationAlarm;
  bool _suc = false;

  List<File> _selectFeedbackImageFiles = [];

  ///是否使用配件
  int isSpare = 0;
  String _spareText = "";

  ///是否有内外部投入
  int input = 1;
  List eventList = [];
  String _userInput = "";
  String _addressText = S.current.failed_to_obtain_address;

//是否抄送
  int ifpush = 1;

  StateSetter? bjSetter;
  StateSetter? nwSetter;

  @override
  void initState() {
    super.initState();
    mController = TabController(initialIndex: 0, length: 2, vsync: this);
    _getLocation();
    _workInfoFuture = getDetailInfo();
    _eventListFuture = getEventList();
  }

  @override
  void dispose() {
    mController.dispose();
    super.dispose();
  }

  Future<WorkEntity> getDetailInfo() async {
    Map<String, dynamic> paramdata = {'workNumber': widget.workNumber};
    var data = await WorkDao.getdetailsByWorkNumber(params: paramdata);
    debugPrint(paramdata.toString());
    log(data.toString());
    if (data["code"] == 200) {
      model = WorkEntity.fromJson(data['data']);
      if (model.status == 3 && model.isTake == 1) {
        mController.index = 1;
      }
      return model;
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
      throw Exception('Failed to load data');
    }
  }

  Future<void> _getLocation() async {
    // 请求位置权限
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        // 将坐标转换为中文地址
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          String address = '${placemark.street}';
          setState(() {
            _addressText = address;
          });
        }
      } catch (e) {
        setState(() {
          _addressText = S.current.failed_to_obtain_address;
        });
      }
    } else {
      setState(() {
        _addressText = S.current.unauthorized_to_obtain_address;
      });
    }
  }

  Future<List> updataFile() async {
    List fileUrlList = [];
    if (_selectFeedbackImageFiles.isNotEmpty) {
      for (File v in _selectFeedbackImageFiles) {
        // print('现在大小是${v.lengthSync()}');
        // print('现在数量是${_selectFeedbackImageFiles.length}');
        // print('现在数量是${v.path}');
        Map<String, dynamic> map = Map();
        map["file"] = await MultipartFile.fromFile(v.path);

        ///通过FormData
        FormData formData = FormData.fromMap(map);
        var data = await CommonDao.fileUpload(formData: formData);
        debugPrint(data.toString());
        if (data["code"] == 200) {
          Map fileMap = {};
          fileMap['originalImage'] = data['data'];
          bool isMp4 = (data['data'].toString()).endsWith('.mp4');
          fileMap['type'] = isMp4 ? 2 : 1;
          fileUrlList.add(fileMap);
        } else {
          SVProgressHUD.dismiss();
          SVProgressHUD.showError(status: S.current.upload_failed);
        }
      }
    }
    return Future.value(fileUrlList);
  }

  _submitEvent(Map<String, dynamic> paramdata) async {
    debugPrint(paramdata.toString());
    var data = await WorkDao.saveWorkEvent(params: paramdata);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      SVProgressHUD.showSuccess(status: S.current.submit_success);
      // Navigator.of(context).pop();
      setState(() {
        _workInfoFuture = getDetailInfo();
        _eventListFuture = getEventList();
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            S.current.work_order_details,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
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
                    ;
                  } else {
                    if ((model.status == 3 ||
                            model.status == 4 ||
                            model.status == 5) &&
                        model.isTake == 1) {
                      return Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: model.status == 3 || model.status == 1
                                    ? 62
                                    : 0),
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
                                      Tab(text: S.current.work_order_info),
                                      Tab(text: S.current.process_content),
                                    ],
                                    onTap: (index) {
                                      setState(() {
                                        mController.index = index;
                                      });
                                    },
                                    controller: mController,
                                    backgroundColor: const Color(0xFF24C18F),
                                    unselectedBackgroundColor: Colors.white,
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    unselectedLabelStyle: const TextStyle(
                                        color: Color(0xFF8693AB)),
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
                                  bottom: model.status == 3 || model.status == 1
                                      ? 62
                                      : 0),
                              child: workInfoView()),
                          _bottomButton(),
                        ],
                      );
                    }
                  }
                }),
          ),
        ));
  }

  _makeCall() async {
    String phoneNumber = 'tel:${model.stationResponsiblePhone}';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
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
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                    S.current.OM_team,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
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
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      model.alarmContent ?? "--",
                      style: const TextStyle(fontSize: 14),
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 1,
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
                ;
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
                                        const SizedBox(height: 5)
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

  ///获取处理页面
  ///
  Widget getDealStatus(int? status, BuildContext context) {
    switch (status) {
      case 3:
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
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
                  Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        S.current.cause,
                      ),
                    ],
                  ),
                  TextField(
                    style: const TextStyle(fontSize: 14.0),
                    controller: _reasonController,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 8),
                      border: InputBorder.none,
                      hintText: S.current.please_input,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        S.current.solution,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  TextField(
                    style: const TextStyle(fontSize: 14.0),
                    controller: _dealController,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 8),
                      border: InputBorder.none,
                      hintText: S.current.please_input,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    bjSetter = setState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.is_use_spare,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            _buildRadioButton(1, S.current.yes),
                            _buildRadioButton(0, S.current.no)
                          ],
                        ),
                        Visibility(
                          visible: isSpare == 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('备件名称',
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                              TextField(
                                style: const TextStyle(fontSize: 14.0),
                                controller: _spareController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: S.current.please_input,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: -10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    nwSetter = setState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.internal_external_investment,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            _buildNWRadioButton(1, S.current.internal),
                            _buildNWRadioButton(2, S.current.external)
                          ],
                        ),
                        Visibility(
                          visible: input == 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('成本',
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                              TextField(
                                style: const TextStyle(fontSize: 14.0),
                                controller: _inputController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: S.current.please_input,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: -10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        S.current.processing_photos_videos,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  KeyedSubtree(
                    key: const ValueKey('UniqueKey'),
                    child: Builder(
                      builder: (BuildContext context) {
                        return Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: SelectImageVideo(
                                selectBack: (selectedFiles) async {
                              _selectFeedbackImageFiles = selectedFiles;
                            }));
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    S.current.location,
                    style: TextStyle(fontSize: 14),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _addressText,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 10),
                      IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: () async {
                          requestPermission();
                          _getLocation();
                        },
                        tooltip: S.current.reposition,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: ifpush == 1,
                        onChanged: (value) {
                          setState(() {
                            ifpush = value == true ? 1 : 0;
                          });
                          // 实现选择逻辑
                        },
                      ),
                      Text(S.current.cc_this_w_o_to_supervisor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
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
                      model.isSpare == 1 ? S.current.yes : S.current.no,
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
        return Container(
          height: 0,
        );
    }
  }

  ///底部按钮
  Widget _bottomButton() {
    switch (model.status) {
      case 1:
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
                      children: [Icon(Icons.phone), Text(S.current.platform)],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Column(
                      children: [Icon(Icons.people), Text(S.current.applicant)],
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
                              content: ReturnPage(model),
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
                        S.current.return_d,
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
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(24, 20, 24, 0),
                              backgroundColor: Colors.white,
                              content: GetOrderPage(model),
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
                        color: const Color(0xFF3BBAAF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        S.current.accept,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 2:
        return InkWell(
          onTap: () {},
          child: Container(height: 1),
        );
      case 3:
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
                      children: [Icon(Icons.phone), Text(S.current.platform)],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Column(
                      children: [Icon(Icons.people), Text(S.current.applicant)],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);
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
                        S.current.cancel,
                        style: TextStyle(
                            fontSize: 16, color: const Color(0xFF3BBAAF)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      // int isconfirm = 0;
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text(S.current.confirm_submit),
                            // content: const Text('请选择是否需要平台进行审批'), // 添加提示内容
                            actions: <Widget>[
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                child: Text(S.current.cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // isconfirm = 1;
                                  // _submitWorkInfo();
                                  // 这里可以添加需要审批的逻辑
                                },
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                child: Text(S.current.submit,
                                    style: TextStyle(
                                        color: CupertinoColors.systemGrey)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // isconfirm = 0;
                                  _submitWorkInfo();
                                  // 这里可以添加不需要审批的逻辑
                                },
                              ),
                            ],
                          );
                        },
                      );
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
                        S.current.submit,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 4:
        return InkWell(
          onTap: () {},
          child: Container(
            height: 0,
          ),
        );
      default:
        return InkWell(
          onTap: () {},
          child: Container(
            height: 0,
          ),
        );
    }
  }

  void _submitWorkInfo() async {
    if (_reasonController.text.isEmpty) {
      SVProgressHUD.showInfo(status: S.current.please_input_cause);
      return;
    }
    if (_dealController.text.isEmpty) {
      SVProgressHUD.showInfo(status: S.current.please_input_solution);
      return;
    }
    if (_selectFeedbackImageFiles.isEmpty) {
      SVProgressHUD.showInfo(status: S.current.please_upload_photos_videos);
      return;
    }
    requestPermission();
    if (_addressText.isEmpty) {
      SVProgressHUD.show(status: S.current.getting_address_please_wait);
    } else {
      SVProgressHUD.show(status: S.current.uploading_file_please_wait);
      updataFile().then((s) async {
        Map<String, dynamic> saveparam = {};
        print('上传的图片地址是$s');
        saveparam['pictureUrl'] = s;
        saveparam['input'] = input;
        saveparam['inputDetails'] = _inputController.text;
        saveparam['reason'] = _reasonController.text;
        saveparam['programme'] = _dealController.text;
        saveparam['isSpare'] = isSpare;
        saveparam['workNumber'] = model.workNumber;
        saveparam['id'] = model.id;
        // saveparam['isconfirm'] = isconfirm;
        print('修改参数是$saveparam');
        var data = await WorkDao.updateWorkOrder(params: saveparam);
        debugPrint(data.toString());
        if (data["code"] == 200) {
          SVProgressHUD.dismiss();
          SVProgressHUD.showSuccess(status: S.current.submit_success);
          Map<String, dynamic> paramdata = {};
          paramdata['nowStatus'] = model.status;
          paramdata['workNumber'] = model.workNumber;
          paramdata['createId'] = model.createId;
          paramdata['address'] = _addressText;
          paramdata['isSend'] = ifpush;
          _submitEvent(paramdata);
        } else {
          SVProgressHUD.dismiss();
        }
      });
    }
    setState(() {
      // _workInfoFuture = getDetailInfo();
      // _eventListFuture = getEventList();
    });
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
              child: Text(S.current.pending,
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
              child: Text(S.current.returned,
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
              child: Text(S.current.processing,
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

  ///检查索引是否在字符串的有效范围内
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
          width: 80,
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
