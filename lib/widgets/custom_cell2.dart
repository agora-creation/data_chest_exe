import 'dart:io';

import 'package:data_chest_exe/common/style.dart';
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
          Navigator.push(
            context,
            FluentPageRoute(
              builder: (context) => ScaffoldPage(
                padding: EdgeInsets.zero,
                header: Container(
                  color: mainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(FluentIcons.back, color: whiteColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
                content: SfPdfViewer.file(file),
              ),
              fullscreenDialog: true,
            ),
          );
        } else {
          Navigator.push(
            context,
            FluentPageRoute(
              builder: (context) => ScaffoldPage(
                padding: EdgeInsets.zero,
                header: Container(
                  color: mainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(FluentIcons.back, color: whiteColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
                content: Image.file(file),
              ),
              fullscreenDialog: true,
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
