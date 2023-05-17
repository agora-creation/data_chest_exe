import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;

class CustomDataTable extends StatelessWidget {
  const CustomDataTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PaginatedDataTable2(
        onSelectAll: (value) {},
        sortColumnIndex: 1,
        sortAscending: true,
        columns: [
          m.DataColumn(label: const Text('id')),
          m.DataColumn(label: const Text('name')),
          m.DataColumn(label: const Text('gender')),
          m.DataColumn(label: const Text('作成日')),
        ],
        source: SampleDataSource(),
      ),
    );
  }
}

class SampleDataSource extends m.DataTableSource {
  @override
  m.DataRow getRow(int index) {
    /// 1行文のデータ
    return m.DataRow(
      cells: <m.DataCell>[
        m.DataCell(
          Text('articleList[index].id'),
        ),
        m.DataCell(
          Text('articleList[index].title'),
        ),
        m.DataCell(
          Text(
            'DateFormat.yMMMMd().add_jms().format(articleList[index].createdAt)',
          ),
        ),
        m.DataCell(
          Text(
            'DateFormat.yMMMMd().add_jms().format(articleList[index].updatedAt)',
          ),
        ),
      ],
      // メモ「value」がbool値なのが、人によっては扱いづらいかも。
      // chekboxの活性非活性でのみ利用すべきなのかも。
      onSelectChanged: (value) {
        // context使えなかった。
        // showDialog<void>(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: const Text('選択した行のデータ'),
        //       content: Text(articleList[index].toString()),
        //     );
        //   },
        // );
      },
    );
  }

  @override
  int get rowCount => 10; // 全行数
  @override
  bool get isRowCountApproximate => false; // 行数は常に正確な値かどうか(不明な場合はfalseにしておく)
  @override
  int get selectedRowCount => 0; // 選択された行数(選択を使用しない場合は0で問題ない)
}
