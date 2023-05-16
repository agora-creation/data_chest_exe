// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'format.dart';

// ignore_for_file: type=lint
class $FormatDBTable extends FormatDB
    with TableInfo<$FormatDBTable, FormatDBData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormatDBTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, content];
  @override
  String get aliasedName => _alias ?? 'format_d_b';
  @override
  String get actualTableName => 'format_d_b';
  @override
  VerificationContext validateIntegrity(Insertable<FormatDBData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormatDBData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormatDBData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
    );
  }

  @override
  $FormatDBTable createAlias(String alias) {
    return $FormatDBTable(attachedDatabase, alias);
  }
}

class FormatDBData extends DataClass implements Insertable<FormatDBData> {
  final int id;
  final String content;
  const FormatDBData({required this.id, required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    return map;
  }

  FormatDBCompanion toCompanion(bool nullToAbsent) {
    return FormatDBCompanion(
      id: Value(id),
      content: Value(content),
    );
  }

  factory FormatDBData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormatDBData(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
    };
  }

  FormatDBData copyWith({int? id, String? content}) => FormatDBData(
        id: id ?? this.id,
        content: content ?? this.content,
      );
  @override
  String toString() {
    return (StringBuffer('FormatDBData(')
          ..write('id: $id, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormatDBData &&
          other.id == this.id &&
          other.content == this.content);
}

class FormatDBCompanion extends UpdateCompanion<FormatDBData> {
  final Value<int> id;
  final Value<String> content;
  const FormatDBCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
  });
  FormatDBCompanion.insert({
    this.id = const Value.absent(),
    required String content,
  }) : content = Value(content);
  static Insertable<FormatDBData> custom({
    Expression<int>? id,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
    });
  }

  FormatDBCompanion copyWith({Value<int>? id, Value<String>? content}) {
    return FormatDBCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormatDBCompanion(')
          ..write('id: $id, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $FormatDBTable formatDB = $FormatDBTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [formatDB];
}
