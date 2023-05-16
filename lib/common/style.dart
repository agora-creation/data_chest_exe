import 'package:fluent_ui/fluent_ui.dart';

const double windowWidth = 1280;
const double windowHeight = 720;

const String appTitle = 'データの箪笥【データンス】';

const mainColor = Color(0xFF795548);
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
