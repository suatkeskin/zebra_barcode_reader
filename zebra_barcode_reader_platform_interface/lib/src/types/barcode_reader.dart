// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// A class that represents a barcode reader device.
///
/// This class is immutable and contains information about the reader device,
/// specifically the name or identifier of the device.
@immutable
class BarcodeReader {
  /// Creates a new instance of [BarcodeReader] with the provided [name].
  ///
  /// The [name] parameter is required and represents the identifier or name of the reader device.
  const BarcodeReader({
    required this.name,
  });

  /// The name or identifier of the reader device.
  final String name;

  /// Compares this [BarcodeReader] instance with another object.
  ///
  /// Returns `true` if the other object is a [BarcodeReader] instance
  /// and the [name] is equal, otherwise returns `false`.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BarcodeReader &&
              runtimeType == other.runtimeType &&
              name == other.name;

  /// Generates a hash code for this [BarcodeReader] instance.
  ///
  /// The hash code is based on the [name] property.
  @override
  int get hashCode => name.hashCode;

  /// Returns a string representation of this [BarcodeReader] instance.
  ///
  /// The string includes the class name and the [name] property.
  @override
  String toString() {
    return '${objectRuntimeType(this, 'BarcodeReader')}($name)';
  }
}
