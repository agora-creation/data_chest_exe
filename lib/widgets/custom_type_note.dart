import 'package:fluent_ui/fluent_ui.dart';

class CustomTypeNote extends StatelessWidget {
  final String type;

  const CustomTypeNote({
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String note = '';
    switch (type) {
      case 'csv':
        note = '※アップロードする予定のCSVファイルを確認し、一行目の見出し名とその値のタイプを入力・選択してください。';
        break;
      case 'pdf':
        note =
            '※アップロードする予定のPDFファイルとは別に、PDFの名前や作成日などを追加するため、項目名とその値のタイプを入力・選択してください。';
        break;
      case 'img':
        note =
            '※アップロードする予定の画像ファイルとは別に、画像の名前や作成日などを追加するため、項目名とその値のタイプを入力・選択してください。';
        break;
    }
    return Text(note);
  }
}
