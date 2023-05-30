import 'package:data_chest_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomTypeCaution extends StatelessWidget {
  final String type;

  const CustomTypeCaution({
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = '';
    switch (type) {
      case 'csv':
        text = '※アップロードするCSVファイルの一行目を確認し、『項目名』と『項目タイプ』を入力・選択してください。';
        break;
      case 'pdf':
        text = '※アップロードするPDFファイルとは別に、設定したい情報を入力・選択してください。';
        break;
      case 'img':
        text = '※アップロードするPDFファイルとは別に、設定したい情報を入力・選択してください。';
        break;
    }
    return Text(
      text,
      style: const TextStyle(color: redColor),
    );
  }
}
