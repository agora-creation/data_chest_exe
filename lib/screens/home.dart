import 'package:data_chest_exe/common/dialog.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/screens/format_add.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:fluent_ui/fluent_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
        items: [
          PaneItem(
            selectedTileColor: ButtonState.all(whiteColor),
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('見本用【CSV】'),
            body: _generateBody(),
          ),
          PaneItem(
            selectedTileColor: ButtonState.all(whiteColor),
            icon: const Icon(FluentIcons.pdf),
            title: const Text('見本用【PDF】'),
            body: _generateBody(),
          ),
          PaneItem(
            selectedTileColor: ButtonState.all(whiteColor),
            icon: const Icon(FluentIcons.file_image),
            title: const Text('見本用【画像】'),
            body: _generateBody(),
          ),
          PaneItem(
            selectedTileColor: ButtonState.all(whiteColor),
            icon: const Icon(FluentIcons.add),
            title: const Text('フォーマットを追加する'),
            body: const FormatAddScreen(),
          ),
        ],
      ),
    );
  }
}

Widget _generateBody() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '見本用【CSV】',
                style: TextStyle(fontSize: 18),
              ),
              CustomIconButton(
                iconData: FluentIcons.delete,
                iconColor: whiteColor,
                labelText: '見本用【CSV】を削除する',
                labelColor: whiteColor,
                backgroundColor: redColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考備考',
            style: TextStyle(color: greyColor),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expander(
                    header: const Text('検索条件'),
                    content: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          gridDelegate: kSearchGrid,
                          itemBuilder: (context, index) {
                            return InfoLabel(
                              label: '名前',
                              child: const TextBox(expands: false),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              iconData: FluentIcons.clear,
                              iconColor: lightBlueColor,
                              labelText: '検索クリア',
                              labelColor: lightBlueColor,
                              backgroundColor: whiteColor,
                            ),
                            SizedBox(width: 8),
                            CustomIconButton(
                              iconData: FluentIcons.search,
                              iconColor: whiteColor,
                              labelText: '検索する',
                              labelColor: whiteColor,
                              backgroundColor: lightBlueColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconButton(
                iconData: FluentIcons.delete,
                iconColor: redColor,
                labelText: 'データを削除する',
                labelColor: redColor,
                backgroundColor: whiteColor,
              ),
              CustomIconButton(
                iconData: FluentIcons.add,
                iconColor: whiteColor,
                labelText: 'データを追加する',
                labelColor: whiteColor,
                backgroundColor: blueColor,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

List<Widget> _getTitleWidget() {
  return [
    _getTitleItemWidget('Name', 100),
    _getTitleItemWidget('Status', 100),
    _getTitleItemWidget('Phone', 200),
    _getTitleItemWidget('Register', 100),
    _getTitleItemWidget('Termination', 200),
  ];
}

Widget _getTitleItemWidget(String label, double width) {
  return Container(
    width: width,
    height: 56,
    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
    alignment: Alignment.centerLeft,
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget _generateFirstColumnRow(BuildContext context, int index) {
  return Container(
    width: 100,
    height: 52,
    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
    alignment: Alignment.centerLeft,
    child: Text('aa'),
  );
}

Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
  return Row(
    children: <Widget>[
      Container(
        width: 100,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Icon(FluentIcons.not_executed, color: Colors.green),
            Text('Active')
          ],
        ),
      ),
      Container(
        width: 200,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text('00000000000000'),
      ),
      Container(
        width: 100,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text('aaaaaaaaaa'),
      ),
      Container(
        width: 200,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Text('ddddddddddddd'),
      ),
    ],
  );
}
