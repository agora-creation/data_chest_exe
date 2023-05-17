import 'package:data_chest_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomItemsTable extends StatelessWidget {
  final List<TableRow> rows;

  const CustomItemsTable({
    required this.rows,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TableRow> children = [
      TableRow(
        decoration: const BoxDecoration(color: grey2Color),
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            child: const Text('項目名'),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            child: const Text('項目タイプ'),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            child: const Text('削除'),
          ),
        ],
      ),
    ];
    for (TableRow row in rows) {
      children.add(row);
    }
    return Table(
      border: TableBorder.all(color: greyColor),
      columnWidths: const {
        0: FlexColumnWidth(5),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(0.5),
      },
      children: children,
    );
  }
}
