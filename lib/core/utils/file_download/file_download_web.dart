// ignore_for_file: uri_does_not_exist
// Web implementation.
import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'dart:typed_data';

Future<void> saveBytesAsFileImpl({
  required Uint8List bytes,
  required String filename,
  required String mimeType,
}) async {
  final file = html.File([bytes], filename, {'type': mimeType});

  if (_canShareFile(file)) {
    await js_util.promiseToFuture<void>(
      js_util.callMethod(html.window.navigator, 'share', [
        js_util.jsify({
          'files': [file],
          'title': filename,
        }),
      ]),
    );
    return;
  }

  final blob = html.Blob([bytes], mimeType);
  final objectUrl = html.Url.createObjectUrlFromBlob(blob);

  if (_shouldOpenFileInsteadOfHiddenDownload()) {
    final openedWindow = html.window.open(objectUrl, '_blank');

    if (openedWindow == null) {
      html.window.location.href = objectUrl;
    }

    return;
  }

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

bool _shouldOpenFileInsteadOfHiddenDownload() {
  final innerWidth = html.window.innerWidth ?? 0;
  final maxTouchPoints =
      js_util.getProperty<int?>(html.window.navigator, 'maxTouchPoints') ?? 0;

  return innerWidth <= 700 || maxTouchPoints > 0;
}

bool _canShareFile(html.File file) {
  final canShare = js_util.getProperty<Object?>(
    html.window.navigator,
    'canShare',
  );

  if (canShare == null) return false;

  try {
    return js_util.callMethod<bool>(html.window.navigator, 'canShare', [
      js_util.jsify({
        'files': [file],
      }),
    ]);
  } catch (_) {
    return false;
  }
}
