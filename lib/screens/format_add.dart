import 'dart:convert';

import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/main.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/objectbox.g.dart';
import 'package:data_chest_exe/widgets/custom_icon.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:data_chest_exe/widgets/custom_items_combo_box.dart';
import 'package:data_chest_exe/widgets/custom_items_table.dart';
import 'package:data_chest_exe/widgets/custom_radio_button.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
import 'package:data_chest_exe/widgets/custom_type_note.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FormatAddScreen extends StatefulWidget {
  const FormatAddScreen({Key? key}) : super(key: key);

  @override
  State<FormatAddScreen> createState() => _FormatAddScreenState();
}

class _FormatAddScreenState extends State<FormatAddScreen> {
  Box<FormatModel> formatBox = objectBox.store.box<FormatModel>();
  TextEditingController title = TextEditingController();
  TextEditingController remarks = TextEditingController();
  String type = '';
  List<Map<String, String>> items = [];
  List<TableRow> itemRows = [];

  void _itemAdd() {
    items.add({
      'name': '',
      'type': 'text',
    });
    _rebuildItemRows();
  }

  void _itemMod(Map item) {
    _rebuildItemRows();
  }

  void _itemRemove(Map item) {
    items.remove(item);
    _rebuildItemRows();
  }

  void _rebuildItemRows() {
    setState(() {
      itemRows.clear();
      for (Map item in items) {
        itemRows.add(TableRow(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(4),
              child: CustomTextBox(
                onChanged: (value) {
                  item['name'] = value;
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(4),
              child: CustomItemsComboBox(
                value: item['type'],
                onChanged: (value) {
                  item['type'] = value;
                  _itemMod(item);
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
                onPressed: () => _itemRemove(item),
              ),
            ),
          ],
        ));
      }
    });
  }

  void _init() {
    setState(() {
      type = kFormatTypeList.first.key;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
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
                  onPressed: () {
                    if (title.text == '') return;
                    if (items.isEmpty) return;
                    String itemsJson = json.encode(items);
                    FormatModel model = FormatModel(
                      title: title.text,
                      remarks: remarks.text,
                      type: type,
                      items: itemsJson,
                      createdAt: DateTime.now(),
                    );
                    formatBox.put(model);
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
                              setState(() {
                                type = e.key;
                              });
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
