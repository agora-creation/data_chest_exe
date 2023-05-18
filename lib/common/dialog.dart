import 'package:data_chest_exe/common/info_bar.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
import 'package:fluent_ui/fluent_ui.dart';

void showHowToDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text(
        '使い方',
        style: TextStyle(fontSize: 18),
      ),
      content: const Text('動画で見せた方が分かりやすいかも？'),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: 'OK!',
          labelColor: whiteColor,
          backgroundColor: blueColor,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

void showFormatDeleteDialog({
  required BuildContext context,
  required FormatService formatService,
  required FormatModel format,
  required Function resetIndex,
}) async {
  await showDialog(
    context: context,
    builder: (context) => ContentDialog(
      title: Text(
        '${format.paneTitle()}を削除する',
        style: const TextStyle(fontSize: 18),
      ),
      content: const Text('削除すると、データも全て削除されます。\nよろしいですか？'),
      actions: [
        CustomButton(
          labelText: 'いいえ',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: 'はい',
          labelColor: whiteColor,
          backgroundColor: redColor,
          onPressed: () async {
            formatService.delete(format);
            resetIndex();
            Navigator.pop(context);
            showSuccessBar(context, 'フォーマットを削除しました');
          },
        ),
      ],
    ),
  );
}

void showDataDeleteDialog({
  required BuildContext context,
}) async {
  await showDialog(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text(
        'データを削除する',
        style: TextStyle(fontSize: 18),
      ),
      content: const Text('データも全て削除します。\nよろしいですか？'),
      actions: [
        CustomButton(
          labelText: 'いいえ',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: 'はい',
          labelColor: whiteColor,
          backgroundColor: redColor,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

void showDataAddDialog({
  required BuildContext context,
}) async {
  await showDialog(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text(
        'データを追加する',
        style: TextStyle(fontSize: 18),
      ),
      content: const Text('フォーム'),
      actions: [
        CustomButton(
          labelText: 'いいえ',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: 'はい',
          labelColor: whiteColor,
          backgroundColor: blueColor,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
