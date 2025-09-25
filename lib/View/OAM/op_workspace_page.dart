import 'package:flutter/material.dart';
import 'package:suncloudm/gen_a/A.dart';
import 'package:suncloudm/routes/Routes.dart';
import 'package:suncloudm/toolview/custom_view.dart';
import 'package:suncloudm/generated/l10n.dart';

class OpWorkspacePage extends StatefulWidget {
  const OpWorkspacePage({super.key});

  @override
  State<OpWorkspacePage> createState() => _OpWorkspacePageState();
}

class _OpWorkspacePageState extends State<OpWorkspacePage> {
  List operationList = [
    S.current.work_order_management,
    S.current.inspection_task,
    S.current.shift_plan,
  ];
  List operationImageList = [
    A.assets_gdglicon,
    A.assets_xjrwicon,
    A.assets_pbjhicon,
  ];

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
            automaticallyImplyLeading: false,
            title: Text(
              S.current.workbench,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            // 移除AppBar的阴影
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 150,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 18,
                        child: VerticalDivider(
                          thickness: 3,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        S.current.maintenance,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // 直接传入完整数据列表，自动生成多行
                  creatCellCard(
                    operationList, // 使用已定义的operationList
                    operationImageList, // 使用已定义的operationImageList
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  creatCellCard(List titleList, List imageList) {
    var imageBtns = <Widget>[];
    double screenWidth = MediaQuery.of(context).size.width;
    // 计算单个按钮宽度（屏幕宽度 - 左右边距10*2 - 水平间距10*3） / 4列
    double btnWidth = (screenWidth - 20 - 30 - 20) / 4;

    for (int i = 0; i < imageList.length; i++) {
      imageBtns.add(
        ImageButton(
          imageList[i],
          width: btnWidth, // 固定宽度保证每行4个
          text: titleList[i],
          iconSize: 35,
          func: navigateTo,
          textStyle: const TextStyle(fontSize: 15, color: Color(0xff656565)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 10, // 水平间距
        runSpacing: 20, // 垂直间距
        children: imageBtns, // 直接使用按钮列表
      ),
    );
  }

  void navigateTo(String lab) {
    if (lab == S.current.work_order_management) {
      Routes.instance!.navigateTo(context, Routes.oplworklist);
    } else if (lab == S.current.data_analysis) {
      Routes.instance!.navigateTo(context, Routes.oplDataAnalysis);
    } else if (lab == S.current.inspection_task) {
      // Routes.instance!.navigateTo(context, Routes.oplInspectiontask);
    } else if (lab == S.current.shift_plan) {
      Routes.instance!.navigateTo(context, Routes.oplWorkschedule);
    } else if (lab == S.current.event_record) {
      // Routes.instance!.navigateTo(context, Routes.opleventRecord);
    }
  }
}
