import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomDataTable extends StatelessWidget {
  final DataGridSource source;
  final List<GridColumn> columns;

  const CustomDataTable({
    required this.source,
    required this.columns,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: source,
      columns: columns,
      columnWidthMode: ColumnWidthMode.auto,
    );
  }
}
