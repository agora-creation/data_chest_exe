import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/widgets/custom_cell.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomDataSource extends DataGridSource {
  List<Map<String, String>> items;
  List<Map<String, dynamic>> backups = [];
  int backupsCount = 0;

  CustomDataSource({
    required this.items,
    required this.backups,
    required this.backupsCount,
  }) {
    backups = getDataList(backups, backupsCount);
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    dataGridRows = backups.map<DataGridRow>((e) {
      List<DataGridCell<dynamic>> cells = [];
      cells.add(DataGridCell(columnName: 'id', value: e['id']));
      int itemKey = 1;
      for (Map<String, String> map in items) {
        String columnName = 'column$itemKey';
        cells.add(DataGridCell(
          columnName: columnName,
          value: e[columnName],
        ));
        itemKey++;
      }
      return DataGridRow(cells: cells);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    if ((rowIndex % 2) == 0) {
      backgroundColor = whiteColor;
    }
    List<Widget> cells = [];
    cells.add(CustomCell(row.getCells()[0].value.toString()));
    int itemKey = 1;
    for (Map<String, String> map in items) {
      cells.add(CustomCell(row.getCells()[itemKey].value.toString()));
      itemKey++;
    }
    return DataGridRowAdapter(color: backgroundColor, cells: cells);
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    backups = getDataList(backups, backupsCount);
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    backups = getDataList(backups, backupsCount);
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

  List<Map<String, dynamic>> getDataList(
    List<Map<String, dynamic>> dataList,
    int count,
  ) {
    final int startIndex = dataList.isNotEmpty ? dataList.length : 0;
    final int endIndex = startIndex + count;
    if (dataList.isNotEmpty) {
      for (int i = startIndex; i < endIndex; i++) {
        Map<String, dynamic> addMap = {
          'id': dataList[i]['id'],
        };
        int itemKey = 1;
        for (Map<String, String> map in items) {
          String columnName = 'column$itemKey';
          addMap[columnName] = dataList[i][columnName];
          itemKey++;
        }
        dataList.add(addMap);
      }
    }

    return dataList;
  }
}
