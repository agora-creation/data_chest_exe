import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:data_chest_exe/widgets/custom_radio_button.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FormatAddScreen extends StatefulWidget {
  const FormatAddScreen({Key? key}) : super(key: key);

  @override
  State<FormatAddScreen> createState() => _FormatAddScreenState();
}

class _FormatAddScreenState extends State<FormatAddScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController remarks = TextEditingController();
  String type = '';

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
                  onPressed: () {},
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
                    type == 'csv'
                        ? const Text(
                            '※アップロードする予定のCSVファイルを確認し、一行目の見出し名とその値のタイプを入力・選択してください。',
                            style: TextStyle(color: redColor),
                          )
                        : Container(),
                    type == 'pdf'
                        ? const Text(
                            '※アップロードする予定のPDFファイルとは別に、PDFの名前や作成日などを追加するため、項目名とその値のタイプを入力・選択してください。',
                            style: TextStyle(color: redColor),
                          )
                        : Container(),
                    type == 'img'
                        ? const Text(
                            '※アップロードする予定の画像ファイルとは別に、画像の名前や作成日などを追加するため、項目名とその値のタイプを入力・選択してください。',
                            style: TextStyle(color: redColor),
                          )
                        : Container(),
                    const SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(color: greyColor),
                      columnWidths: const {
                        0: FlexColumnWidth(5),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(0.5),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(color: grey2Color),
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(4),
                              child: const Text('項目名'),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(4),
                              child: const Text('項目タイプ'),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(4),
                              child: const Text('削除'),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(4),
                              child: TextBox(),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(4),
                              child: ComboBox(
                                value: '',
                                items: kItemTypeList.map((e) {
                                  return ComboBoxItem(
                                    value: e.key,
                                    child: Text(e.value),
                                  );
                                }).toList(),
                                onChanged: (value) {},
                                isExpanded: true,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(4),
                              child: IconButton(
                                icon: const Icon(
                                  FluentIcons.clear,
                                  color: whiteColor,
                                ),
                                style: ButtonStyle(
                                  backgroundColor: ButtonState.all(redColor),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                          onPressed: () {},
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
