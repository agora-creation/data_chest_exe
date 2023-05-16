import 'package:fluent_ui/fluent_ui.dart';

void showHowToDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text('使い方'),
      content: const Text('動画で見せた方が分かりやすいかも？'),
      actions: [
        FilledButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, 'User canceled dialog'),
        ),
        FilledButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, 'User canceled dialog'),
        ),
      ],
    ),
  );
}
