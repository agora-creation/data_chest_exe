import 'package:data_chest_exe/common/functions.dart';
import 'package:data_chest_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomDateRangeBox extends StatelessWidget {
  final DateTime? startValue;
  final DateTime? endValue;
  final Function()? onTap;

  const CustomDateRangeBox({
    this.startValue,
    this.endValue,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = '';

    if (startValue != null && endValue != null) {
      text =
          '${dateText('yyyy-MM-dd', startValue)} ～ ${dateText('yyyy-MM-dd', endValue)}';
    }
    return TextBox(
      controller: TextEditingController(text: text),
      placeholder: '年-月-日 ～ 年-月-日',
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
