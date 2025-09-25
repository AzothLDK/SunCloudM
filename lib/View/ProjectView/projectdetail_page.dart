import 'package:suncloudm/toolview/imports.dart';

class ProjectdetailPage extends StatefulWidget {
  final Function() onGoBackToFirst;
  final Map projectInfo;

  const ProjectdetailPage(
      {super.key, required this.projectInfo, required this.onGoBackToFirst});

  @override
  State<ProjectdetailPage> createState() => _ProjectdetailPageState();
}

class _ProjectdetailPageState extends State<ProjectdetailPage> {
  @override
  Widget build(BuildContext context) {
    Map projectInfo = widget.projectInfo;
    Map pvInfo = {};
    Map cnInfo = {};

    if (widget.projectInfo['pvInfo'] != null) {
      pvInfo = widget.projectInfo['pvInfo'];
    }
    if (widget.projectInfo['cnInfo'] != null) {
      cnInfo = widget.projectInfo['cnInfo'];
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          '项目信息',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        // 移除AppBar的阴影
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        SizedBox(
                          height: 18,
                          child: VerticalDivider(
                            thickness: 3,
                            color: Colors.green,
                          ),
                        ),
                        Text('项目基础信息',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "项目名称",
                                    style: TextStyle(color: Color(0xFF8693AB)),
                                  ),
                                  Text(projectInfo['itemName'] ?? '--')
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "项目类型",
                                    style: TextStyle(color: Color(0xFF8693AB)),
                                  ),
                                  Text(projectInfo["itemType"] == 1
                                      ? "微电网"
                                      : projectInfo["itemType"] == 2
                                          ? "储能"
                                          : projectInfo["itemType"] == 3
                                              ? "光伏"
                                              : "充电站"),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "企业名称",
                                    style: TextStyle(color: Color(0xFF8693AB)),
                                  ),
                                  Text('${projectInfo['companyName'] ?? '--'}')
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "项目状态",
                                    style: TextStyle(color: Color(0xFF8693AB)),
                                  ),
                                  Text(
                                    projectInfo["statusMsg"] ?? "--",
                                    style: TextStyle(
                                        color: projectInfo["statusMsg"] ==
                                                S.current.normal
                                            ? Color(0xFF42D77D)
                                            : projectInfo["statusMsg"] ==
                                                    S.current.offline
                                                ? Colors.grey
                                                : Colors.red),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "并网时间",
                                    style: TextStyle(color: Color(0xFF8693AB)),
                                  ),
                                  Expanded(
                                      child: Text(
                                    projectInfo['useTime'] ?? '--',
                                    textAlign: TextAlign.end,
                                  ))
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "地址",
                                    style: TextStyle(color: Color(0xFF8693AB)),
                                  ),
                                  Expanded(
                                      child: Text(
                                    projectInfo['detailAddress'] ?? '--',
                                    textAlign: TextAlign.end,
                                  ))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            pvInfo.isNotEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              SizedBox(
                                height: 18,
                                child: VerticalDivider(
                                  thickness: 3,
                                  color: Colors.green,
                                ),
                              ),
                              Text('光伏信息',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "站点名称",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(pvInfo['stationName'] ?? '--')
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "站点状态",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(
                                          pvInfo["statusMsg"] ?? "--",
                                          style: TextStyle(
                                              color: pvInfo["statusMsg"] ==
                                                      S.current.normal
                                                  ? Color(0xFF42D77D)
                                                  : pvInfo["statusMsg"] ==
                                                          S.current.offline
                                                      ? Colors.grey
                                                      : Colors.red),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "装机容量(kWp)",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text('${pvInfo['volume']}')
                                      ],
                                    ),
                                    // const SizedBox(height: 6),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     const Text(
                                    //       "接入方式",
                                    //       style: TextStyle(
                                    //           color: Color(0xFF8693AB)),
                                    //     ),
                                    //     Text(pvInfo['typeName'] ?? "--")
                                    //   ],
                                    // ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "接入设备",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Expanded(
                                            child: Text(
                                          pvInfo['accessDeviceNames'] ?? '--',
                                          textAlign: TextAlign.end,
                                        ))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            cnInfo.isNotEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              SizedBox(
                                height: 18,
                                child: VerticalDivider(
                                  thickness: 3,
                                  color: Colors.green,
                                ),
                              ),
                              Text('储能信息',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "站点名称",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(cnInfo['stationName'] ?? '--')
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "站点状态",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(
                                          cnInfo["statusMsg"] ?? "--",
                                          style: TextStyle(
                                              color: cnInfo["statusMsg"] ==
                                                      S.current.normal
                                                  ? Color(0xFF42D77D)
                                                  : cnInfo["statusMsg"] ==
                                                          S.current.offline
                                                      ? Colors.grey
                                                      : Colors.red),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "额定容量(kW)",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text('${cnInfo['ratePower']}')
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "装机容量(kWh)",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        // Text(pvInfo['volume']
                                        //     .toString())
                                        Text('${cnInfo['volume']}')
                                      ],
                                    ),
                                    // const SizedBox(height: 6),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       "接入方式",
                                    //       style: const TextStyle(
                                    //           color: Color(0xFF8693AB)),
                                    //     ),
                                    //     Text(cnInfo['typeName'] ?? '--')
                                    //   ],
                                    // ),
                                    SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "接入设备",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Expanded(
                                            child: Text(
                                          cnInfo['accessDeviceNames'] ?? '--',
                                          textAlign: TextAlign.end,
                                        ))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Visibility(
              visible: (projectInfo['itemType'] != 4) ? true : false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    GlobalStorage.saveSingleId(
                        projectInfo['itemId'].toString());
                    loginType = projectInfo['itemType'];
                    widget.onGoBackToFirst();
                    Navigator.pop(context, () {
                      // 触发上一页的方法
                    });
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('单站视图'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
