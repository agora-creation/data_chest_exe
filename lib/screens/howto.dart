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
            Text('使い方の説明'),
          ],
        ),
      ),
    );
  }
}
