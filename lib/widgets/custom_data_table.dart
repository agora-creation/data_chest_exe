import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;

class CustomDataTable extends StatelessWidget {
  const CustomDataTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: m.PaginatedDataTable(
        rowsPerPage: 4,
        columns: [
          m.DataColumn(label: Text('Header A')),
          m.DataColumn(label: Text('Header B')),
          m.DataColumn(label: Text('Header C')),
          m.DataColumn(label: Text('Header D')),
        ],
        source: _DataSource(context),
      ),
    );
  }
}

class _Row {
  _Row(
    this.valueA,
    this.valueB,
    this.valueC,
    this.valueD,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final int valueD;

  bool selected = false;
}

class _DataSource extends m.DataTableSource {
  _DataSource(this.context) {
    _rows = <_Row>[
      _Row('Cell A1', 'CellB1', 'CellC1', 1),
      _Row('Cell A2', 'CellB2', 'CellC2', 2),
      _Row('Cell A3', 'CellB3', 'CellC3', 3),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 5),
      _Row('Cell A4', 'CellB4', 'CellC4', 5),
      _Row('Cell A4', 'CellB4', 'CellC4', 5),
      _Row('Cell A4', 'CellB4', 'CellC4', 5),
      _Row('Cell A4', 'CellB4', 'CellC4', 5),
      _Row('Cell A4', 'CellB4', 'CellC4', 5),
    ];
  }

  final BuildContext context;
  List<_Row>? _rows;

  int _selectedCount = 0;

  @override
  m.DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows!.length) return null;
    final row = _rows![index];
    return m.DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
          bool v = value ?? false;
          _selectedCount += v ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = v;
          notifyListeners();
        }
      },
      cells: [
        m.DataCell(Text(row.valueA)),
        m.DataCell(Text(row.valueB)),
        m.DataCell(Text(row.valueC)),
        m.DataCell(Text(row.valueD.toString())),
      ],
    );
  }

  @override
  int get rowCount => _rows!.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
