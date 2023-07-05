import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/client.dart';
import 'package:data_chest_exe/services/client.dart';
import 'package:data_chest_exe/widgets/custom_cell.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ClientSource extends DataGridSource {
  final ClientService clientService;
  List<ClientModel> clients = [];
  List<DataGridRow> dataGridRows = [];

  ClientSource({
    required this.clientService,
    required this.clients,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = clients.map<DataGridRow>((client) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: '${client.id}',
        ),
        DataGridCell(
          columnName: 'code',
          value: client.code,
        ),
        DataGridCell(
          columnName: 'name',
          value: client.name,
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
