// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A class that contains initialization parameters for a barcode reader.
///
/// This class allows for specifying various settings when initializing a barcode reader.
class BarcodeReaderInitParameters {
  /// Creates a new [BarcodeReaderInitParameters] with the provided settings.
  ///
  /// The [autoConnect] parameter determines whether the reader should automatically
  /// connect to a barcode scanner upon initialization. It defaults to `false`.
  BarcodeReaderInitParameters({
    this.autoConnect = false,
  });

  /// Whether the barcode reader should automatically connect to a scanner.
  ///
  /// If set to `true`, the reader will attempt to connect to a scanner device
  /// automatically during initialization. The default value is `false`.
  final bool autoConnect;
}
