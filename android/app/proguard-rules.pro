# Keep the Flutter plugin registrant callable by Flutter's Android embedding.
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep the app entry point referenced from AndroidManifest.xml.
-keep class com.whatshouldieattoday.mobile.MainActivity { *; }
