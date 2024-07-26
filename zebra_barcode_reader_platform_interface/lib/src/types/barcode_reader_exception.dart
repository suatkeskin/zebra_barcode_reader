// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class BarcodeReaderException implements Exception {
  BarcodeReaderException(this.code, this.description);

  String code;

  String? description;

  @override
  String toString() => '$code: $description';
}
