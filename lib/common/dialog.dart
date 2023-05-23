import 'package:data_chest_exe/common/info_bar.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/services/backup.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
import 'package:file_selector/file_selector.dart';
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
  required BackupService backupService,
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
            formatService.delete(id: format.id ?? 0);
            backupService.tableDelete(tableName: '${format.type}${format.id}');
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
      content: const Text('データを全て削除します。\nよろしいですか？'),
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
  required BackupService backupService,
  required FormatModel format,
  required Function getBackups,
}) async {
  await showDialog(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text(
        'データを追加する',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '※文字コードは「utf-8」にしてください\n※一行目が下記のようなCSVをアップロードしてください',
            style: TextStyle(
              color: redColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Table(
            border: TableBorder.all(color: greyColor),
            children: [
              TableRow(
                children: format.items.map((e) {
                  return Text('${e['name']}');
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomButton(
            labelText: 'ファイル選択',
            labelColor: blackColor,
            backgroundColor: grey2Color,
            onPressed: () async {
              XTypeGroup group = const XTypeGroup(
                label: 'CSVファイル',
                extensions: ['csv'],
              );
              final XFile? file = await openFile(acceptedTypeGroups: [group]);
              if (file != null) {
                final csv = await file.readAsString();
                for (String line in csv.split('\n')) {
                  List rows = line.split(',');
                  print(rows);
                }
              }
            },
          ),
        ],
      ),
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
          onPressed: () async {
            await backupService.insert(
              tableName: '${format.type}${format.id}',
              items: format.items,
            );
            getBackups();
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
