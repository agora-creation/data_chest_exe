import 'package:fluent_ui/fluent_ui.dart';

void showSuccessBar(BuildContext context, String msg) async {
  return displayInfoBar(context, builder: (context, close) {
    return InfoBar(
      title: Text(msg),
      severity: InfoBarSeverity.success,
    );
  });
}

void showErrorBar(BuildContext context, String msg) async {
  return displayInfoBar(context, builder: (context, close) {
    return InfoBar(
      title: Text(msg),
      severity: InfoBarSeverity.error,
    );
  });
}
