// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

@immutable
class BarcodeReader {
  const BarcodeReader({
    required this.name,
  });

  /// The id of the reader device.
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeReader &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'ReaderDescription')}(' '$name)';
  }
}
