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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCLARQXQYA2pMhg5v33Y1_qjawyg29d8H0',
    appId: '1:450589154874:web:b50451ed22b010c7069f03',
    messagingSenderId: '450589154874',
    projectId: 'duancuoiky',
    authDomain: 'duancuoiky.firebaseapp.com',
    databaseURL: 'https://duancuoiky-default-rtdb.firebaseio.com',
    storageBucket: 'duancuoiky.firebasestorage.app',
    measurementId: 'G-21TT35KCTF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9dk8AlxzNLDdFXjuuKXt9Kl5i1xALQ5Y',
    appId: '1:450589154874:android:5657d290883b3676069f03',
    messagingSenderId: '450589154874',
    projectId: 'duancuoiky',
    databaseURL: 'https://duancuoiky-default-rtdb.firebaseio.com',
    storageBucket: 'duancuoiky.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKBS9vtEju7IcC1jni0KVclk2_NoYxcX8',
    appId: '1:450589154874:ios:a5a6a526d0a8ed3e069f03',
    messagingSenderId: '450589154874',
    projectId: 'duancuoiky',
    databaseURL: 'https://duancuoiky-default-rtdb.firebaseio.com',
    storageBucket: 'duancuoiky.firebasestorage.app',
    iosBundleId: 'com.example.duancuoiky',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKBS9vtEju7IcC1jni0KVclk2_NoYxcX8',
    appId: '1:450589154874:ios:a5a6a526d0a8ed3e069f03',
    messagingSenderId: '450589154874',
    projectId: 'duancuoiky',
    databaseURL: 'https://duancuoiky-default-rtdb.firebaseio.com',
    storageBucket: 'duancuoiky.firebasestorage.app',
    iosBundleId: 'com.example.duancuoiky',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCLARQXQYA2pMhg5v33Y1_qjawyg29d8H0',
    appId: '1:450589154874:web:c2a7c4895403cf07069f03',
    messagingSenderId: '450589154874',
    projectId: 'duancuoiky',
    authDomain: 'duancuoiky.firebaseapp.com',
    databaseURL: 'https://duancuoiky-default-rtdb.firebaseio.com',
    storageBucket: 'duancuoiky.firebasestorage.app',
    measurementId: 'G-09B75EWFEX',
  );
}
