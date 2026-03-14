import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

typedef AppShareRunner = Future<void> Function(String subject, String text);

class AppShareService {
  AppShareService._();

  static final Uri appStoreUri = Uri.parse(
    'https://apps.apple.com/tr/app/what-should-i-eat-today/id6741708205?l=tr',
  );
  static final Uri playStoreUri = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.whatshouldieattoday.mobile',
  );

  static Uri primaryStoreUri(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return appStoreUri;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return playStoreUri;
    }
  }

  static Future<void> shareApp({
    required String subject,
    required String text,
    AppShareRunner? shareRunner,
  }) async {
    if (shareRunner != null) {
      await shareRunner(subject, text);
      return;
    }

    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }
}
