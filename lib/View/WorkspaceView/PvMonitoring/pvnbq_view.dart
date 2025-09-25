import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:suncloudm/dao/config.dart';
import 'package:suncloudm/dao/storage.dart';
import 'package:suncloudm/routes/Routes.dart';
import '../../../dao/daoX.dart';
import 'package:suncloudm/generated/l10n.dart';

class NBQListPage extends StatefulWidget {
  final String itemId;
  const NBQListPage(this.itemId, {super.key});

  @override
  State<NBQListPage> createState() => _NBQListPageState();
}

class _NBQListPageState extends State<NBQListPage> {
  List nbqListData = [];
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String? singleId = GlobalStorage.getSingleId();

  Future<List> getNbqList() async {
    Map<String, dynamic> params = {};
    if (isOperator == true && singleId == null) {
      params['stationId'] = widget.itemId;
    }
    if (isOperator == true && singleId != null) {
      params['stationId'] = singleId;
    }
    var data = await IndexDao.getNbqList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return nbqListData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNbqList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: nbqListData.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                        onTap: () {
                          Routes.instance!.navigateTo(
                              context,
                              Routes.pvnbqDetailView,
                              jsonEncode(nbqListData[i]));
                        },
                        child: _cardView(nbqListData[i]));
                  }),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text(S.current.page_development_in_process,
                    style: TextStyle(fontSize: 20)));
          } else {
            return const SizedBox(
                height: 280, child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  _cardView(Map data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      height: 120,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                width: 50,
                height: 50,
                image: AssetImage('assets/nbq.png'),
                fit: BoxFit.cover,
              ),
              Text(
                S.current.online,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.green),
              ),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${data["deviceName"]}",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(S.current.serial_number + ':',
                        style: TextStyle(
                            color: Color.fromRGBO(123, 125, 138, 1),
                            fontSize: 14)),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text("${data["deviceCode"] ?? '--'}",
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(S.current.update_time + ':',
                        style: TextStyle(
                            color: Color.fromRGBO(123, 125, 138, 1),
                            fontSize: 14)),
                    const SizedBox(width: 5),
                    Text("${data["updateTime"]}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
