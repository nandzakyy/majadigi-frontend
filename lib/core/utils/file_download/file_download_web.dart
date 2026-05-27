// Web implementation.
import 'dart:html' as html;
import 'dart:typed_data';

Future<void> saveBytesAsFileImpl({
  required Uint8List bytes,
  required String filename,
  required String mimeType,
}) async {
  final blob = html.Blob([bytes], mimeType);
  final objectUrl = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: objectUrl)
    ..setAttribute('download', filename)
    ..setAttribute('rel', 'noopener')
    ..target = '_self'
    ..style.position = 'fixed'
    ..style.left = '-9999px'
    ..style.top = '-9999px';

  html.document.body?.append(anchor);
  anchor.click();

  // Give the browser a tick to start the download before cleanup.
  await Future<void>.delayed(const Duration(seconds: 2));
  anchor.remove();
  html.Url.revokeObjectUrl(objectUrl);
}
