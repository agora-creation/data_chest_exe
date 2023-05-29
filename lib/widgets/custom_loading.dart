import 'package:fluent_ui/fluent_ui.dart';

class CustomLoading extends StatelessWidget {
  final String msg;

  const CustomLoading(this.msg, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(msg),
        const SizedBox(height: 16),
        const Center(child: ProgressRing(strokeWidth: 4)),
        const SizedBox(height: 16),
      ],
    );
  }
}
