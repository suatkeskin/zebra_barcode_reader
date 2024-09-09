import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zebra_barcode_reader/zebra_barcode_reader.dart';

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
  final _reader = ZebraBarcodeReader();

  Set<String> _barcodes = {};
  bool _connected = false;
  late StreamSubscription<dynamic> _barcodeSubscription;
  late StreamSubscription<dynamic> _statusSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPlatformState();
    });
  }

  @override
  void dispose() {
    _barcodeSubscription.cancel();
    _statusSubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _barcodeSubscription = _reader.onBarcodeReadEvent().listen((event) {
      setState(() {
        _barcodes.add(event.barcode.data);
      });
    });
    _statusSubscription = _reader.onScannerStatusEvent().listen((event) {
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
            itemCount: _barcodes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_barcodes.toList()[index]),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: OutlinedButton(
            onPressed: () async {
              if (_connected) {
                await _reader.disconnect();
                setState(() {
                  _barcodes = {};
                });
              } else {
                await _reader.connect(ReadingMode.barcode);
                setState(() {
                  _barcodes = {};
                });
              }
            },
            child:
                _connected ? const Text('Disconnect') : const Text('Connect'),
          ),
        ),
      ],
    );
  }
}
