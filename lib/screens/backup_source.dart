import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/widgets/custom_cell.dart';
import 'package:data_chest_exe/widgets/custom_cell2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BackupSource extends DataGridSource {
  final FormatModel format;
  List<Map<String, dynamic>> backups = [];
  List<DataGridRow> dataGridRows = [];

  BackupSource({
    required this.format,
    required this.backups,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = backups.map<DataGridRow>((backup) {
      List<DataGridCell<dynamic>> cells = generateCells(format, backup);
      return DataGridRow(cells: cells);
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
    cells.add(CustomCell('${row.getCells()[0].value}'));
    int itemKey = 1;
    for (Map<String, String> map in format.items) {
      cells.add(CustomCell('${row.getCells()[itemKey].value}'));
      itemKey++;
    }
    if (format.type != 'csv') {
      cells.add(CustomCell2('${row.getCells()[itemKey].value}'));
    }
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
