import 'package:fluent_ui/fluent_ui.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
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
            Text('① 新しいBOXを追加する'),
            SizedBox(height: 4),
            Text('② BOXに名前をつける'),
            SizedBox(height: 4),
            Text('③ BOXに収納するファイルの形式を選ぶ'),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
