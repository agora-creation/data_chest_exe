import 'dart:io';

import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CustomCell2 extends StatelessWidget {
  final String filePath;

  const CustomCell2(this.filePath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File file = File(filePath);
    return GestureDetector(
      onTap: () {
        if (p.extension(filePath) == '.pdf') {
          showDialog(
            context: context,
            builder: (context) => ContentDialog(
              content: SfPdfViewer.file(file),
              actions: [
                CustomButton(
                  labelText: '閉じる',
                  labelColor: whiteColor,
                  backgroundColor: greyColor,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => ContentDialog(
              content: Image.file(file),
              actions: [
                CustomButton(
                  labelText: '閉じる',
                  labelColor: whiteColor,
                  backgroundColor: greyColor,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.centerLeft,
        child: Text(
          p.basename(file.path),
          style: const TextStyle(
            color: blueColor,
            decoration: TextDecoration.underline,
          ),
          softWrap: false,
        ),
      ),
    );
  }
}
