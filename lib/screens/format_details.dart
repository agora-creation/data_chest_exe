import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/screens/backup_source.dart';
import 'package:data_chest_exe/services/backup.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/services/log.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
import 'package:data_chest_exe/widgets/custom_data_range_box.dart';
import 'package:data_chest_exe/widgets/custom_data_table.dart';
import 'package:data_chest_exe/widgets/custom_date_box.dart';
import 'package:data_chest_exe/widgets/custom_file_button.dart';
import 'package:data_chest_exe/widgets/custom_file_caution.dart';
import 'package:data_chest_exe/widgets/custom_icon_text_button.dart';
import 'package:data_chest_exe/widgets/custom_loading.dart';
import 'package:data_chest_exe/widgets/custom_number_box.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FormatDetailsScreen extends StatefulWidget {
  final FormatModel format;
  final Function() init;

  const FormatDetailsScreen({
    required this.format,
    required this.init,
    Key? key,
  }) : super(key: key);

  @override
  State<FormatDetailsScreen> createState() => _FormatDetailsScreenState();
}

class _FormatDetailsScreenState extends State<FormatDetailsScreen> {
  FormatService formatService = FormatService();
  BackupService backupService = BackupService();
  List<Map<String, String>> searchData = [];
  List<Map<String, dynamic>> backups = [];
  List<int> checked = [];

  void _clearSearchData() {
    searchData.clear();
    for (Map<String, String> map in widget.format.items) {
      searchData.add({
        'name': '${map['name']}',
        'type': '${map['type']}',
        'value': '',
      });
    }
  }

  void _getBackups() async {
    List<Map<String, dynamic>> tmpBackups = await backupService.select(
      tableName: '${widget.format.type}${widget.format.id}',
      searchData: searchData,
    );
    if (mounted) {
      setState(() {
        backups = tmpBackups;
      });
    }
  }

  void checkOnChange(int value) {
    setState(() {
      if (checked.contains(value)) {
        checked.remove(value);
      } else {
        checked.add(value);
      }
    });
  }

  void allCheck() {
    if (checked.isNotEmpty) {
      checked.clear();
    } else {
      for (Map<String, dynamic> backup in backups) {
        int id = int.parse('${backup['id']}');
        checked.add(id);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _clearSearchData();
    _getBackups();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.format.paneTitle(),
                  style: const TextStyle(fontSize: 18),
                ),
                CustomIconTextButton(
                  iconData: FluentIcons.delete,
                  iconColor: whiteColor,
                  labelText: '${widget.format.paneTitle()}を削除する',
                  labelColor: whiteColor,
                  backgroundColor: redColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => FormatDeleteDialog(
                      backupService: backupService,
                      formatService: formatService,
                      format: widget.format,
                      init: widget.init,
                    ),
                  ),
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
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: searchData.length,
                            gridDelegate: kSearchGrid,
                            itemBuilder: (context, index) {
                              Map<String, String> searchMap = searchData[index];
                              if (searchMap['type'] == 'TEXT') {
                                return InfoLabel(
                                  label: '${searchMap['name']}',
                                  child: CustomTextBox(
                                    controller: TextEditingController(
                                      text: '${searchMap['value']}',
                                    ),
                                    onChanged: (value) {
                                      searchMap['value'] = value;
                                    },
                                  ),
                                );
                              } else if (searchMap['type'] == 'INTEGER') {
                                int? value;
                                if (searchMap['value'] != '') {
                                  value = int.parse('${searchMap['value']}');
                                }
                                return InfoLabel(
                                  label: '${searchMap['name']}',
                                  child: CustomNumberBox(
                                    value: value,
                                    onChanged: (value) {
                                      searchMap['value'] = '$value';
                                    },
                                  ),
                                );
                              } else if (searchMap['type'] == 'DATETIME') {
                                DateTime? startValue;
                                DateTime? endValue;
                                List<DateTime?> values =
                                    stringToDates('${searchMap['value']}');
                                startValue = values.first;
                                endValue = values.last;
                                return InfoLabel(
                                  label: '${searchMap['name']}',
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
                                        searchMap['value'] =
                                            datesToString(selected);
                                      });
                                    },
                                  ),
                                );
                              }
                              return InfoLabel(
                                label: '${searchMap['name']}',
                                child: Container(),
                              );
                            },
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
                                  _getBackups();
                                },
                              ),
                              const SizedBox(width: 8),
                              CustomIconTextButton(
                                iconData: FluentIcons.search,
                                iconColor: whiteColor,
                                labelText: '検索する',
                                labelColor: whiteColor,
                                backgroundColor: lightBlueColor,
                                onPressed: () => _getBackups(),
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
                          '${backups.length}件表示中',
                          style: const TextStyle(
                            color: greyColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          labelText: '全選択',
                          labelColor: blackColor,
                          backgroundColor: grey2Color,
                          onPressed: () => allCheck(),
                        ),
                        CustomIconTextButton(
                          iconData: FluentIcons.download,
                          iconColor: whiteColor,
                          labelText: 'ダウンロード',
                          labelColor: whiteColor,
                          backgroundColor: greenColor,
                          onPressed: () async {
                            List<String> header = [];
                            for (Map<String, String> map
                                in widget.format.items) {
                              header.add('${map['name']}');
                            }
                            if (widget.format.type != 'csv') {
                              header.add('ファイル');
                            }
                            List<List<String>> rows = backups.map((e) {
                              List<String> ret = [];
                              int itemKey = 1;
                              for (Map<String, String> map
                                  in widget.format.items) {
                                String columnName = 'column$itemKey';
                                ret.add('${e[columnName]}');
                                itemKey++;
                              }
                              if (widget.format.type != 'csv') {
                                ret.add('${e['path']}');
                              }
                              return ret;
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
                            source: BackupSource(
                              format: widget.format,
                              backups: backups,
                              checked: checked,
                              checkOnChange: checkOnChange,
                            ),
                            columns: generateColumns(widget.format),
                            autoWidth: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        checked.isNotEmpty
                            ? CustomIconTextButton(
                                iconData: FluentIcons.delete,
                                iconColor: whiteColor,
                                labelText: '選択したデータを削除する',
                                labelColor: whiteColor,
                                backgroundColor: redColor,
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => BackupDeleteDialog(
                                    backupService: backupService,
                                    format: widget.format,
                                    backups: backups,
                                    getBackups: _getBackups,
                                    checked: checked,
                                  ),
                                ),
                              )
                            : Container(),
                        Row(
                          children: [
                            CustomIconTextButton(
                              iconData: FluentIcons.add,
                              iconColor: whiteColor,
                              labelText: 'データを追加する',
                              labelColor: whiteColor,
                              backgroundColor: blueColor,
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => BackupAddDialog(
                                  backupService: backupService,
                                  format: widget.format,
                                  getBackups: _getBackups,
                                ),
                              ),
                            ),
                          ],
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

class FormatDeleteDialog extends StatefulWidget {
  final BackupService backupService;
  final FormatService formatService;
  final FormatModel format;
  final Function init;

  const FormatDeleteDialog({
    required this.backupService,
    required this.formatService,
    required this.format,
    required this.init,
    Key? key,
  }) : super(key: key);

  @override
  State<FormatDeleteDialog> createState() => _FormatDeleteDialogState();
}

class _FormatDeleteDialogState extends State<FormatDeleteDialog> {
  LogService logService = LogService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(
        '${widget.format.paneTitle()}を削除する',
        style: const TextStyle(fontSize: 18),
      ),
      content: isLoading
          ? const CustomLoading('削除中です。しばらくお待ちください。')
          : const Text('削除すると、データも全て削除されます。\nよろしいですか？'),
      actions: isLoading
          ? null
          : [
              CustomButton(
                labelText: 'いいえ',
                labelColor: whiteColor,
                backgroundColor: greyColor,
                onPressed: () => Navigator.pop(context),
              ),
              CustomButton(
                labelText: 'はい',
                labelColor: whiteColor,
                backgroundColor: redColor,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String? error = await widget.formatService.delete(
                    id: widget.format.id ?? 0,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  error = await widget.backupService.deleteAll(
                    tableName: '${widget.format.type}${widget.format.id}',
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  await logService.insertFormat(format: widget.format);
                  widget.init();
                  if (!mounted) return;
                  showMessage(context, 'BOXを削除しました', true);
                  Navigator.pop(context);
                },
              ),
            ],
    );
  }
}

class BackupDeleteDialog extends StatefulWidget {
  final BackupService backupService;
  final FormatModel format;
  final List<Map<String, dynamic>> backups;
  final Function getBackups;
  final List<int> checked;

  const BackupDeleteDialog({
    required this.backupService,
    required this.format,
    required this.backups,
    required this.getBackups,
    required this.checked,
    Key? key,
  }) : super(key: key);

  @override
  State<BackupDeleteDialog> createState() => _BackupDeleteDialogState();
}

class _BackupDeleteDialogState extends State<BackupDeleteDialog> {
  LogService logService = LogService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '選択したデータを削除する',
        style: TextStyle(fontSize: 18),
      ),
      content: isLoading
          ? const CustomLoading('削除中です。しばらくお待ちください。')
          : const Text('選択したデータを削除します。\nよろしいですか？'),
      actions: isLoading
          ? null
          : [
              CustomButton(
                labelText: 'いいえ',
                labelColor: whiteColor,
                backgroundColor: greyColor,
                onPressed: () => Navigator.pop(context),
              ),
              CustomButton(
                labelText: 'はい',
                labelColor: whiteColor,
                backgroundColor: redColor,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String? error;
                  for (int id in widget.checked) {
                    error = await widget.backupService.delete(
                      tableName: '${widget.format.type}${widget.format.id}',
                      id: id,
                    );
                    Map<String, dynamic> backup = widget.backups.singleWhere(
                      (e) => int.parse('${e['id']}') == id,
                    );
                    await logService.insertBackup(
                      format: widget.format,
                      backup: backup,
                    );
                  }
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  widget.getBackups();
                  if (!mounted) return;
                  showMessage(context, '選択したデータを削除しました', true);
                  Navigator.pop(context);
                },
              ),
            ],
    );
  }
}

class BackupAddDialog extends StatefulWidget {
  final BackupService backupService;
  final FormatModel format;
  final Function getBackups;

  const BackupAddDialog({
    required this.backupService,
    required this.format,
    required this.getBackups,
    Key? key,
  }) : super(key: key);

  @override
  State<BackupAddDialog> createState() => _BackupAddDialogState();
}

class _BackupAddDialogState extends State<BackupAddDialog> {
  XFile? file;
  List<Map<String, String>> addData = [];
  bool isLoading = false;

  void _init() {
    for (Map<String, String> map in widget.format.items) {
      addData.add({
        'name': '${map['name']}',
        'type': '${map['type']}',
        'value': '',
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'データを追加する',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: isLoading
            ? const CustomLoading('アップロード中です。しばらくお待ちください。')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFileCaution(format: widget.format),
                  const SizedBox(height: 8),
                  CustomFileButton(
                    file: file,
                    onPressed: () async {
                      XFile? tmpFile = await getFile(widget.format);
                      if (tmpFile != null) {
                        setState(() {
                          file = tmpFile;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  _generateForms(),
                ],
              ),
      ),
      actions: isLoading
          ? null
          : [
              CustomButton(
                labelText: 'いいえ',
                labelColor: whiteColor,
                backgroundColor: greyColor,
                onPressed: () => Navigator.pop(context),
              ),
              CustomButton(
                labelText: 'はい',
                labelColor: whiteColor,
                backgroundColor: blueColor,
                onPressed: () async {
                  if (file == null) return;
                  setState(() {
                    isLoading = true;
                  });
                  await insertBackup(
                    backupService: widget.backupService,
                    format: widget.format,
                    file: file!,
                    addData: addData,
                  );
                  widget.getBackups();
                  if (!mounted) return;
                  showMessage(context, 'データを追加しました', true);
                  Navigator.pop(context);
                },
              ),
            ],
    );
  }

  Widget _generateForms() {
    List<Widget> children = [];
    if (widget.format.type != 'csv') {
      for (Map<String, String> map in addData) {
        if (map['type'] == 'TEXT') {
          children.add(Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InfoLabel(
              label: '${map['name']}',
              child: CustomTextBox(
                controller: TextEditingController(
                  text: '${map['value']}',
                ),
                onChanged: (value) {
                  map['value'] = value;
                },
              ),
            ),
          ));
        } else if (map['type'] == 'INTEGER') {
          children.add(Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InfoLabel(
              label: '${map['name']}',
              child: CustomNumberBox(
                value: int.parse('${map['value']}'),
                onChanged: (value) {
                  map['value'] = '$value';
                },
              ),
            ),
          ));
        } else if (map['type'] == 'DATETIME') {
          DateTime? value;
          if (map['value'] != '') {
            value = DateTime.parse('${map['value']}');
          }
          children.add(Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InfoLabel(
              label: '${map['name']}',
              child: CustomDateBox(
                value: value,
                onTap: () async {
                  var selected = await showDataPickerDialog(context, value);
                  if (selected != null) {
                    setState(() {
                      map['value'] = dateText('yyyy-MM-dd', selected);
                    });
                  }
                },
              ),
            ),
          ));
        }
      }
    }
    return Column(children: children);
  }
}
