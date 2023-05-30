import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/screens/format_add.dart';
import 'package:data_chest_exe/screens/format_details.dart';
import 'package:data_chest_exe/screens/log.dart';
import 'package:data_chest_exe/screens/start.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:fluent_ui/fluent_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FormatService formatService = FormatService();
  List<NavigationPaneItem> formatItems = [];
  int selectedIndex = 0;

  void _added() async {
    formatItems.clear();
    List<FormatModel> formats = await formatService.select();
    if (formats.isNotEmpty) {
      for (FormatModel format in formats) {
        formatItems.add(PaneItem(
          selectedTileColor: ButtonState.all(whiteColor),
          icon: Icon(format.paneIcon()),
          title: Text(format.paneTitle()),
          body: FormatDetailsScreen(
            format: format,
            init: _init,
          ),
        ));
      }
    } else {
      formatItems.add(PaneItem(
        icon: const Icon(FluentIcons.checkbox_fill),
        title: const Text('BOXがありません'),
        body: const StartScreen(),
        enabled: false,
      ));
    }
    selectedIndex = formats.length - 1;
    setState(() {});
  }

  void _init() async {
    formatItems.clear();
    List<FormatModel> formats = await formatService.select();
    if (formats.isNotEmpty) {
      for (FormatModel format in formats) {
        formatItems.add(PaneItem(
          selectedTileColor: ButtonState.all(whiteColor),
          icon: Icon(format.paneIcon()),
          title: Text(format.paneTitle()),
          body: FormatDetailsScreen(
            format: format,
            init: _init,
          ),
        ));
      }
    } else {
      formatItems.add(PaneItem(
        icon: const Icon(FluentIcons.checkbox_fill),
        title: const Text('BOXがありません'),
        body: const StartScreen(),
        enabled: false,
      ));
    }
    selectedIndex = 0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        title: Text(appTitle, style: kAppBarTextStyle),
      ),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (index) {
          setState(() => selectedIndex = index);
        },
        header: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'BOX一覧',
            style: TextStyle(fontSize: 14),
          ),
        ),
        items: formatItems,
        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            selectedTileColor: ButtonState.all(whiteColor),
            icon: const Icon(FluentIcons.add),
            title: const Text('新しいBOXを追加する'),
            body: FormatAddScreen(added: _added),
          ),
          PaneItemSeparator(),
          PaneItem(
            selectedTileColor: ButtonState.all(whiteColor),
            icon: const Icon(FluentIcons.check_list_text),
            title: const Text('削除ログ一覧'),
            body: const LogScreen(),
          ),
          PaneItemSeparator(),
        ],
      ),
    );
  }
}
