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
        backgroundColor: const Color(0xFF795548),
        title: const Text(
          'データの箪笥【データンス】',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => showContentDialog(context),
                  style: ButtonStyle(
                    backgroundColor: ButtonState.all(Colors.white),
                  ),
                  child: const Text(
                    '使い方',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
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
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        items: [
          PaneItem(
            selectedTileColor: ButtonState.all(Colors.white),
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('見本用【CSV】'),
            body: _generateBody(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.pdf),
            title: const Text('見本用【PDF】'),
            body: _generateBody(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.file_image),
            title: const Text('見本用【画像】'),
            body: _generateBody(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書・請求書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.excel_document),
            title: const Text('納品書【CSV】'),
            body: Container(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.add),
            title: const Text('フォーマットを追加する'),
            body: Container(),
          ),
        ],
      ),
    );
  }
}

Widget _generateBody() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '見本用【CSV】',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: ButtonState.all(Colors.red),
                ),
                child: const Text('見本用【CSV】を削除する'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              const Expander(
                header: Text('検索条件'),
                content: Center(
                  child: Text('検索'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: ButtonState.all(Colors.red),
                ),
                child: const Text('データを削除する'),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: ButtonState.all(Colors.blue),
                ),
                child: const Text('データを追加する'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void showContentDialog(BuildContext context) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text('Delete file permanently?'),
      content: const Text(
        'If you delete this file, you won\'t be able to recover it. Do you want to delete it?',
      ),
      actions: [
        Button(
          child: const Text('Delete'),
          onPressed: () {
            Navigator.pop(context, 'User deleted file');
            // Delete file here
          },
        ),
        FilledButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, 'User canceled dialog'),
        ),
      ],
    ),
  );
}
