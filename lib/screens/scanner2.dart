import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_scanner/quick_scanner.dart';

class Scanner2Screen extends StatefulWidget {
  const Scanner2Screen({Key? key}) : super(key: key);

  @override
  State<Scanner2Screen> createState() => _Scanner2ScreenState();
}

class _Scanner2ScreenState extends State<Scanner2Screen> {
  List<String> scanners = [];
  String deviceId = '';

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        color: mainColor,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(FluentIcons.back, color: whiteColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                labelText: 'startWatch',
                labelColor: whiteColor,
                backgroundColor: greyColor,
                onPressed: () async {
                  await QuickScanner.startWatch();
                  setState(() {
                    scanners.clear();
                    deviceId = '';
                  });
                },
              ),
              CustomButton(
                labelText: 'stopWatch',
                labelColor: whiteColor,
                backgroundColor: greyColor,
                onPressed: () async {
                  await QuickScanner.stopWatch();
                  setState(() {
                    scanners.clear();
                    deviceId = '';
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                labelText: 'getScanners',
                labelColor: whiteColor,
                backgroundColor: blueColor,
                onPressed: () async {
                  var list = await QuickScanner.getScanners();
                  setState(() {
                    scanners.addAll(list);
                  });
                },
              ),
            ],
          ),
          ComboBox<String>(
            value: deviceId,
            items: scanners.map((scanner) {
              return ComboBoxItem(
                value: scanner,
                child: Text(scanner),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                deviceId = value ?? '';
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                labelText: 'scan',
                labelColor: whiteColor,
                backgroundColor: blueColor,
                onPressed: () async {
                  var directory = await getApplicationDocumentsDirectory();
                  if (deviceId != '') {
                    print(deviceId);
                    var scannedFile = await QuickScanner.scanFile(
                      deviceId,
                      directory.path,
                    );
                    print('scannedFile $scannedFile');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
