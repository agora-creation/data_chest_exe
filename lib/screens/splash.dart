import 'package:data_chest_exe/screens/home.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FormatService formatService = FormatService();

  void _init() async {
    await formatService.select();
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      FluentPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(
        child: ProgressRing(),
      ),
    );
  }
}
