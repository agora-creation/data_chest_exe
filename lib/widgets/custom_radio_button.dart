import 'package:fluent_ui/fluent_ui.dart';

class CustomRadioButton extends StatelessWidget {
  final bool checked;
  final String labelText;
  final Function(bool)? onChanged;

  const CustomRadioButton({
    required this.checked,
    required this.labelText,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: RadioButton(
        checked: checked,
        content: Text(labelText),
        onChanged: onChanged,
      ),
    );
  }
}
