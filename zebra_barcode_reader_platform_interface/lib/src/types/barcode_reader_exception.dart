// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// An exception that represents errors occurring in a barcode reader.
///
/// This class is used to handle errors specific to barcode reader operations,
/// providing both an error [code] and an optional [description].
class BarcodeReaderException implements Exception {
  /// Creates a new [BarcodeReaderException] with the provided [code] and [description].
  ///
  /// The [code] parameter is required and indicates the specific error code.
  /// The [description] parameter is optional and provides additional details about the error.
  BarcodeReaderException(this.code, [this.description]);

  /// The error code representing the type of error.
  final String code;

  /// An optional description providing more details about the error.
  final String? description;

  /// Returns a string representation of this [BarcodeReaderException].
  ///
  /// The string includes the [code] and [description], if available.
  @override
  String toString() => '$code: $description';
}
