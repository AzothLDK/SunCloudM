import 'package:suncloudm/toolview/imports.dart';

class SettlementdetailPage extends StatefulWidget {
  final String settleId;

  const SettlementdetailPage({super.key, required this.settleId});

  @override
  State<SettlementdetailPage> createState() => _SettlementdetailPageState();
}

class _SettlementdetailPageState extends State<SettlementdetailPage> {
  Map<String, dynamic> settleData = {};

  Future<Map<String, dynamic>> getSettleDetail() async {
    Map<String, dynamic> params = {};
    params['id'] = widget.settleId;
    var data = await StrategyDao.getsettleDetail(params: params);
    print(params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return settleData = data['data'];
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
                    Text(settleData["title"] ?? "--"),
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
                          const Row(
                            children: [
                              Text(
                                '收益',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 3),
                              Text(
                                '（不含税总收益）',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF8693AB)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF2F8F9),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: getColum(settleData['list']),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '收益计算',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
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
                                      "储能月度含税总收益(元)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["includingTaxIncomeCn"]}',
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
                                      "光伏消纳月度含税总收益(元)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${settleData["includingTaxIncomeGfXn"]}',
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
                                      "光伏上网月度含税总收益(元)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["includingTaxIncomeGfSw"]}',
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
                                      "储能侧客户方收益分享部分占比%(元)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["shareIncomeCn"]}',
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
                                      "光伏侧客户方消纳享受折扣0%(元)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["shareIncomeGfXn"]}',
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
                                      "光伏侧客户方上网享受折扣0%(元)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["shareIncomeGfSw"]}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "储能侧企业月度结算金额(元)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["shareIncomeMonthCn"]}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  '*=储能侧企业月度总收益 - 客户方节能收益分享部分',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0x998693AB),
                                      fontWeight: FontWeight.w100),
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "结算电费(人民币大写)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${settleData["shareIncomeMonthCapitalizationCn"]}',
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      textAlign: TextAlign.right,
                                    )),
                                  ],
                                ),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "光伏侧企业月度结算金额(元)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["shareIncomeMonthGf"]}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  '*=光伏侧企业(消纳+上网)月度总收益 - 客户方(消纳+上网)节能收益分享部分',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0x998693AB),
                                      fontWeight: FontWeight.w100),
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "结算电费(人民币大写)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${settleData["shareIncomeMonthCapitalizationGf"]}',
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      textAlign: TextAlign.right,
                                    )),
                                  ],
                                ),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "微网侧企业月度结算金额(元)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      '${settleData["shareIncomeMonthWw"]}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  '*=储能侧企业月度结算金额 + 光伏侧企业月度结算金额',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0x998693AB),
                                      fontWeight: FontWeight.w100),
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "结算电费(人民币大写)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xE88693AB)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${settleData["shareIncomeMonthCapitalizationWw"]}',
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      textAlign: TextAlign.right,
                                    )),
                                  ],
                                ),
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
                                    '1、请于结算单出具后10个工作日内及时激交本期电费，避免产生滞纳金。\n2、企业月度结算金额= 企业储能月度结算收益+ 企业光伏月度结算收益。\n3、计算到户上网价格按照合同约定计算。\n4、本项目消纳电量按照合同业主享受折扣0%计算。\n5、本项目上网电量按照合同业主享受折扣0%计算。\n6、计算到户不含税价格按照湖南省国网2024月10日代理购电工商业用户电价的公告各时段电价扣除13%税率合同约定计算。\n7、本项自按照合同能源管理税率6%计算。',
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
                  '${e.value["incomeType"]}',
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
