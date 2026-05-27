import 'dart:typed_data';

import 'file_download_io.dart' if (dart.library.html) 'file_download_web.dart';

/// Download/save bytes as a file.
///
/// - Web: triggers a browser download.
/// - Mobile/Desktop: opens share sheet (user can save to device).
Future<void> saveBytesAsFile({
  required Uint8List bytes,
  required String filename,
  required String mimeType,
}) async {
  await saveBytesAsFileImpl(
    bytes: bytes,
    filename: filename,
    mimeType: mimeType,
  );
}
