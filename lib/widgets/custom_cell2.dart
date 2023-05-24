import 'dart:io';

import 'package:data_chest_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as p;

class CustomCell2 extends StatelessWidget {
  final String filePath;

  const CustomCell2(this.filePath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File file = File(filePath);
    return Container(
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
    );
  }
}
