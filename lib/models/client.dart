class ClientModel {
  int? id;
  String code;
  String name;
  DateTime? createdAt;

  ClientModel({
    this.id,
    required this.code,
    required this.name,
    this.createdAt,
  });

  factory ClientModel.fromSQLite(Map map) {
    return ClientModel(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      createdAt: DateTime.tryParse(map['createdAt']),
    );
  }

  static List<ClientModel> fromSQLiteList(List<Map> listMap) {
    List<ClientModel> ret = [];
    for (Map map in listMap) {
      ret.add(ClientModel.fromSQLite(map));
    }
    return ret;
  }

  factory ClientModel.empty() {
    return ClientModel(
      code: '',
      name: '',
    );
  }
}
