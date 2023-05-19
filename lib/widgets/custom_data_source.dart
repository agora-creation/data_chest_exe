import 'package:data_chest_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomDataSource extends DataGridSource {
  CustomDataSource({
    required this.dataList,
    required this.dataCount,
  }) {
    dataList = getDataList(dataList, dataCount ?? 100);
    buildDataGridRows();
  }

  int? dataCount;
  List<Map<String, dynamic>> dataList = [];
  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = dataList.map<DataGridRow>((e) {
      return DataGridRow(
        cells: [
          DataGridCell(columnName: 'id', value: e['id']),
          DataGridCell(columnName: 'column1', value: e['column1']),
        ],
      );
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
    return DataGridRowAdapter(
      color: backgroundColor,
      cells: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            row.getCells()[0].value.toString(),
            softWrap: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            row.getCells()[1].value.toString(),
            softWrap: false,
          ),
        ),
      ],
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
      dataList.add({
        'id': '0000',
        'column1': '1111111',
      });
    }
    return dataList;
  }
}
