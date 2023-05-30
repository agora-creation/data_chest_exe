import 'package:fluent_ui/fluent_ui.dart';

const double windowWidth = 1440;
const double windowHeight = 900;

const String appTitle = 'データ収納BOX';

const mainColor = Color(0xFF00BCD4);
const whiteColor = Color(0xFFFFFFFF);
const blackColor = Color(0xFF333333);
const greyColor = Color(0xFF9E9E9E);
const grey2Color = Color(0xFFE0E0E0);
const redColor = Color(0xFFF44336);
const blueColor = Color(0xFF2196F3);
const lightBlueColor = Color(0xFF03A9F4);
const cyanColor = Color(0xFF00BCD4);

FluentThemeData themeData() {
  return FluentThemeData(
    fontFamily: 'SourceHanSansJP-Regular',
    activeColor: mainColor,
    scaffoldBackgroundColor: const Color(0xFFEFEBE9),
  );
}

const TextStyle kAppBarTextStyle = TextStyle(
  color: whiteColor,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const SliverGridDelegate kSearchGrid =
    SliverGridDelegateWithFixedCrossAxisCount(
  childAspectRatio: 3 / 1,
  crossAxisCount: 4,
  crossAxisSpacing: 8,
);

const SliverGridDelegate kSearchGrid2 =
    SliverGridDelegateWithFixedCrossAxisCount(
  childAspectRatio: 5 / 1,
  crossAxisCount: 2,
  crossAxisSpacing: 8,
);

const Map<String, String> kFormatTypeData = {
  'csv': 'CSV形式',
  'pdf': 'PDF形式',
  'img': '画像形式',
};

final kFormatTypeList =
    kFormatTypeData.entries.map((e) => TypeModel(e.key, e.value)).toList();

const Map<String, String> kItemTypeData = {
  'TEXT': '文字列',
  'INTEGER': '数値',
  'DATETIME': '日時',
};

final kItemTypeList =
    kItemTypeData.entries.map((e) => TypeModel(e.key, e.value)).toList();

class TypeModel {
  String key;
  String value;
  TypeModel(this.key, this.value);
}

const List<int> kRowsPerPages = [10, 20, 30, 40, 50];
