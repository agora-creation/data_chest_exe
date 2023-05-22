import 'package:data_chest_exe/common/dialog.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/screens/format_add.dart';
import 'package:data_chest_exe/screens/format_details.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:fluent_ui/fluent_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FormatService formatService = FormatService();
  int selectedIndex = 0;

  void resetIndex() {
    setState(() {
      selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FormatModel>>(
        future: formatService.select(),
        builder: (context, snapshot) {
          List<NavigationPaneItem> items = [];
          items.add(PaneItem(
            selectedTileColor: ButtonState.all(whiteColor),
            icon: const Icon(FluentIcons.add),
            title: const Text('フォーマットを追加する'),
            body: FormatAddScreen(resetIndex: resetIndex),
          ));
          if (snapshot.hasData) {
            snapshot.data?.forEach((format) {
              items.add(PaneItem(
                selectedTileColor: ButtonState.all(whiteColor),
                icon: Icon(format.paneIcon()),
                title: Text(format.paneTitle()),
                body: FormatDetailsScreen(
                  format: format,
                  resetIndex: resetIndex,
                ),
              ));
            });
          }
          return NavigationView(
            appBar: NavigationAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: mainColor,
              title: const Text(appTitle, style: kAppBarTextStyle),
              actions: Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomIconButton(
                        iconData: FluentIcons.info,
                        iconColor: blackColor,
                        labelText: '使い方',
                        labelColor: blackColor,
                        backgroundColor: whiteColor,
                        onPressed: () => showHowToDialog(context),
                      ),
                    ],
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
                  'フォーマット一覧',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              items: items,
            ),
          );
        });
  }
}
