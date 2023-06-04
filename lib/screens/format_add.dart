import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:data_chest_exe/widgets/custom_icon_text_button.dart';
import 'package:data_chest_exe/widgets/custom_items_combo_box.dart';
import 'package:data_chest_exe/widgets/custom_items_table.dart';
import 'package:data_chest_exe/widgets/custom_radio_button.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
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
            child: CustomIconButton(
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
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        color: mainColor,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(FluentIcons.back, color: whiteColor),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                '新しいBOXを追加する',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomIconTextButton(
                iconData: FluentIcons.check_mark,
                iconColor: blackColor,
                labelText: '以下の内容で追加する',
                labelColor: blackColor,
                backgroundColor: whiteColor,
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
                  Navigator.pop(context);
                  return;
                },
              ),
            ],
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
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
                      type == 'csv'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '※アップロードするCSVファイルの一行目を確認し、『項目名』と『項目タイプ』を入力・選択してください。',
                                  style: TextStyle(color: redColor),
                                ),
                                const SizedBox(height: 4),
                                CustomItemsTable(rows: itemRows),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(),
                                    CustomIconTextButton(
                                      iconData: FluentIcons.add,
                                      iconColor: whiteColor,
                                      labelText: '項目を追加する',
                                      labelColor: whiteColor,
                                      backgroundColor: greyColor,
                                      onPressed: () => _itemAdd(),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      type == 'pdf'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '※アップロードするPDFファイルに情報を入力するための『項目名』と『項目タイプ』を入力・選択してください。',
                                  style: TextStyle(color: redColor),
                                ),
                                const SizedBox(height: 4),
                                CustomItemsTable(rows: itemRows),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(),
                                    CustomIconTextButton(
                                      iconData: FluentIcons.add,
                                      iconColor: whiteColor,
                                      labelText: '項目を追加する',
                                      labelColor: whiteColor,
                                      backgroundColor: greyColor,
                                      onPressed: () => _itemAdd(),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      type == 'img'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '※アップロードする画像ファイルに情報を入力するための『項目名』と『項目タイプ』を入力・選択してください。',
                                  style: TextStyle(color: redColor),
                                ),
                                const SizedBox(height: 4),
                                CustomItemsTable(rows: itemRows),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(),
                                    CustomIconTextButton(
                                      iconData: FluentIcons.add,
                                      iconColor: whiteColor,
                                      labelText: '項目を追加する',
                                      labelColor: whiteColor,
                                      backgroundColor: greyColor,
                                      onPressed: () => _itemAdd(),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
