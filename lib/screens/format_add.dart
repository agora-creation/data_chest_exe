import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/widgets/custom_icon.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:data_chest_exe/widgets/custom_items_combo_box.dart';
import 'package:data_chest_exe/widgets/custom_items_table.dart';
import 'package:data_chest_exe/widgets/custom_radio_button.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
import 'package:data_chest_exe/widgets/custom_type_caution.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FormatAddScreen extends StatefulWidget {
  final Function() added;

  const FormatAddScreen({
    required this.added,
    Key? key,
  }) : super(key: key);

  @override
  State<FormatAddScreen> createState() => _FormatAddScreenState();
}

class _FormatAddScreenState extends State<FormatAddScreen> {
  FormatService formatService = FormatService();
  TextEditingController title = TextEditingController();
  TextEditingController remarks = TextEditingController();
  String type = kFormatTypeList.first.key;
  List<Map<String, String>> items = [];
  List<TableRow> itemRows = [];

  void _itemAdd() {
    items.add({'name': '', 'type': 'TEXT'});
    _rebuildItemRows();
  }

  void _typeChange(Map<String, String> map, String value) {
    Map<String, String> getMap = items.singleWhere((e) => e == map);
    getMap['type'] = value;
    _rebuildItemRows();
  }

  void _itemRemove(Map<String, String> map) {
    items.remove(map);
    _rebuildItemRows();
  }

  void _rebuildItems() {
    items.clear();
    switch (type) {
      case 'csv':
        items.add({'name': 'カテゴリコード', 'type': 'TEXT'});
        items.add({'name': '商品コード', 'type': 'TEXT'});
        items.add({'name': '商品名', 'type': 'TEXT'});
        items.add({'name': '商品カナ名', 'type': 'TEXT'});
        items.add({'name': '入数', 'type': 'INTEGER'});
        items.add({'name': '商品説明文', 'type': 'TEXT'});
        items.add({'name': '状態フラグ', 'type': 'INTEGER'});
        items.add({'name': 'JANコード', 'type': 'TEXT'});
        break;
      case 'pdf':
        items.add({'name': '請求日', 'type': 'DATETIME'});
        items.add({'name': '得意先No', 'type': 'TEXT'});
        items.add({'name': '会社名', 'type': 'TEXT'});
        items.add({'name': '請求先氏名', 'type': 'TEXT'});
        items.add({'name': '郵便番号', 'type': 'TEXT'});
        items.add({'name': '住所', 'type': 'TEXT'});
        items.add({'name': '電話番号', 'type': 'TEXT'});
        break;
      case 'img':
        items.add({'name': '請求日', 'type': 'DATETIME'});
        items.add({'name': '得意先No', 'type': 'TEXT'});
        items.add({'name': '会社名', 'type': 'TEXT'});
        items.add({'name': '請求先氏名', 'type': 'TEXT'});
        items.add({'name': '郵便番号', 'type': 'TEXT'});
        items.add({'name': '住所', 'type': 'TEXT'});
        items.add({'name': '電話番号', 'type': 'TEXT'});
        break;
    }
    _rebuildItemRows();
  }

  void _rebuildItemRows() {
    itemRows.clear();
    for (Map<String, String> map in items) {
      itemRows.add(TableRow(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            child: CustomTextBox(
              controller: TextEditingController(text: '${map['name']}'),
              onChanged: (value) {
                map['name'] = value;
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            child: CustomItemsComboBox(
              value: '${map['type']}',
              onChanged: (value) => _typeChange(map, value ?? 'TEXT'),
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
    setState(() {});
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
                const Text('新しいBOXを追加する', style: TextStyle(fontSize: 18)),
                CustomIconButton(
                  iconData: FluentIcons.check_mark,
                  iconColor: whiteColor,
                  labelText: '下記内容で追加する',
                  labelColor: whiteColor,
                  backgroundColor: blueColor,
                  onPressed: () async {
                    String? error = await formatService.insert(
                      title: title.text,
                      remarks: remarks.text,
                      type: type,
                      items: items,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    widget.added();
                    if (!mounted) return;
                    showMessage(context, 'BOXを追加しました', true);
                    return;
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
                      label: 'BOX名',
                      child: CustomTextBox(
                        controller: title,
                        placeholder: '例) 商品の発注データ',
                      ),
                    ),
                    // const SizedBox(height: 16),
                    // InfoLabel(
                    //   label: '備考・メモ',
                    //   child: CustomTextBox(
                    //     controller: remarks,
                    //     placeholder: '例) ファイルの収納ルールや、その他説明をここに記入できます。',
                    //     maxLines: null,
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    InfoLabel(
                      label: '収納するファイルの形式',
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
                    CustomTypeCaution(type: type),
                    const SizedBox(height: 4),
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
