// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:zebra_barcode_reader_platform_interface/src/events/barcode_reader_event.dart';
import 'package:zebra_barcode_reader_platform_interface/src/types/types.dart';

abstract class ZebraBarcodeReaderPlatform extends PlatformInterface {
  ZebraBarcodeReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZebraBarcodeReaderPlatform _instance = _PlaceholderImplementation();

  static ZebraBarcodeReaderPlatform get instance => _instance;

  static set instance(ZebraBarcodeReaderPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<void> init(BarcodeReaderInitParameters params) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> connect() {
    throw UnimplementedError('connect() has not been implemented.');
  }

  Future<void> disconnect() {
    throw UnimplementedError('disconnect() is not implemented.');
  }

  Stream<ScannerStatusEvent> onScannerStatusEvent() {
    throw UnimplementedError('onScannerStatusEvent() is not implemented.');
  }

  Stream<BarcodeReadEvent> onBarcodeReadEvent() {
    throw UnimplementedError('onBarcodeReadEvent() is not implemented.');
  }
}

class _PlaceholderImplementation extends ZebraBarcodeReaderPlatform {}
