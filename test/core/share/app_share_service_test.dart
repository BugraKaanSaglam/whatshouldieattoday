import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yemek_tarifi_app/core/share/app_share_service.dart';

void main() {
  test('primaryStoreUri returns App Store for Apple platforms', () {
    expect(
      AppShareService.primaryStoreUri(TargetPlatform.iOS),
      AppShareService.appStoreUri,
    );
    expect(
      AppShareService.primaryStoreUri(TargetPlatform.macOS),
      AppShareService.appStoreUri,
    );
  });

  test('primaryStoreUri returns Play Store for non-Apple platforms', () {
    expect(
      AppShareService.primaryStoreUri(TargetPlatform.android),
      AppShareService.playStoreUri,
    );
    expect(
      AppShareService.primaryStoreUri(TargetPlatform.windows),
      AppShareService.playStoreUri,
    );
  });

  test('shareApp uses injected runner when provided', () async {
    String? capturedSubject;
    String? capturedText;

    await AppShareService.shareApp(
      subject: 'What Should I Eat Today?',
      text: 'Share body',
      shareRunner: (subject, text) async {
        capturedSubject = subject;
        capturedText = text;
      },
    );

    expect(capturedSubject, 'What Should I Eat Today?');
    expect(capturedText, 'Share body');
  });
}
