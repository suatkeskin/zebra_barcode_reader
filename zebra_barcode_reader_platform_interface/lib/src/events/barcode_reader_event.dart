// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:zebra_barcode_reader_platform_interface/src/types/types.dart';

@immutable
abstract class ReaderEvent {}

class ScannerStatusEvent extends ReaderEvent {
  ScannerStatusEvent({
    required this.status,
  });

  late final ScannerStatus status;

  ScannerStatusEvent.fromJson(Map<String, dynamic> json) {
    status = ScannerStatus.values.firstWhereOrNull(
            (d) => d.name == (json['status'] as String).toLowerCase()) ??
        ScannerStatus.disabled;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status.name;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScannerStatusEvent &&
          runtimeType == other.runtimeType &&
          status == other.status;

  @override
  int get hashCode => status.hashCode;
}

class BarcodeReadEvent extends ReaderEvent {
  BarcodeReadEvent({
    required this.barcode,
  });

  late final BarcodeData barcode;

  BarcodeReadEvent.fromJson(Map<String, dynamic> json) {
    barcode = BarcodeData.fromJson(json['barcode']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['barcode'] = barcode.toJson();
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeReadEvent &&
          runtimeType == other.runtimeType &&
          barcode == other.barcode;

  @override
  int get hashCode => barcode.hashCode;

  @override
  String toString() {
    return 'BarcodeReadEvent{barcode: $barcode}';
  }
}
