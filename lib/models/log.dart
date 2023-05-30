class LogModel {
  int? id;
  String content;
  String memo;
  DateTime? createdAt;

  LogModel({
    this.id,
    required this.content,
    required this.memo,
    this.createdAt,
  });

  factory LogModel.fromSQLite(Map map) {
    return LogModel(
      id: map['id'],
      content: map['content'],
      memo: map['memo'],
      createdAt: DateTime.tryParse(map['createdAt']),
    );
  }

  static List<LogModel> fromSQLiteList(List<Map> listMap) {
    List<LogModel> ret = [];
    for (Map map in listMap) {
      ret.add(LogModel.fromSQLite(map));
    }
    return ret;
  }

  factory LogModel.empty() {
    return LogModel(
      content: '',
      memo: '',
    );
  }
}
