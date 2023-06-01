import 'dart:io';

import 'package:data_chest_exe/common/style.dart';
import 'package:data_chest_exe/widgets/custom_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_twain_scanner/flutter_twain_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String _platformVersion = 'Unknown';
  final _flutterTwainScannerPlugin = FlutterTwainScanner();
  String? _documentPath;
  List<String> _scanners = [];
  String? _selectedScanner;

  void _init() async {
    String platformVersion;
    try {
      platformVersion = await _flutterTwainScannerPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

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
      content: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      labelText: 'List Scanners',
                      labelColor: whiteColor,
                      backgroundColor: greyColor,
                      onPressed: () async {
                        List<String>? scanners =
                            await _flutterTwainScannerPlugin.getDataSources();

                        if (scanners != null) {
                          setState(() {
                            _scanners = scanners;
                          });
                        }
                      },
                    ),
                    ComboBox<String>(
                      value: _selectedScanner,
                      items: _scanners.map((location) {
                        return ComboBoxItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedScanner = newValue;
                        });
                      },
                    ),
                    CustomButton(
                      labelText: 'Scan Document',
                      labelColor: whiteColor,
                      backgroundColor: greyColor,
                      onPressed: () async {
                        if (_selectedScanner != null) {
                          int index = _scanners.indexOf(_selectedScanner!);
                          String? documentPath =
                              await _flutterTwainScannerPlugin
                                  .scanDocument(index);
                          setState(() {
                            _documentPath = documentPath;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 600,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _documentPath == null
                      ? Image.asset('assets/images/default.png')
                      : Image.file(
                          File(_documentPath!),
                          fit: BoxFit.contain,
                          width: 600,
                          height: 600,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
