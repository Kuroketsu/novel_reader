// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiDttJ7nw5VDbpNH7UdKyfZpdAJjtmFkA',
    appId: '1:597536217280:android:cc3ca59fbc13b5bb803525',
    messagingSenderId: '597536217280',
    projectId: 'novel-reader-15674',
    storageBucket: 'novel-reader-15674.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAW0O5yv1FPI0Sbf7017f5D9dAhjvYM8zU',
    appId: '1:597536217280:web:6adda748a5824373803525',
    messagingSenderId: '597536217280',
    projectId: 'novel-reader-15674',
    authDomain: 'novel-reader-15674.firebaseapp.com',
    storageBucket: 'novel-reader-15674.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9pcFsTu_fa33ipqZzRJnFyn1BYF05-K8',
    appId: '1:597536217280:ios:d596692ac0c1ecab803525',
    messagingSenderId: '597536217280',
    projectId: 'novel-reader-15674',
    storageBucket: 'novel-reader-15674.appspot.com',
    iosBundleId: 'com.kuroketsu.novel.reader.dev',
  );
}
