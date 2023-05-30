import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomFileCaution extends StatelessWidget {
  final FormatModel format;

  const CustomFileCaution({
    required this.format,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = Container();
    switch (format.type) {
      case 'csv':
        widget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '※CSVファイルの文字コードは「utf-8」にしてください。\n※一行目が下記のようなCSVファイルを選択してください。',
              style: TextStyle(
                color: redColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Table(
              border: TableBorder.all(color: greyColor),
              children: [
                TableRow(
                  children: format.items.map((e) {
                    return Text('${e['name']}');
                  }).toList(),
                ),
              ],
            ),
          ],
        );
        break;
      case 'pdf':
        widget = const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '※PDFファイルを選択してください',
              style: TextStyle(
                color: redColor,
                fontSize: 12,
              ),
            ),
          ],
        );
        break;
      case 'img':
        widget = const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '※画像ファイルを選択してください',
              style: TextStyle(
                color: redColor,
                fontSize: 12,
              ),
            ),
          ],
        );
        break;
    }
    return widget;
  }
}
