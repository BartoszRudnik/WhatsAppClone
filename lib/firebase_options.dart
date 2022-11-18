// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCvtON_g19NTiGclAocJbtKx7OSzkAEVeg',
    appId: '1:996527806466:web:2e424ed2bcc46b8989af1b',
    messagingSenderId: '996527806466',
    projectId: 'whatsapp-backend-3392a',
    authDomain: 'whatsapp-backend-3392a.firebaseapp.com',
    storageBucket: 'whatsapp-backend-3392a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCvKGynWxwnFuaGlSMJNAjI-1ORD3rDcs',
    appId: '1:996527806466:android:30821902ad93276689af1b',
    messagingSenderId: '996527806466',
    projectId: 'whatsapp-backend-3392a',
    storageBucket: 'whatsapp-backend-3392a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7jSx6tCPz5nWpNQjiPdeusWrZgb2X7cM',
    appId: '1:996527806466:ios:00bdf75d01bea02389af1b',
    messagingSenderId: '996527806466',
    projectId: 'whatsapp-backend-3392a',
    storageBucket: 'whatsapp-backend-3392a.appspot.com',
    iosClientId: '996527806466-q0njmmpb1jl6tgguh0hub6lm96d8a1rj.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB7jSx6tCPz5nWpNQjiPdeusWrZgb2X7cM',
    appId: '1:996527806466:ios:00bdf75d01bea02389af1b',
    messagingSenderId: '996527806466',
    projectId: 'whatsapp-backend-3392a',
    storageBucket: 'whatsapp-backend-3392a.appspot.com',
    iosClientId: '996527806466-q0njmmpb1jl6tgguh0hub6lm96d8a1rj.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone',
  );
}
