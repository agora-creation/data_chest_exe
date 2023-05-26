import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/screens/backup_source.dart';
import 'package:data_chest_exe/services/backup.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
import 'package:data_chest_exe/widgets/custom_date_box.dart';
import 'package:data_chest_exe/widgets/custom_file_button.dart';
import 'package:data_chest_exe/widgets/custom_file_caution.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:data_chest_exe/widgets/custom_number_box.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FormatDetailsScreen extends StatefulWidget {
  final FormatModel format;
  final Function() resetIndex;

  const FormatDetailsScreen({
    required this.format,
    required this.resetIndex,
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
                CustomIconButton(
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
                      resetIndex: widget.resetIndex,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.format.remarks,
              style: const TextStyle(color: greyColor),
            ),
            const SizedBox(height: 4),
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
                              return InfoLabel(
                                label: '${searchData[index]['name']}',
                                child: CustomTextBox(
                                  controller: TextEditingController(
                                    text: '${searchData[index]['value']}',
                                  ),
                                  onChanged: (value) {
                                    searchData[index]['value'] = value;
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconButton(
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
                              CustomIconButton(
                                iconData: FluentIcons.search,
                                iconColor: whiteColor,
                                labelText: '検索する',
                                labelColor: whiteColor,
                                backgroundColor: lightBlueColor,
                                onPressed: () {
                                  _getBackups();
                                },
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
                        '${backups.length}件表示中',
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
                          child: SfDataGrid(
                            source: BackupSource(
                              format: widget.format,
                              backups: backups,
                            ),
                            columns: generateColumns(widget.format),
                            columnWidthMode: ColumnWidthMode.auto,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  iconData: FluentIcons.delete,
                  iconColor: redColor,
                  labelText: 'データを削除する',
                  labelColor: redColor,
                  backgroundColor: whiteColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => BackupDeleteDialog(
                      backupService: backupService,
                      format: widget.format,
                      getBackups: _getBackups,
                    ),
                  ),
                ),
                CustomIconButton(
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
      ),
    );
  }
}

class FormatDeleteDialog extends StatefulWidget {
  final BackupService backupService;
  final FormatService formatService;
  final FormatModel format;
  final Function resetIndex;

  const FormatDeleteDialog({
    required this.backupService,
    required this.formatService,
    required this.format,
    required this.resetIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<FormatDeleteDialog> createState() => _FormatDeleteDialogState();
}

class _FormatDeleteDialogState extends State<FormatDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(
        '${widget.format.paneTitle()}を削除する',
        style: const TextStyle(fontSize: 18),
      ),
      content: const Text('削除すると、データも全て削除されます。\nよろしいですか？'),
      actions: [
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
            String? error = await widget.formatService.delete(
              id: widget.format.id ?? 0,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            error = await widget.backupService.delete(
              tableName: '${widget.format.type}${widget.format.id}',
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.resetIndex();
            if (!mounted) return;
            showMessage(context, '入れ物を削除しました', true);
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
  final Function getBackups;

  const BackupDeleteDialog({
    required this.backupService,
    required this.format,
    required this.getBackups,
    Key? key,
  }) : super(key: key);

  @override
  State<BackupDeleteDialog> createState() => _BackupDeleteDialogState();
}

class _BackupDeleteDialogState extends State<BackupDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'データを削除する',
        style: TextStyle(fontSize: 18),
      ),
      content: const Text('データを全て削除します。\nよろしいですか？'),
      actions: [
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
            String? error = await widget.backupService.delete(
              tableName: '${widget.format.type}${widget.format.id}',
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.getBackups();
            if (!mounted) return;
            showMessage(context, 'データを削除しました', true);
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
      content: Column(
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
      actions: [
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
            await insertBackup(
              backupService: widget.backupService,
              format: widget.format,
              file: file!,
              addData: addData,
            );
            widget.getBackups();
            if (!mounted) return;
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
