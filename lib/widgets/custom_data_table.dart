import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomDataTable extends StatelessWidget {
  final DataGridSource source;
  final List<GridColumn> columns;
  final bool autoWidth;

  const CustomDataTable({
    required this.source,
    required this.columns,
    required this.autoWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: source,
      onQueryRowHeight: (details) {
        return details.getIntrinsicRowHeight(details.rowIndex);
      },
      columns: columns,
      columnWidthMode:
          autoWidth == true ? ColumnWidthMode.auto : ColumnWidthMode.fill,
    );
  }
}
