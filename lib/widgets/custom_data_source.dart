import 'package:data_chest_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomDataSource extends DataGridSource {
  CustomDataSource({
    required this.items,
    required this.dataList,
    required this.dataCount,
  }) {
    dataList = getDataList(dataList, dataCount ?? 100);
    buildDataGridRows();
  }

  List<Map<String, String>> items;

  int? dataCount;
  List<Map<String, dynamic>> dataList = [];
  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = dataList.map<DataGridRow>((e) {
      List<DataGridCell<dynamic>> cells = [];
      cells.add(DataGridCell(columnName: 'id', value: e['id']));
      int columnKey = 1;
      for (Map<String, String> map in items) {
        cells.add(DataGridCell(
          columnName: 'column$columnKey',
          value: e['column$columnKey'],
        ));
        columnKey++;
      }
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
    cells.add(Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        row.getCells()[0].value.toString(),
        softWrap: false,
      ),
    ));
    int columnKey = 1;
    for (Map<String, String> map in items) {
      cells.add(Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          row.getCells()[columnKey].value.toString(),
          softWrap: false,
        ),
      ));
      columnKey++;
    }
    return DataGridRowAdapter(
      color: backgroundColor,
      cells: cells,
    );
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    dataList = getDataList(dataList, 15);
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    dataList = getDataList(dataList, 15);
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
        child: Text(
          value,
          softWrap: false,
        ),
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
    for (int i = startIndex; i < endIndex; i++) {
      Map<String, dynamic> addMap = {'id': '0000'};
      int columnKey = 1;
      for (Map<String, String> map in items) {
        addMap['column$columnKey'] = '11111111111';
        columnKey++;
      }
      dataList.add(addMap);
    }
    return dataList;
  }
}
