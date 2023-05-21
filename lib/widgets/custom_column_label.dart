import 'package:fluent_ui/fluent_ui.dart';

class CustomColumnLabel extends StatelessWidget {
  final String label;

  const CustomColumnLabel(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.centerLeft,
      child: Text(label, softWrap: false),
    );
  }
}
