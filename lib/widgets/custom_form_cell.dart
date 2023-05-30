import 'package:fluent_ui/fluent_ui.dart';

class CustomFormCell extends StatelessWidget {
  final String value;
  final Function(String)? onChanged;

  const CustomFormCell({
    required this.value,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: TextBox(
        controller: TextEditingController(text: value),
        maxLines: null,
        onChanged: onChanged,
      ),
    );
  }
}
