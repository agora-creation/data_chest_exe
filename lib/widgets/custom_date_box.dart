import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomDateBox extends StatelessWidget {
  final DateTime? value;
  final Function()? onTap;

  const CustomDateBox({
    this.value,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = dateText('yyyy-MM-dd', value);
    return TextBox(
      controller: TextEditingController(text: text),
      placeholder: '年-月-日',
      suffix: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(
          FluentIcons.calendar,
          color: greyColor,
        ),
      ),
      readOnly: true,
      onTap: onTap,
    );
  }
}
