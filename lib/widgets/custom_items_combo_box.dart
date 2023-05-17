import 'package:data_chest_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomItemsComboBox extends StatelessWidget {
  final String value;
  final Function(String?)? onChanged;

  const CustomItemsComboBox({
    required this.value,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ComboBox(
      value: value,
      items: kItemTypeList.map((e) {
        return ComboBoxItem(
          value: e.key,
          child: Text(e.value),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
