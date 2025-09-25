import 'package:suncloudm/toolview/imports.dart';

class ElepriceCellB extends StatefulWidget {
  final Map<String, dynamic> data;

  const ElepriceCellB({super.key, required this.data});

  @override
  State<ElepriceCellB> createState() => _ElepriceCellBState();
}

class _ElepriceCellBState extends State<ElepriceCellB> {
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
                  headingRowColor:
                      WidgetStateProperty.all(const Color(0xFFF2F8F9)),
                  headingRowHeight: 40,
                  columnSpacing: 40,
                  dataTextStyle: const TextStyle(fontSize: 12),
                  columns: [
                    DataColumn(
                      label: Text(S.current.time_period_type),
                    ),
                    DataColumn(
                      label: Text(S.current.time_period),
                    ),
                    DataColumn(
                      label: Text(S.current.online_price),
                    ),
                    DataColumn(
                      label: Text(S.current.consumed_price),
                    ),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text(S.current.sharp)),
                        DataCell(Text(getTimeStr(widget.data['sharpList']))),
                        DataCell(Text(
                            (widget.data['sharpGridPrice'] ?? "").toString())),
                        DataCell(
                            Text((widget.data['sharpPrice'] ?? "").toString())),
                      ],
                    ),
                    DataRow(
                      color: WidgetStateProperty.all(const Color(0xFFF2F8F9)),
                      cells: [
                        DataCell(Text(S.current.peak)),
                        DataCell(Text(getTimeStr(widget.data['peakList']))),
                        DataCell(Text(
                            (widget.data['peakGridPrice'] ?? "").toString())),
                        DataCell(
                            Text((widget.data['peakPrice'] ?? "").toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(S.current.flat)),
                        DataCell(Text(getTimeStr(widget.data['flatList']))),
                        DataCell(Text(
                            (widget.data['flatGridPrice'] ?? "").toString())),
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
                            (widget.data['valleyGridPrice'] ?? "").toString())),
                        DataCell(Text(
                            (widget.data['valleyPrice'] ?? "").toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(S.current.deep_valley)),
                        DataCell(
                            Text(getTimeStr(widget.data['deepValleyList']))),
                        DataCell(Text((widget.data['deepValleyGridPrice'] ?? "")
                            .toString())),
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
