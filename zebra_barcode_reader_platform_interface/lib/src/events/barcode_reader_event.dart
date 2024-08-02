// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:zebra_barcode_reader_platform_interface/src/types/types.dart';

/// Generic Event coming from the native side of Reader.
///
/// This class is used as a base class for all the events that might be
/// triggered from a Reader, but it is never used directly as an event type.
///
/// Do NOT instantiate new events like `ReaderEvent()` directly,
/// use a specific class instead:
///
/// Do `class NewEvent extend ReaderEvent` when creating your own events.
/// See below for examples: `ScannerStatusEvent`, `BarcodeReadEvent`...
/// These events are more semantic and more pleasant to use than raw generics.
/// They can be (and in fact, are) filtered by the `instanceof`-operator.
@immutable
abstract class ReaderEvent {}

/// An event fired when the scanner status has changed.
class ScannerStatusEvent extends ReaderEvent {
  /// Build a ScannerStatusEvent event triggered from the reader.
  ///
  /// The `status` represents the barcode scanner status.
  ScannerStatusEvent({
    required this.status,
  });

  /// The scanner status enum.
  late final ScannerStatus status;

  /// Converts the supplied [Map] to an instance of the [ScannerStatusEvent]
  /// class.
  ScannerStatusEvent.fromJson(Map<String, dynamic> json) {
    status = ScannerStatus.values.firstWhereOrNull(
            (d) => d.name == (json['status'] as String).toLowerCase()) ??
        ScannerStatus.disabled;
  }

  /// Converts the [ScannerStatusEvent] instance into a [Map] instance that
  /// can be serialized to JSON.
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

/// An event fired when a new barcode is read.
class BarcodeReadEvent extends ReaderEvent {
  /// Build a BarcodeReadEvent event triggered from the reader.
  ///
  /// The `barcode` represents the barcode data and type.
  BarcodeReadEvent({
    required this.barcode,
  });

  /// The barcode data.
  late final BarcodeData barcode;

  /// Converts the supplied [Map] to an instance of the [BarcodeReadEvent]
  /// class.
  BarcodeReadEvent.fromJson(Map<String, dynamic> json) {
    barcode = BarcodeData.fromJson(json['barcode']);
  }

  /// Converts the [BarcodeReadEvent] instance into a [Map] instance that
  /// can be serialized to JSON.
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
