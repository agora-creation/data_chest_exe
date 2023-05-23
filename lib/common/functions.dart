import 'package:data_chest_exe/widgets/custom_column_label.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

List<GridColumn> generateColumns(List<Map<String, String>> items) {
  List<GridColumn> ret = [];
  ret.add(GridColumn(
    columnName: 'id',
    label: const CustomColumnLabel('ID'),
  ));
  int itemKey = 1;
  for (Map<String, String> map in items) {
    String columnName = 'column$itemKey';
    ret.add(
      GridColumn(
        columnName: columnName,
        label: CustomColumnLabel('${map['name']}'),
      ),
    );
    itemKey++;
  }
  return ret;
}

List<DataGridCell<dynamic>> generateCells(
    List<Map<String, String>> items, Map<String, dynamic> backup) {
  List<DataGridCell<dynamic>> ret = [];
  ret.add(DataGridCell(columnName: 'id', value: backup['id']));
  int itemKey = 1;
  for (Map<String, String> map in items) {
    String columnName = 'column$itemKey';
    ret.add(DataGridCell(
      columnName: columnName,
      value: backup[columnName],
    ));
    itemKey++;
  }
  return ret;
}
