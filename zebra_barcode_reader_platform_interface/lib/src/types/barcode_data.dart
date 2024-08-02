// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A class that represents the data of a barcode.
///
/// This class holds the information related to a scanned barcode,
/// including the data contained in the barcode and the type of barcode.
class BarcodeData {
  /// Creates a new instance of [BarcodeData] with the provided [data] and [type].
  ///
  /// Both [data] and [type] are required fields and cannot be null.
  BarcodeData({
    required this.data,
    required this.type,
  });

  /// The data contained in the barcode.
  late final String data;

  /// The type of the barcode (e.g., QR code, Code128, etc.).
  late final String type;

  /// Creates a new instance of [BarcodeData] from a JSON object.
  ///
  /// The [json] parameter must include the keys 'data' and 'type'.
  BarcodeData.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    type = json['type'];
  }

  /// Converts the [BarcodeData] instance to a JSON object.
  ///
  /// Returns a Map with 'data' and 'type' keys containing the respective values.
  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['data'] = data;
    jsonData['type'] = type;
    return jsonData;
  }

  /// Compares this [BarcodeData] instance with another object.
  ///
  /// Returns `true` if the other object is a [BarcodeData] instance
  /// and both [data] and [type] are equal, otherwise returns `false`.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BarcodeData &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              data == other.data;

  /// Generates a hash code for this [BarcodeData] instance.
  ///
  /// The hash code is based on the [data] and [type] properties.
  @override
  int get hashCode => type.hashCode ^ data.hashCode;

  /// Returns a string representation of this [BarcodeData] instance.
  ///
  /// The string includes the [data] and [type] properties.
  @override
  String toString() {
    return 'BarcodeData{data: $data, type: $type}';
  }
}

