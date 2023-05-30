import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/screens/format_add.dart';
import 'package:data_chest_exe/screens/format_details.dart';
import 'package:data_chest_exe/screens/log.dart';
import 'package:data_chest_exe/screens/start.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
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
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        title: const Text(appTitle, style: kAppBarTextStyle),
        actions: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: ButtonState.all(mainColor),
              ),
              icon: const Icon(
                FluentIcons.info,
                color: whiteColor,
                size: 20,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => ContentDialog(
                  title: const Text(
                    'このソフトウェアについて',
                    style: TextStyle(fontSize: 18),
                  ),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ソフトウェア名: データ収納BOX'),
                      Text('バージョン: 1.0.0.0'),
                      Text('ライセンス認証コード:'),
                      SizedBox(height: 32),
                      Center(child: Text('Copyright © 2023 AGORA CREATION'))
                    ],
                  ),
                  actions: [
                    CustomButton(
                      labelText: '閉じる',
                      labelColor: whiteColor,
                      backgroundColor: greyColor,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
