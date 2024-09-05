enum ReadingMode {
  /// Reads barcodes.
  barcode(0),

  /// Reads RFID tags.
  rfid(1);

  const ReadingMode(this.value);

  final int value;
}
