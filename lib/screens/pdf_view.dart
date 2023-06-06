import 'dart:io';

import 'package:data_chest_exe/common/style.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  final File file;

  const PdfViewScreen(this.file, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FluentIcons.download, color: whiteColor),
                    onPressed: () async {
                      final data = await file.readAsBytes();
                      String? path = await getSavePath(
                        acceptedTypeGroups: [
                          const XTypeGroup(
                            label: 'pdf',
                            extensions: ['pdf'],
                          )
                        ],
                        suggestedName: p.basename(file.path),
                      );
                      if (path == null) return;
                      final xFile = XFile.fromData(
                        data,
                        mimeType: 'application/pdf',
                      );
                      await xFile.saveTo(path);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      content: SfPdfViewer.file(file),
    );
  }
}
