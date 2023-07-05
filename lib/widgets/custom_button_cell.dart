import 'package:fluent_ui/fluent_ui.dart';

class CustomButtonCell extends StatelessWidget {
  final String labelText;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomButtonCell({
    required this.labelText,
    required this.labelColor,
    required this.backgroundColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: FilledButton(
        style: ButtonStyle(backgroundColor: ButtonState.all(backgroundColor)),
        onPressed: onPressed,
        child: Text(
          labelText,
          style: TextStyle(
            color: labelColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
