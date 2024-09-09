// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:zebra_barcode_reader_platform_interface/src/events/barcode_reader_event.dart';
import 'package:zebra_barcode_reader_platform_interface/src/types/types.dart';

/// The interface that implementations of barcode reader must implement.
///
/// Platform implementations should extend this class rather than implement it as `reader`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [ZebraBarcodeReaderPlatform] methods.
abstract class ZebraBarcodeReaderPlatform extends PlatformInterface {
  /// Constructs a ZebraBarcodeReaderPlatform.
  ZebraBarcodeReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZebraBarcodeReaderPlatform _instance = _PlaceholderImplementation();

  /// The default instance of [ZebraBarcodeReaderPlatform] to use.
  ///
  /// Defaults to [MethodChannelZebraBarcodeReader].
  static ZebraBarcodeReaderPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ZebraBarcodeReaderPlatform] when they register themselves.
  static set instance(ZebraBarcodeReaderPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Initializes the reader on the device.
  ///
  /// [autoConnect] is used to immediately connect reader after init.
  Future<void> init(BarcodeReaderInitParameters params) {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// Connects to reader.
  Future<void> connect(ReadingMode readingMode) {
    throw UnimplementedError('connect() has not been implemented.');
  }

  /// Disconnects from reader.
  Future<void> disconnect() {
    throw UnimplementedError('disconnect() is not implemented.');
  }

  /// Sets the reading mode.
  Future<void> setReadingMode(ReadingMode readingMode) {
    throw UnimplementedError('setReadingMode() is not implemented.');
  }

  /// The scanner status changed.
  Stream<ScannerStatusEvent> onScannerStatusEvent() {
    throw UnimplementedError('onScannerStatusEvent() is not implemented.');
  }

  /// The reader read a new barcode.
  Stream<BarcodeReadEvent> onBarcodeReadEvent() {
    throw UnimplementedError('onBarcodeReadEvent() is not implemented.');
  }

  Stream<RfidTagReadEvent> onRfidTagReadEvent() {
    throw UnimplementedError('onRfidTagReadEvent() is not implemented.');
  }
}

class _PlaceholderImplementation extends ZebraBarcodeReaderPlatform {}
