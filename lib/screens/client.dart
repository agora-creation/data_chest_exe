import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/client.dart';
import 'package:data_chest_exe/screens/client_source.dart';
import 'package:data_chest_exe/services/client.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
import 'package:data_chest_exe/widgets/custom_column_label.dart';
import 'package:data_chest_exe/widgets/custom_data_table.dart';
import 'package:data_chest_exe/widgets/custom_icon_text_button.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  ClientService clientService = ClientService();
  Map<String, String> searchMap = {};
  List<ClientModel> clients = [];

  void _clearSearchData() {
    searchMap['code'] = '';
    searchMap['name'] = '';
  }

  void _getClients() async {
    List<ClientModel> tmpClients =
        await clientService.select(searchMap: searchMap);
    if (mounted) {
      setState(() {
        clients = tmpClients;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _clearSearchData();
    _getClients();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '取引先設定',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expander(
                      header: const Text('検索条件'),
                      content: Column(
                        children: [
                          GridView(
                            shrinkWrap: true,
                            gridDelegate: kSearchGrid2,
                            children: [
                              InfoLabel(
                                label: '取引先コード',
                                child: CustomTextBox(
                                  controller: TextEditingController(
                                    text: '${searchMap['code']}',
                                  ),
                                  onChanged: (value) {
                                    searchMap['code'] = value;
                                  },
                                ),
                              ),
                              InfoLabel(
                                label: '取引先名',
                                child: CustomTextBox(
                                  controller: TextEditingController(
                                    text: '${searchMap['name']}',
                                  ),
                                  onChanged: (value) {
                                    searchMap['name'] = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconTextButton(
                                iconData: FluentIcons.clear,
                                iconColor: lightBlueColor,
                                labelText: '検索クリア',
                                labelColor: lightBlueColor,
                                backgroundColor: whiteColor,
                                onPressed: () {
                                  _clearSearchData();
                                  _getClients();
                                },
                              ),
                              const SizedBox(width: 8),
                              CustomIconTextButton(
                                iconData: FluentIcons.search,
                                iconColor: whiteColor,
                                labelText: '検索する',
                                labelColor: whiteColor,
                                backgroundColor: lightBlueColor,
                                onPressed: () => _getClients(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${clients.length}件表示中',
                          style: const TextStyle(
                            color: greyColor,
                            fontSize: 12,
                          ),
                        ),
                        CustomIconTextButton(
                          iconData: FluentIcons.download,
                          iconColor: whiteColor,
                          labelText: 'ダウンロード',
                          labelColor: whiteColor,
                          backgroundColor: greenColor,
                          onPressed: () async {
                            List<String> header = ['取引先コード', '取引先名'];
                            List<List<String>> rows = clients.map((e) {
                              return [
                                e.code,
                                e.name,
                              ];
                            }).toList();
                            await downloadCSV(
                              header: header,
                              rows: rows,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        SizedBox(
                          height: 380,
                          child: CustomDataTable(
                            source: ClientSource(
                              context: context,
                              clientService: clientService,
                              clients: clients,
                              getClients: _getClients,
                            ),
                            columns: [
                              GridColumn(
                                columnName: 'code',
                                label: const CustomColumnLabel('取引先コード'),
                              ),
                              GridColumn(
                                columnName: 'name',
                                label: const CustomColumnLabel('取引先名'),
                              ),
                              GridColumn(
                                columnName: 'edit',
                                label: const CustomColumnLabel('編集'),
                                width: 100,
                              ),
                            ],
                            autoWidth: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomIconTextButton(
                          iconData: FluentIcons.add,
                          iconColor: whiteColor,
                          labelText: '取引先を追加する',
                          labelColor: whiteColor,
                          backgroundColor: blueColor,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => ClientAddDialog(
                              clientService: clientService,
                              getClients: _getClients,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientAddDialog extends StatefulWidget {
  final ClientService clientService;
  final Function getClients;

  const ClientAddDialog({
    required this.clientService,
    required this.getClients,
    Key? key,
  }) : super(key: key);

  @override
  State<ClientAddDialog> createState() => _ClientAddDialogState();
}

class _ClientAddDialogState extends State<ClientAddDialog> {
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '取引先を追加する',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '取引先コード',
            child: CustomTextBox(
              controller: code,
              placeholder: '例) 01',
              maxLines: 1,
            ),
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
          labelText: '追加する',
          labelColor: whiteColor,
          backgroundColor: blueColor,
          onPressed: () async {
            String? error = await widget.clientService.insert(
              code: code.text,
              name: name.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.getClients();
            if (!mounted) return;
            showMessage(context, 'BOXを追加しました', true);
            Navigator.pop(context);
            return;
          },
        ),
      ],
    );
  }
}
