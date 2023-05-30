import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/log.dart';
import 'package:data_chest_exe/screens/log_source.dart';
import 'package:data_chest_exe/services/log.dart';
import 'package:data_chest_exe/widgets/custom_column_label.dart';
import 'package:data_chest_exe/widgets/custom_data_table.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  LogService logService = LogService();
  List<LogModel> logs = [];

  void _clearSearchData() {}

  void _getLogs() async {
    List<LogModel> tmpLogs = await logService.select();
    if (mounted) {
      setState(() {
        logs = tmpLogs;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _clearSearchData();
    _getLogs();
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
                  '削除ログ一覧',
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
                    const Expander(
                      header: Text('検索条件'),
                      content: Column(
                        children: [
                          //検索フォーム
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconButton(
                                iconData: FluentIcons.clear,
                                iconColor: lightBlueColor,
                                labelText: '検索クリア',
                                labelColor: lightBlueColor,
                                backgroundColor: whiteColor,
                              ),
                              SizedBox(width: 8),
                              CustomIconButton(
                                iconData: FluentIcons.search,
                                iconColor: whiteColor,
                                labelText: '検索する',
                                labelColor: whiteColor,
                                backgroundColor: lightBlueColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${logs.length}件表示中',
                        style: const TextStyle(
                          color: greyColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        SizedBox(
                          height: 380,
                          child: CustomDataTable(
                            source: LogSource(logs: logs),
                            columns: [
                              GridColumn(
                                columnName: 'createdAt',
                                label: const CustomColumnLabel('日時'),
                                width: 150,
                              ),
                              GridColumn(
                                columnName: 'content',
                                label: const CustomColumnLabel('内容'),
                              ),
                              GridColumn(
                                columnName: 'memo',
                                label: const CustomColumnLabel('メモ'),
                                width: 250,
                              ),
                            ],
                            autoWidth: false,
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
