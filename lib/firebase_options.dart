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
    apiKey: 'AIzaSyB24To186LuLRc-RWnz00HyOElUl79Oat0',
    appId: '1:33396415926:web:fb5e19d7620ec92ce07517',
    messagingSenderId: '33396415926',
    projectId: 'eaglemachines-7eba5',
    authDomain: 'eaglemachines-7eba5.firebaseapp.com',
    storageBucket: 'eaglemachines-7eba5.appspot.com',
    measurementId: 'G-2W681C72TZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyALTt9p0LUYHVWpSR9GRRNeklBiUrwMwe4',
    appId: '1:33396415926:android:6be166a3e80c97d1e07517',
    messagingSenderId: '33396415926',
    projectId: 'eaglemachines-7eba5',
    storageBucket: 'eaglemachines-7eba5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNQd8J2PTK5sApQ3hTgTtDUJEl6i9mceU',
    appId: '1:33396415926:ios:a5ecc079ecb667b6e07517',
    messagingSenderId: '33396415926',
    projectId: 'eaglemachines-7eba5',
    storageBucket: 'eaglemachines-7eba5.appspot.com',
    iosBundleId: 'com.eagle.adminmain',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNQd8J2PTK5sApQ3hTgTtDUJEl6i9mceU',
    appId: '1:33396415926:ios:2962818b4787408ae07517',
    messagingSenderId: '33396415926',
    projectId: 'eaglemachines-7eba5',
    storageBucket: 'eaglemachines-7eba5.appspot.com',
    iosBundleId: 'com.eagle.adminmain.RunnerTests',
  );
}