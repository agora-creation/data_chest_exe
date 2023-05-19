import 'package:data_chest_exe/common/dialog.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/models/format.dart';
import 'package:data_chest_exe/services/format.dart';
import 'package:data_chest_exe/widgets/custom_data_table.dart';
import 'package:data_chest_exe/widgets/custom_icon_button.dart';
import 'package:data_chest_exe/widgets/custom_text_box.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FormatDetailsScreen extends StatefulWidget {
  final FormatModel format;
  final Function() resetIndex;

  const FormatDetailsScreen({
    required this.format,
    required this.resetIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<FormatDetailsScreen> createState() => _FormatDetailsScreenState();
}

class _FormatDetailsScreenState extends State<FormatDetailsScreen> {
  FormatService formatService = FormatService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.format.paneTitle(),
                  style: const TextStyle(fontSize: 18),
                ),
                CustomIconButton(
                  iconData: FluentIcons.delete,
                  iconColor: whiteColor,
                  labelText: '${widget.format.paneTitle()}を削除する',
                  labelColor: whiteColor,
                  backgroundColor: redColor,
                  onPressed: () => showFormatDeleteDialog(
                    context: context,
                    formatService: formatService,
                    format: widget.format,
                    resetIndex: widget.resetIndex,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.format.remarks,
              style: const TextStyle(color: greyColor),
            ),
            const SizedBox(height: 4),
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
                            itemCount: widget.format.items.length,
                            gridDelegate: kSearchGrid,
                            itemBuilder: (context, index) {
                              return InfoLabel(
                                label: '${widget.format.items[index]['name']}',
                                child: const CustomTextBox(),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconButton(
                                iconData: FluentIcons.clear,
                                iconColor: lightBlueColor,
                                labelText: '検索クリア',
                                labelColor: lightBlueColor,
                                backgroundColor: whiteColor,
                                onPressed: () {},
                              ),
                              const SizedBox(width: 8),
                              CustomIconButton(
                                iconData: FluentIcons.search,
                                iconColor: whiteColor,
                                labelText: '検索する',
                                labelColor: whiteColor,
                                backgroundColor: lightBlueColor,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomDataTable(items: widget.format.items),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  iconData: FluentIcons.delete,
                  iconColor: redColor,
                  labelText: 'データを削除する',
                  labelColor: redColor,
                  backgroundColor: whiteColor,
                  onPressed: () {
                    showDataDeleteDialog(context: context);
                  },
                ),
                CustomIconButton(
                  iconData: FluentIcons.add,
                  iconColor: whiteColor,
                  labelText: 'データを追加する',
                  labelColor: whiteColor,
                  backgroundColor: blueColor,
                  onPressed: () {
                    showDataAddDialog(context: context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
