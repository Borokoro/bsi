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
    apiKey: 'AIzaSyAxMsZ9t4foItbpHyb0TyPvMpTX3VK7V1g',
    appId: '1:292137054109:web:78f8dcf6dcb9b821b44974',
    messagingSenderId: '292137054109',
    projectId: 'bsii-947af',
    authDomain: 'bsii-947af.firebaseapp.com',
    storageBucket: 'bsii-947af.appspot.com',
    measurementId: 'G-RTE084SG5E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCeYnTRI86KCKqlkdyTcpJTCo6AEgUVrgw',
    appId: '1:292137054109:android:aa13fc85b8ac643cb44974',
    messagingSenderId: '292137054109',
    projectId: 'bsii-947af',
    storageBucket: 'bsii-947af.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMUi0dTCG4BgoOhHJaz0P-wuv5CTfaVLM',
    appId: '1:292137054109:ios:3fd7a9ae23d4ca56b44974',
    messagingSenderId: '292137054109',
    projectId: 'bsii-947af',
    storageBucket: 'bsii-947af.appspot.com',
    iosClientId: '292137054109-8t5ikpi8fkmiriqj0g4cu7onl1pi4hcv.apps.googleusercontent.com',
    iosBundleId: 'com.example.bsi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAMUi0dTCG4BgoOhHJaz0P-wuv5CTfaVLM',
    appId: '1:292137054109:ios:af39a370d0797276b44974',
    messagingSenderId: '292137054109',
    projectId: 'bsii-947af',
    storageBucket: 'bsii-947af.appspot.com',
    iosClientId: '292137054109-8duchmir980h4dgcku87u97boucr5s5q.apps.googleusercontent.com',
    iosBundleId: 'bsi.bsi',
  );
}
