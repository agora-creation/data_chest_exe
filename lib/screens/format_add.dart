import 'package:data_chest_exe/common/info_bar.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/services/backup.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/widgets/custom_icon.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:data_chest_exe/widgets/custom_items_combo_box.dart';
import 'package:data_chest_exe/widgets/custom_items_table.dart';
import 'package:data_chest_exe/widgets/custom_radio_button.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
import 'package:data_chest_exe/widgets/custom_type_note.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FormatAddScreen extends StatefulWidget {
  final Function() resetIndex;

  const FormatAddScreen({
    required this.resetIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<FormatAddScreen> createState() => _FormatAddScreenState();
}

class _FormatAddScreenState extends State<FormatAddScreen> {
  BackupService backupService = BackupService();
  FormatService formatService = FormatService();
  TextEditingController title = TextEditingController();
  TextEditingController remarks = TextEditingController();
  String type = kFormatTypeList.first.key;
  List<Map<String, String>> items = [];
  List<TableRow> itemRows = [];

  void _itemAdd() {
    items.add({'name': '', 'type': 'text'});
    _rebuildItemRows();
  }

  void _itemRemove(Map map) {
    items.remove(map);
    _rebuildItemRows();
  }

  void _rebuildItems() {
    items.clear();
    switch (type) {
      case 'csv':
        items.add({'name': '会員番号', 'type': 'TEXT'});
        items.add({'name': '姓', 'type': 'TEXT'});
        items.add({'name': '名', 'type': 'TEXT'});
        items.add({'name': '郵便番号', 'type': 'TEXT'});
        items.add({'name': '住所', 'type': 'TEXT'});
        items.add({'name': '電話番号', 'type': 'TEXT'});
        break;
      case 'pdf':
        items.add({'name': '発行日', 'type': 'DATETIME'});
        items.add({'name': '番号', 'type': 'TEXT'});
        items.add({'name': '送り先', 'type': 'TEXT'});
        items.add({'name': '金額', 'type': 'TEXT'});
        break;
      case 'img':
        items.add({'name': '発行日', 'type': 'DATETIME'});
        items.add({'name': '番号', 'type': 'TEXT'});
        items.add({'name': '送り先', 'type': 'TEXT'});
        items.add({'name': '金額', 'type': 'TEXT'});
        break;
    }
    _rebuildItemRows();
  }

  void _rebuildItemRows() {
    setState(() {
      itemRows.clear();
      for (Map map in items) {
        itemRows.add(TableRow(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(4),
              child: CustomTextBox(
                controller: TextEditingController(text: map['name']),
                onChanged: (value) {
                  map['name'] = value;
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(4),
              child: CustomItemsComboBox(
                value: map['type'],
                onChanged: (value) {
                  map['type'] = value;
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(4),
              child: CustomIcon(
                iconData: FluentIcons.clear,
                iconColor: whiteColor,
                backgroundColor: redColor,
                onPressed: () => _itemRemove(map),
              ),
            ),
          ],
        ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _rebuildItems();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('フォーマットを追加する', style: TextStyle(fontSize: 18)),
                CustomIconButton(
                  iconData: FluentIcons.check_mark,
                  iconColor: whiteColor,
                  labelText: '下記内容で追加する',
                  labelColor: whiteColor,
                  backgroundColor: blueColor,
                  onPressed: () async {
                    if (title.text == '') return;
                    if (items.isEmpty) return;
                    int newId = await formatService.insert(
                      title: title.text,
                      remarks: remarks.text,
                      type: type,
                      items: items,
                    );
                    String tableName = '$type$newId';
                    await backupService.create(
                      tableName: tableName,
                      items: items,
                    );
                    widget.resetIndex();
                    if (!mounted) return;
                    showSuccessBar(context, 'フォーマットを追加しました');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              backgroundColor: whiteColor,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoLabel(
                      label: 'タイトル',
                      child: CustomTextBox(
                        controller: title,
                        placeholder: '例) 請求書',
                      ),
                    ),
                    const SizedBox(height: 16),
                    InfoLabel(
                      label: '備考',
                      child: CustomTextBox(
                        controller: remarks,
                        placeholder: '例) ファイルの作成元のメモや、説明をここに書き記します。',
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InfoLabel(
                      label: 'フォーマットのタイプ',
                      child: Row(
                        children: kFormatTypeList.map((e) {
                          return CustomRadioButton(
                            checked: type == e.key,
                            labelText: e.value,
                            onChanged: (value) {
                              type = e.key;
                              _rebuildItems();
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTypeNote(type: type),
                    const SizedBox(height: 8),
                    CustomItemsTable(rows: itemRows),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(),
                        CustomIconButton(
                          iconData: FluentIcons.add,
                          iconColor: whiteColor,
                          labelText: '項目を追加する',
                          labelColor: whiteColor,
                          backgroundColor: cyanColor,
                          onPressed: () => _itemAdd(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
