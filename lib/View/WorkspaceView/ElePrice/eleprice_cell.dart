import 'package:suncloudm/utils/screentool.dart';
import 'package:suncloudm/toolview/imports.dart';

class ElepriceCell extends StatefulWidget {
  final Map<String, dynamic> data;

  const ElepriceCell({super.key, required this.data});

  @override
  State<ElepriceCell> createState() => _ElepriceCellState();
}

class _ElepriceCellState extends State<ElepriceCell> {
  bool v = true;

  @override
  Widget build(BuildContext context) {
    getTimeStr(List timelist) {
      String str = "";
      for (Map map in timelist) {
        if (str == "") {
          str = '$str${map['startTime']}-${map['endTime']}';
        } else {
          str = '$str\n${map['startTime']}-${map['endTime']}';
        }
      }
      return str;
    }

    return InkWell(
      onTap: () {
        v = !v;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_drop_down_outlined,
                  color: Color.fromRGBO(6, 193, 143, 1),
                ),
                Text(
                  '${widget.data['month']}${widget.data['stationName']}',
                  style: const TextStyle(),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Visibility(
              visible: v,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: TextStyle(fontSize: 12),
                  headingRowColor: WidgetStateProperty.all(Color(0xFFF2F8F9)),
                  headingRowHeight: 40,
                  columnSpacing: ScreenDimensions.screenWidth(context) / 7,
                  dataTextStyle: const TextStyle(fontSize: 12),
                  columns: [
                    DataColumn(
                      label: Text(S.current.time_period_type),
                    ),
                    DataColumn(
                      label: Text(S.current.time_period),
                    ),
                    DataColumn(
                      label: Text(S.current.ele_price),
                    ),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text(S.current.sharp)),
                        DataCell(Text(getTimeStr(widget.data['sharpList']))),
                        DataCell(
                            Text((widget.data['sharpPrice'] ?? "").toString())),
                      ],
                    ),
                    DataRow(
                      color: WidgetStateProperty.all(const Color(0xFFF2F8F9)),
                      cells: [
                        DataCell(Text(S.current.peak)),
                        DataCell(Text(getTimeStr(widget.data['peakList']))),
                        DataCell(
                            Text((widget.data['peakPrice'] ?? "").toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(S.current.flat)),
                        DataCell(Text(getTimeStr(widget.data['flatList']))),
                        DataCell(
                            Text((widget.data['flatPrice'] ?? "").toString())),
                      ],
                    ),
                    DataRow(
                      color: WidgetStateProperty.all(const Color(0xFFF2F8F9)),
                      cells: [
                        DataCell(Text(S.current.valley)),
                        DataCell(Text(getTimeStr(widget.data['valleyList']))),
                        DataCell(Text(
                            (widget.data['valleyPrice'] ?? "").toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(S.current.deep_valley)),
                        DataCell(Text(getTimeStr(widget.data['valleyList']))),
                        DataCell(Text(
                            (widget.data['valleyPrice'] ?? "").toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(S.current.deep_valley)),
                        DataCell(
                            Text(getTimeStr(widget.data['deepValleyList']))),
                        DataCell(Text(
                            (widget.data['deepValleyPrice'] ?? "").toString())),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
