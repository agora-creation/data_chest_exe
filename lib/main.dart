import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/db/format.dart';
import 'package:data_chest_exe/screens/home.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_size/window_size.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle(appTitle);
  setWindowMinSize(const Size(windowWidth, windowHeight));
  setWindowMaxSize(const Size(windowWidth, windowHeight));
  getCurrentScreen().then((screen) {
    setWindowFrame(Rect.fromCenter(
      center: screen!.frame.center,
      width: windowWidth,
      height: windowHeight,
    ));
  });
  final database = MyDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: themeData(),
      home: const HomeScreen(),
    );
  }
}
