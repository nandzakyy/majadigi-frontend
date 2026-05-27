// IO (mobile/desktop) implementation.
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> saveBytesAsFileImpl({
  required Uint8List bytes,
  required String filename,
  required String mimeType,
}) async {
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}${Platform.pathSeparator}$filename');
  await file.writeAsBytes(bytes, flush: true);

  final xFile = XFile(file.path, mimeType: mimeType, name: filename);

  // Opens platform-native share UI so the user can save to Downloads/Drive/etc.
  await Share.shareXFiles([xFile]);
}
