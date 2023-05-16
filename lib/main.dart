import 'package:data_chest_exe/screens/home.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle('データの箪笥【データンス】');
  setWindowMinSize(const Size(1280, 720));
  setWindowMaxSize(const Size(1280, 720));
  getCurrentScreen().then((screen) {
    setWindowFrame(Rect.fromCenter(
      center: screen!.frame.center,
      width: 1280,
      height: 720,
    ));
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'データの箪笥【データンス】',
      home: HomeScreen(),
    );
  }
}
