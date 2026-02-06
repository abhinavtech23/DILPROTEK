// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not supported yet.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS is not supported yet.');
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS is not supported yet.');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows is not supported yet.');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux is not supported yet.');
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDp4bf74cBaZQRhCCy7_Mpss8YuF_ndOnc',
    appId: '1:871911537267:android:1e52182dd3f9c4a4fc8806',
    messagingSenderId: '871911537267',
    projectId: 'dilprotek-abhinav',
    storageBucket: 'dilprotek-abhinav.firebasestorage.app',
  );
}