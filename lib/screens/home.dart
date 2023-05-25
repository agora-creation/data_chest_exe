import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/screens/format_add.dart';
import 'package:data_chest_exe/screens/format_details.dart';
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
            title: const Text('入れ物を追加する'),
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
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => const HowToDialog(),
                        ),
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
                  '入れ物一覧',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              items: items,
            ),
          );
        });
  }
}

class HowToDialog extends StatelessWidget {
  const HowToDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '使い方',
        style: TextStyle(fontSize: 18),
      ),
      content: const Text('動画で見せた方が分かりやすいかも？'),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: 'OK!',
          labelColor: whiteColor,
          backgroundColor: blueColor,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
