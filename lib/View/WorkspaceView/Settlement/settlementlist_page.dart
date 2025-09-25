import 'package:date_format/date_format.dart' as date_format;
import 'package:month_year_picker/month_year_picker.dart';
import 'package:suncloudm/toolview/imports.dart';

class SettlementlistPage extends StatefulWidget {
  const SettlementlistPage({super.key});

  @override
  State<SettlementlistPage> createState() => _SettlementlistPageState();
}

class _SettlementlistPageState extends State<SettlementlistPage> {
  String? seleteDate;
  List _pageData = [];
  final TextEditingController searchController =
      TextEditingController(); // 新增控制器
  String seleteId = '';
  String seleteName = S.current.please_select;
  List companyList = [];
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String? singleId = GlobalStorage.getSingleId();

  Future<Map<String, dynamic>> _getDataList() async {
    Map<String, dynamic> params = {};
    params['settleMonth'] = seleteDate;
    if (singleId != null) {
      params['itemId'] = singleId;
    } else if (seleteId != "") {
      params['itemId'] = seleteId;
    }
    print(params);
    var data = await StrategyDao.getsettleList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return _pageData = data['data']['records'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (isOperator == true && singleId == null) {
      String? jsonStr = GlobalStorage.getCompanyList();
      companyList = jsonDecode(jsonStr!);
      seleteId = companyList[0]["id"].toString();
      seleteName = companyList[0]["itemName"].toString();
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
          title: Text(
            S.current.settlement,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0, // 移除AppBar的阴影
          centerTitle: true,
        ),
        body: Column(
          children: [
            Visibility(
              visible: (isOperator == true && singleId == null) ? true : false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: SearchField(
                  controller: searchController,
                  maxSuggestionsInViewPort: 5,
                  itemHeight: 60,
                  hint: seleteName,
                  searchInputDecoration: SearchInputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  marginColor: Colors.grey.shade300,
                  suggestions: companyList
                      .map((e) => SearchFieldListItem(e['itemName'].toString(),
                          item: e))
                      .toList(),
                  focusNode: focusNode,
                  onTapOutside: (e) {
                    focusNode.unfocus();
                  },
                  onSuggestionTap: (SearchFieldListItem x) {
                    seleteId = x.item!['id'].toString();
                    seleteName = x.item['itemName'].toString();
                    searchController.text = seleteName;
                    setState(() {});
                  },
                ),
              ),
            ),

            // Visibility(
            //   visible: (isOperator == true && singleId == null)
            //       ? true
            //       : false,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            //     child: SizedBox(
            //       height: 40,
            //       child: DropdownButtonFormField2<String>(
            //           isExpanded: true,
            //           decoration: InputDecoration(
            //             filled: true,
            //             fillColor: Colors.white,
            //             contentPadding:
            //                 const EdgeInsets.symmetric(vertical: 10),
            //             border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(20),
            //               borderSide: BorderSide.none,
            //             ),
            //             // Add more decoration..
            //           ),
            //           hint: Text(
            //             seleteName,
            //             style: const TextStyle(fontSize: 15),
            //           ),
            //           items: companyList
            //               .map((item) => DropdownMenuItem<String>(
            //                     value: item['id'].toString(),
            //                     child: Text(
            //                       item['itemName'],
            //                       style: const TextStyle(
            //                         fontSize: 15,
            //                       ),
            //                     ),
            //                   ))
            //               .toList(),
            //           validator: (value) {
            //             return null;
            //           },
            //           onChanged: (value) {
            //             debugPrint(value);
            //             seleteId = value!;
            //             setState(() {});
            //           },
            //           onSaved: (value) {},
            //           buttonStyleData: const ButtonStyleData(
            //             padding: EdgeInsets.only(right: 8),
            //           ),
            //           iconStyleData: const IconStyleData(
            //               icon: Icon(
            //                 Icons.keyboard_arrow_down,
            //                 color: Colors.black45,
            //               ),
            //               iconSize: 24),
            //           dropdownStyleData: DropdownStyleData(
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(15)),
            //           ),
            //           menuItemStyleData: const MenuItemStyleData(
            //               padding: EdgeInsets.symmetric(horizontal: 16))),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () async {
                    DateTime? d = await showMonthYearPicker(
                      context: context,
                      initialMonthYearPickerMode: MonthYearPickerMode.month,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2019),
                      lastDate: DateTime(2030),
                      locale: savedLanguage == 'zh'
                          ? const Locale('zh')
                          : const Locale('en'),
                    );
                    if (d == null) {
                      return;
                    }
                    seleteDate = date_format.formatDate(
                        d!, [date_format.yyyy, '-', date_format.mm]);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 40),
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        seleteDate ?? S.current.please_select_settlement_month,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black45),
                      ),
                      const SizedBox(width: 15),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black45,
                        size: 14,
                      )
                    ],
                  )),
            ),
            FutureBuilder(
                future: _getDataList(),
                builder: (context, snapshot) {
                  return Expanded(
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: RefreshIndicator(
                        onRefresh: refreshData,
                        child: ListView.builder(
                            itemCount: _pageData.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                  onTap: () => navigate(i),
                                  child: _settlecardView(_pageData[i]));
                            }),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  void navigate(int? id) async {
    Map settleMap = _pageData[id!];
    if (settleMap['itemType'] == 1) {
      Routes.instance!.navigateTo(
          context, Routes.settlementdetail, settleMap["id"].toString());
    } else if (settleMap['itemType'] == 2) {
      Routes.instance!.navigateTo(
          context, Routes.cnSettlementdetail, settleMap["id"].toString());
    }
  }

  Widget _settlecardView(Map data) {
    String imageUrl =
        "http://60.204.238.185:30507" + (data['logoUrl'] ?? ""); //地址
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    imageUrl,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(data['itemName'] ?? ''),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_right)
                        ],
                      ),
                      Text(
                        data['companyName'] ?? '',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF8693AB)),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xFFF2F8F9),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.settlement_method,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF8693AB)),
                      ),
                      Text(
                        '${data['startSettlementType'] == 1 ? '线上' : '线下'}-${data['endSettlementType'] == 1 ? '线上' : '线下'}',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.settlement_month,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF8693AB)),
                      ),
                      Text(
                        data['settleMonth'] ?? "",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.settlement_time,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF8693AB)),
                      ),
                      Text(
                        (data['beginDate'] ?? "") +
                            '-' +
                            (data['endDate'] ?? ""),
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
