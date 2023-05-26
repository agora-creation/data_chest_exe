import 'dart:io';

import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/screens/img_view.dart';
import 'package:data_chest_exe/screens/pdf_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as p;

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
              builder: (context) => PdfViewScreen(file),
              fullscreenDialog: true,
            ),
          );
        } else {
          Navigator.push(
            context,
            FluentPageRoute(
              builder: (context) => ImgViewScreen(file),
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
