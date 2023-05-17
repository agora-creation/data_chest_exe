import 'package:fluent_ui/fluent_ui.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class FormatModel {
  @Id()
  int id = 0;
  String? title;
  String? remarks;
  String? type;
  String? items;
  DateTime? createdAt;

  FormatModel({
    this.title,
    this.remarks,
    this.type,
    this.items,
    this.createdAt,
  });

  IconData paneIcon() {
    IconData ret = FluentIcons.file_code;
    switch (type) {
      case 'csv':
        ret = FluentIcons.excel_document;
        break;
      case 'pdf':
        ret = FluentIcons.pdf;
        break;
      case 'img':
        ret = FluentIcons.file_image;
        break;
    }
    return ret;
  }

  String paneTitle() {
    String ret = title ?? '';
    switch (type) {
      case 'csv':
        ret += '【CSV形式】';
        break;
      case 'pdf':
        ret += '【PDF形式】';
        break;
      case 'img':
        ret += '【画像形式】';
        break;
      default:
        ret += '【-】';
        break;
    }
    return ret;
  }
}
