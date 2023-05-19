import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/widgets/custom_data_source.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomDataTable extends StatefulWidget {
  final List<Map<String, String>> items;

  const CustomDataTable({
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  List<GridColumn> columns = [];
  final List<int> rowsList = [10, 20, 30, 40, 50];
  int _rowsPerPage = 10;
  late CustomDataSource customDataSource;
  List<Map<String, dynamic>> dataList = [];

  void _init() {
    columns.add(GridColumn(
      columnName: 'id',
      label: const Padding(
        padding: EdgeInsets.all(4),
        child: Text(
          'ID',
          softWrap: false,
        ),
      ),
    ));
    int columnKey = 1;
    for (Map<String, String> map in widget.items) {
      columns.add(
        GridColumn(
          columnName: 'column$columnKey',
          label: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              '${map['name']}',
              softWrap: false,
            ),
          ),
        ),
      );
      columnKey++;
    }
    for (int i = 0; i < 100; i++) {
      Map<String, dynamic> addMap = {'id': '0000'};
      int columnKey = 1;
      for (Map<String, String> map in widget.items) {
        addMap['column$columnKey'] = '11111111111';
      }
      dataList.add(addMap);
    }
    customDataSource = CustomDataSource(dataList: dataList, dataCount: 300);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
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
              availableRowsPerPage: rowsList,
              pageCount: customDataSource.dataList.length / _rowsPerPage,
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
