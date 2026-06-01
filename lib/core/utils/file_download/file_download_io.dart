// IO (mobile/desktop) implementation.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> saveBytesAsFileImpl({
  required Uint8List bytes,
  required String filename,
  required String mimeType,
}) async {
  // If it's an image, attempt to save directly to the user's gallery using gal
  if (mimeType.startsWith('image/')) {
    try {
      await Gal.putImageBytes(bytes);
      debugPrint('Saved directly to gallery');
      return; // Success, return early
    } catch (e) {
      debugPrint('Failed to save to gallery directly: $e. Falling back to sharing.');
    }
  }

  // Fallback: Save to temp and share
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}${Platform.pathSeparator}$filename');
  await file.writeAsBytes(bytes, flush: true);

  // Attempt to also save directly to external/public app Downloads folder
  try {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      final localFile = File('${downloadsDir.path}${Platform.pathSeparator}$filename');
      await localFile.writeAsBytes(bytes, flush: true);
      debugPrint('Saved locally to: ${localFile.path}');
    }
  } catch (e) {
    debugPrint('Local persistent save failed: $e');
  }

  final xFile = XFile(file.path, mimeType: mimeType, name: filename);

  // Opens platform-native share UI so the user can save to Downloads/Drive/etc.
  await Share.shareXFiles([xFile]);
}
