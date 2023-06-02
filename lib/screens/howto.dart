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
