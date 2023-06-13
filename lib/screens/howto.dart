import 'package:fluent_ui/fluent_ui.dart';

class HowtoScreen extends StatefulWidget {
  const HowtoScreen({Key? key}) : super(key: key);

  @override
  State<HowtoScreen> createState() => _HowtoScreenState();
}

class _HowtoScreenState extends State<HowtoScreen> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'データ収納BOXについて',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('このソフトウェアでは、様々なファイルをアップロードし、このソフトウェア上でデータ管理することができます。'),
            SizedBox(height: 8),
            Text(
              '■ CSVファイルの場合',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('CSVファイル内の値をデータ化し、このソフトウェア内に保存・管理できます。'),
            SizedBox(height: 8),
            Text(
              '■ PDFファイル/画像ファイルの場合',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('ファイル自体をこのソフトウェア内に保存する他、『タイトル』や『作成日』といった付随情報も登録することができます。'),
            Text('『タイトル』や『作成日』といった付随情報は、検索でファイルを見つけやすくなる情報です。'),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
