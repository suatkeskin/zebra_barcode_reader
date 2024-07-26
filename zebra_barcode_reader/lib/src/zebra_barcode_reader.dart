// Copyright (c) 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:zebra_barcode_reader_platform_interface/zebra_barcode_reader_platform_interface.dart';

/// Connects to Zebra Barcode Handheld readers and reads barcodes tags asynchronously.
class ZebraBarcodeReader {
  static ZebraBarcodeReaderPlatform get _reader =>
      ZebraBarcodeReaderPlatform.instance;

  Future<void> init(BarcodeReaderInitParameters params) {
    return _reader.init(params);
  }

  Future<void> connect() {
    return _reader.connect();
  }

  Future<void> disconnect() {
    return _reader.disconnect();
  }

  Stream<ScannerStatusEvent> onScannerStatusEvent() {
    return _reader.onScannerStatusEvent();
  }

  Stream<BarcodeReadEvent> onBarcodeReadEvent() {
    return _reader.onBarcodeReadEvent();
  }
}
