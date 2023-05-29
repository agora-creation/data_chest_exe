import 'package:fluent_ui/fluent_ui.dart';

class CustomCheckCell extends StatelessWidget {
  final bool checked;
  final Function(bool?)? onChanged;

  const CustomCheckCell({
    required this.checked,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Checkbox(
        checked: checked,
        onChanged: onChanged,
      ),
    );
  }
}
