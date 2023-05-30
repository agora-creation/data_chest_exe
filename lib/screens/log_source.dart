import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/log.dart';
import 'package:data_chest_exe/services/log.dart';
import 'package:data_chest_exe/widgets/custom_cell.dart';
import 'package:data_chest_exe/widgets/custom_form_cell.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LogSource extends DataGridSource {
  final LogService logService;
  List<LogModel> logs = [];
  List<DataGridRow> dataGridRows = [];

  LogSource({
    required this.logService,
    required this.logs,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = logs.map<DataGridRow>((log) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: '${log.id}',
        ),
        DataGridCell(
          columnName: 'createdAt',
          value: dateText('yyyy-MM-dd HH:mm', log.createdAt),
        ),
        DataGridCell(
          columnName: 'content',
          value: log.content,
        ),
        DataGridCell(
          columnName: 'memo',
          value: log.memo,
        ),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    if ((rowIndex % 2) == 0) {
      backgroundColor = whiteColor;
    }
    List<Widget> cells = [];
    cells.add(CustomCell('${row.getCells()[1].value}'));
    cells.add(CustomCell('${row.getCells()[2].value}'));
    cells.add(CustomFormCell(
      value: '${row.getCells()[3].value}',
      onChanged: (value) async {
        int id = int.parse('${row.getCells()[0].value}');
        await logService.update(id: id, memo: value);
      },
    ));
    return DataGridRowAdapter(color: backgroundColor, cells: cells);
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    Widget? widget;
    Widget buildCell(
      String value,
      EdgeInsets padding,
      Alignment alignment,
    ) {
      return Container(
        padding: padding,
        alignment: alignment,
        child: Text(value, softWrap: false),
      );
    }

    widget = buildCell(
      summaryValue,
      const EdgeInsets.all(4),
      Alignment.centerLeft,
    );
    return widget;
  }

  void updateDataSource() {
    notifyListeners();
  }
}
