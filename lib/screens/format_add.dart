import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FormatAddScreen extends StatefulWidget {
  const FormatAddScreen({Key? key}) : super(key: key);

  @override
  State<FormatAddScreen> createState() => _FormatAddScreenState();
}

class _FormatAddScreenState extends State<FormatAddScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('フォーマットを追加する', style: TextStyle(fontSize: 18)),
                CustomIconButton(
                  iconData: FluentIcons.check_mark,
                  iconColor: whiteColor,
                  labelText: '下記内容で追加する',
                  labelColor: whiteColor,
                  backgroundColor: blueColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              backgroundColor: whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoLabel(
                    label: 'タイトル',
                    child: const TextBox(
                      placeholder: '例) 請求書',
                      expands: false,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InfoLabel(
                    label: '備考',
                    child: const TextBox(
                      placeholder: '',
                      expands: false,
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InfoLabel(
                    label: 'フォーマットのタイプ',
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: RadioButton(
                            checked: false,
                            content: const Text('CSV'),
                            onChanged: (value) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: RadioButton(
                            checked: false,
                            content: const Text('PDF'),
                            onChanged: (value) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: RadioButton(
                            checked: false,
                            content: const Text('画像'),
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '※アップロードする予定のCSVファイルを確認し、一行目の見出し名とその値のタイプを入力・選択してください。',
                    style: TextStyle(color: redColor),
                  ),
                  const SizedBox(height: 4),
                  Table(
                    border: TableBorder.all(color: greyColor),
                    columnWidths: const {
                      0: FlexColumnWidth(5),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1),
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
                              child: TextBox()),
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

                      // TableRow(
                      //   children: ['abc', '123']
                      //       .map((e) => Container(
                      //           alignment: Alignment.center,
                      //           margin:
                      //               const EdgeInsets.only(top: 10, bottom: 10),
                      //           child: Text(e)))
                      //       .toList(),
                    ],
                  ),
                  const SizedBox(height: 4),
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
          ],
        ),
      ),
    );
  }
}
