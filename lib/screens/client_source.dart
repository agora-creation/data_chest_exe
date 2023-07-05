import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/client.dart';
import 'package:data_chest_exe/services/client.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
import 'package:data_chest_exe/widgets/custom_button_cell.dart';
import 'package:data_chest_exe/widgets/custom_cell.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ClientSource extends DataGridSource {
  final BuildContext context;
  final ClientService clientService;
  List<ClientModel> clients = [];
  final Function() getClients;
  List<DataGridRow> dataGridRows = [];

  ClientSource({
    required this.context,
    required this.clientService,
    required this.clients,
    required this.getClients,
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
    ClientModel client = clients.singleWhere(
      (e) => e.id == int.parse(row.getCells()[0].value),
    );
    cells.add(CustomCell('${row.getCells()[1].value}'));
    cells.add(CustomCell('${row.getCells()[2].value}'));
    cells.add(CustomButtonCell(
      labelText: '編集',
      labelColor: whiteColor,
      backgroundColor: blueColor,
      onPressed: () => showDialog(
        context: context,
        builder: (context) => ClientModDialog(
          clientService: clientService,
          client: client,
          getClients: getClients,
        ),
      ),
    ));
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

class ClientModDialog extends StatefulWidget {
  final ClientService clientService;
  final ClientModel client;
  final Function getClients;

  const ClientModDialog({
    required this.clientService,
    required this.client,
    required this.getClients,
    Key? key,
  }) : super(key: key);

  @override
  State<ClientModDialog> createState() => _ClientModDialogState();
}

class _ClientModDialogState extends State<ClientModDialog> {
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.client.name;
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '取引先を編集する',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '取引先コード',
            child: Text(widget.client.code),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '取引先名',
            child: CustomTextBox(
              controller: name,
              placeholder: '例) ABC商事',
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: '削除する',
          labelColor: whiteColor,
          backgroundColor: redColor,
          onPressed: () async {
            String? error = await widget.clientService.delete(
              id: widget.client.id ?? 0,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.getClients();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
        CustomButton(
          labelText: '保存する',
          labelColor: whiteColor,
          backgroundColor: blueColor,
          onPressed: () async {
            String? error = await widget.clientService.update(
              id: widget.client.id ?? 0,
              name: name.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.getClients();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
