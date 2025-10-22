import 'package:flutter/material.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/utils/screentool.dart';

class SettlementdetailCnPage extends StatefulWidget {
  final String settleId;
  const SettlementdetailCnPage({super.key, required this.settleId});

  @override
  State<SettlementdetailCnPage> createState() => _SettlementdetailCnPageState();
}

class _SettlementdetailCnPageState extends State<SettlementdetailCnPage> {
  Map<String, dynamic> settleData = {};

  List overviewList = [];

  Future<Map<String, dynamic>> getSettleDetail() async {
    Map<String, dynamic> params = {};
    params['id'] = widget.settleId;
    var data = await StrategyDao.getCnSettleDetail(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        settleData = data['data']['electricityBill'];
        overviewList = data['data']['overviewList'];
        return settleData;
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: const Text(
            '电费结算清单',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0, // 移除AppBar的阴影
          centerTitle: true,
        ),
        body: FutureBuilder<Object>(
            future: getSettleDetail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    Text(settleData["contractName"] ?? "--"),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            settleData["customerName"] ?? "--",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Image(
                                  image:
                                      AssetImage('assets/location_green.png')),
                              const SizedBox(width: 3),
                              Text(
                                settleData['customerAddress'],
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF8693AB)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF2F8F9),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "计费日期",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["chargingDate"]}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "联系人",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["contactPerson"]}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "合同名称",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${settleData["contractName"]}',
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      textAlign: TextAlign.right,
                                    )),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "合同编号",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["contractNumber"]}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "上次抄表日期",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["lastDate"]}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "本次抄表日期",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["thisDate"]}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "户号",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["accountNumber"]}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),
                          // Container(
                          //   padding: const EdgeInsets.all(10),
                          //   decoration: BoxDecoration(
                          //       color: const Color(0xFFF2F8F9),
                          //       borderRadius: BorderRadius.circular(15)),
                          //   child: Column(
                          //     children: getColum(settleData['list']),
                          //   ),
                          // ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingTextStyle: const TextStyle(fontSize: 12),
                              headingRowColor: WidgetStateProperty.all(
                                  const Color(0xFFF2F8F9)),
                              headingRowHeight: 40,
                              columnSpacing:
                                  ScreenDimensions.screenWidth(context) / 14,
                              dataTextStyle: TextStyle(fontSize: 12),
                              columns: [
                                DataColumn(
                                  label: Text('表计类理'),
                                ),
                                DataColumn(
                                  label: Text('时段)'),
                                ),
                                DataColumn(
                                  label: Text('本月电量'),
                                ),
                                DataColumn(
                                  label: Text('到户不含税价格(元)'),
                                ),
                                DataColumn(
                                  label: Text('本月结算金额'),
                                ),
                              ],
                              rows: _getSTData(overviewList),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF2F8F9),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "储能电站月度不含税总收益(元)",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["excludingTaxIncome"]}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "储能电站月度含税总收益(元)",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${settleData["includingTaxIncome"]}',
                                      style: const TextStyle(fontSize: 14),
                                      maxLines: 2,
                                      textAlign: TextAlign.right,
                                    )),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "客户方收益分享部分占比16%(元)",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["shareIncome"]}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "*=储能电站月度总收益-客户方节能收益分享部分",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Color.fromRGBO(134, 147, 171, 0.5)),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "储能电站月度结算金额(元)",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["shareIncomeMonth"]}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "结算电费(人民币大写)",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["shareIncomeMonthCapitalization"]}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF2F8F9),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "备注",
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF8693AB)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                    '1、请于结算单出具后10个工作日内及时缴交本期电费，避免产生滞纳金。\n2、月度总收益反向有功金额(尖峰段+峰段+平段+段+深)-正向有金额(尖峰段+峰段+平段+段深谷段)。\n3、计算到户不含税价格按照江苏国网 2024年10月 代理购电工商业用户电价的公告各时段电价扣除13%税率计算。\n4、本项目按照合同能源管理税率6%计算。',
                                    style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "节能服务单位(收款方)",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF8693AB)),
                        ),
                        Text(
                          '${settleData["payee"]}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "日期",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF8693AB)),
                        ),
                        Text(
                          '${settleData["date"]}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              } else {
                return const SizedBox(
                    height: 280,
                    child: Center(child: CircularProgressIndicator()));
              }
            }),
      ),
    );
  }

  _getSTData(List? datelist) {
    if (datelist == null) {
      return [
        const DataRow(
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        )
      ];
    } else {
      return datelist
          .asMap()
          .entries
          .map((e) => DataRow(
                color: (e.key % 2 == 0)
                    ? WidgetStateProperty.all(const Color(0xFFFFFFFF))
                    : WidgetStateProperty.all(const Color(0xFFF2F8F9)),
                cells: [
                  DataCell(Text(e.value["meterType"] ?? "")),
                  DataCell(Text((e.value["timeFrame"] ?? "").toString())),
                  DataCell(Text(
                      (e.value["currentElectricQuantity"] ?? "").toString())),
                  DataCell(Text((e.value["price"] ?? "").toString())),
                  DataCell(Text((e.value["settleAmount"] ?? "").toString())),
                ],
              ))
          .toList();
    }
  }

  getColum(List datalist) {
    return datalist
        .asMap()
        .entries
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${e.value["incomeType"]}1231231',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8693AB)),
                ),
                Text(
                  '${e.value["taxIncome"]}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}
