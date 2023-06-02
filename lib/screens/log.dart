import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/log.dart';
import 'package:data_chest_exe/screens/log_source.dart';
import 'package:data_chest_exe/services/log.dart';
import 'package:data_chest_exe/widgets/custom_column_label.dart';
import 'package:data_chest_exe/widgets/custom_data_range_box.dart';
import 'package:data_chest_exe/widgets/custom_data_table.dart';
import 'package:data_chest_exe/widgets/custom_icon_text_button.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  LogService logService = LogService();
  Map<String, String> searchMap = {};
  List<LogModel> logs = [];

  void _clearSearchData() {
    searchMap['createdAt'] = '';
    searchMap['content'] = '';
  }

  void _getLogs() async {
    List<LogModel> tmpLogs = await logService.select(searchMap: searchMap);
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
    DateTime? startValue;
    DateTime? endValue;
    List<DateTime?> values = stringToDates('${searchMap['createdAt']}');
    startValue = values.first;
    endValue = values.last;

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
                    Expander(
                      header: const Text('検索条件'),
                      content: Column(
                        children: [
                          GridView(
                            shrinkWrap: true,
                            gridDelegate: kSearchGrid2,
                            children: [
                              InfoLabel(
                                label: '日時',
                                child: CustomDateRangeBox(
                                  startValue: startValue,
                                  endValue: endValue,
                                  onTap: () async {
                                    var selected =
                                        await showDataRangePickerDialog(
                                      context,
                                      startValue,
                                      endValue,
                                    );
                                    setState(() {
                                      searchMap['createdAt'] =
                                          datesToString(selected);
                                    });
                                  },
                                ),
                              ),
                              InfoLabel(
                                label: '内容',
                                child: CustomTextBox(
                                  controller: TextEditingController(
                                    text: '${searchMap['content']}',
                                  ),
                                  onChanged: (value) {
                                    searchMap['content'] = value;
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
                                  _getLogs();
                                },
                              ),
                              const SizedBox(width: 8),
                              CustomIconTextButton(
                                iconData: FluentIcons.search,
                                iconColor: whiteColor,
                                labelText: '検索する',
                                labelColor: whiteColor,
                                backgroundColor: lightBlueColor,
                                onPressed: () => _getLogs(),
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
                          '${logs.length}件表示中',
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
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        SizedBox(
                          height: 380,
                          child: CustomDataTable(
                            source: LogSource(
                              logService: logService,
                              logs: logs,
                            ),
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
