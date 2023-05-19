import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';

class FormatModel {
  int? id;
  String title;
  String remarks;
  String type;
  List<Map<String, String>> items;
  DateTime? createdAt;

  FormatModel({
    this.id,
    required this.title,
    required this.remarks,
    required this.type,
    required this.items,
    this.createdAt,
  });

  factory FormatModel.fromSQLite(Map map) {
    return FormatModel(
      id: map['id'],
      title: map['title'],
      remarks: map['remarks'],
      type: map['type'],
      items: _decodeItems(map['items']),
      createdAt: DateTime.tryParse(map['createdAt']),
    );
  }

  static List<FormatModel> fromSQLiteList(List<Map> listMap) {
    List<FormatModel> ret = [];
    for (Map map in listMap) {
      ret.add(FormatModel.fromSQLite(map));
    }
    return ret;
  }

  factory FormatModel.empty() {
    return FormatModel(
      title: '',
      remarks: '',
      type: '',
      items: [],
    );
  }

  static List<Map<String, String>> _decodeItems(String items) {
    List<Map<String, String>> ret = [];
    List list = json.decode(items);
    for (var e in list) {
      ret.add({
        'name': e['name'],
        'type': e['type'],
      });
    }
    return ret;
  }

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
    String ret = title;
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
