import 'package:suncloudm/View/WorkspaceView/ProfitAnalysis/profitanalysis_cn.dart';
import 'package:suncloudm/View/WorkspaceView/ProfitAnalysis/profitanalysis_ww.dart';
import 'package:suncloudm/toolview/imports.dart';

class ProfitAnalysisPage extends StatefulWidget {
  const ProfitAnalysisPage({super.key});

  @override
  State<ProfitAnalysisPage> createState() => _ProfitAnalysisPageState();
}

class _ProfitAnalysisPageState extends State<ProfitAnalysisPage> {
  final TextEditingController searchController =
      TextEditingController(); // 新增控制器
  String seleteId = '';
  String seleteName = S.current.please_select;
  Map seleteCompany = {};
  List companyList = [];
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String? singleId = GlobalStorage.getSingleId();

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (isOperator == true && singleId == null) {
      String? jsonStr = GlobalStorage.getCompanyList();
      companyList = jsonDecode(jsonStr!);
      seleteCompany = companyList[0];
      seleteId = companyList[0]["id"].toString();
      seleteName = companyList[0]["itemName"].toString();
    }
  }

  Future<void> refreshData() async {
    setState(() {});
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
          title: Text(
            S.current.revenue_analysis,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0, // 移除AppBar的阴影
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: refreshData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Visibility(
                  visible:
                      (isOperator == true && singleId == null) ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SearchField(
                      controller: searchController,
                      maxSuggestionsInViewPort: 5,
                      itemHeight: 60,
                      hint: seleteName,
                      searchInputDecoration: SearchInputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      marginColor: Colors.grey.shade300,
                      suggestions: companyList
                          .map((e) => SearchFieldListItem(
                              e['itemName'].toString(),
                              item: e['id'].toString()))
                          .toList(),
                      focusNode: focusNode,
                      onTapOutside: (e) {
                        focusNode.unfocus();
                      },
                      onSuggestionTap: (SearchFieldListItem x) {
                        debugPrint(x.searchKey);
                        debugPrint(x.item);
                        seleteId = x.item;
                        for (var item in companyList) {
                          if (item['id'].toString() == x.item) {
                            seleteCompany = item;
                            seleteName = item["itemName"].toString();
                            searchController.text = seleteName;
                          }
                        }
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
                //     padding: const EdgeInsets.symmetric(horizontal: 15),
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
                //             for (var item in companyList) {
                //               if (item['id'].toString() == value) {
                //                 seleteCompany = item;
                //                 seleteName = item["itemName"].toString();
                //               }
                //             }
                //             setState(() {});
                //           },
                //           onSaved: (value) {},
                //           buttonStyleData: const ButtonStyleData(
                //             padding: EdgeInsets.only(right: 8),
                //           ),
                //           iconStyleData: const IconStyleData(
                //               icon: Icon(
                //                 Icons.arrow_drop_down,
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
                showDifferentView(),
                // (seleteCompany['itemType'] == 1 && isOperator == true)
                //     ? ProfitanalysisWw(companyinfo: seleteCompany)
                //     : ProfitanalysisCn(companyinfo: seleteCompany),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showDifferentView() {
    if (isOperator == true && singleId == null) {
      if (seleteCompany['itemType'] == 1) {
        return ProfitanalysisWw(companyinfo: seleteCompany);
      } else {
        return ProfitanalysisCn(companyinfo: seleteCompany);
      }
    } else {
      if (userInfo['itemType'] == 1 || loginType == 1) {
        return const ProfitanalysisWw();
      } else {
        return const ProfitanalysisCn();
      }
    }
  }
}
