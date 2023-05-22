import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/widgets/custom_column_label.dart';
import 'package:data_chest_exe/widgets/custom_data_source.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomDataTable extends StatefulWidget {
  final List<Map<String, String>> items;
  final List<Map<String, dynamic>> backups;

  const CustomDataTable({
    required this.items,
    required this.backups,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  List<GridColumn> columns = [];
  int _rowsPerPage = kRowsPerPages.first;
  late CustomDataSource customDataSource;

  void _init() {
    columns.add(GridColumn(
      columnName: 'id',
      label: const CustomColumnLabel('ID'),
    ));
    int itemKey = 1;
    for (Map<String, String> map in widget.items) {
      String columnName = 'column$itemKey';
      columns.add(
        GridColumn(
          columnName: columnName,
          label: CustomColumnLabel('${map['name']}'),
        ),
      );
      itemKey++;
    }
    customDataSource = CustomDataSource(
      items: widget.items,
      backups: widget.backups,
      backupsCount: _rowsPerPage,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.backups);
    if (widget.backups.isEmpty) {
      return Center(child: Text('なにもない'));
    }
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: SfDataGrid(
            source: customDataSource,
            rowsPerPage: _rowsPerPage,
            allowSorting: true,
            columnWidthMode: ColumnWidthMode.none,
            columns: columns,
          ),
        ),
        SizedBox(
          height: 60,
          child: SfDataPagerTheme(
            data: SfDataPagerThemeData(
              brightness: Brightness.light,
              selectedItemColor: blueColor,
            ),
            child: SfDataPager(
              delegate: customDataSource,
              availableRowsPerPage: kRowsPerPages,
              pageCount: customDataSource.backups.length / _rowsPerPage,
              onRowsPerPageChanged: (int? rowsPerPage) {
                setState(() {
                  _rowsPerPage = rowsPerPage!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
