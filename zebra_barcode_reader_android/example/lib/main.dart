import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zebra_barcode_reader_android/zebra_barcode_reader_android.dart';
import 'package:zebra_barcode_reader_platform_interface/zebra_barcode_reader_platform_interface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const MyPage(),
      ),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _platform = ZebraBarcodeReaderAndroid();
  Set<String> _tags = {};
  bool _connected = false;
  late StreamSubscription<dynamic> _tagSubscription;
  late StreamSubscription<dynamic> _statusSubscription;
  ReadingMode _readingMode = ReadingMode.barcode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPlatformState();
    });
  }

  @override
  void dispose() {
    _tagSubscription.cancel();
    _statusSubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _platform.init(
        BarcodeReaderInitParameters(readingMode: ReadingMode.barcode.value));
    _tagSubscription = _platform.onBarcodeReadEvent().listen((event) {
      setState(() {
        _tags.add(event.barcode.data);
      });
    });
    _statusSubscription = _platform.onScannerStatusEvent().listen((event) {
      setState(() {
        _connected = event.status.isConnected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: ListView.builder(
            itemCount: _tags.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_tags.toList()[index]),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<ReadingMode>(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                borderRadius: BorderRadius.circular(10.0),
                underline: const SizedBox(),
                value: _readingMode,
                items: const [
                  DropdownMenuItem(
                    value: ReadingMode.barcode,
                    child: Text('Barcode'),
                  ),
                  DropdownMenuItem(
                    value: ReadingMode.rfid,
                    child: Text('RFID'),
                  ),
                ],
                onChanged: (ReadingMode? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _platform.setReadingMode(newValue);
                      _readingMode = newValue;
                    });
                  }
                },
              ),
              OutlinedButton(
                onPressed: () async {
                  if (_connected) {
                    await _platform.disconnect();
                    setState(() {
                      _tags = {};
                    });
                  } else {
                    await _platform.connect(_readingMode);
                    setState(() {
                      _tags = {};
                    });
                  }
                },
                child: _connected
                    ? const Text('Disconnect')
                    : const Text('Connect'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
