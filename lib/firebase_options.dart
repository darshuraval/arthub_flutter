// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        // You can add iOS config here later
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for iOS.');
      case TargetPlatform.macOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for macOS.');
      case TargetPlatform.windows:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for Windows.');
      case TargetPlatform.linux:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for Linux.');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD0ZgNd0ngfM1PIEurUBKHId0vizNBjb0M',
    appId: '1:319340216446:web:a1b3f413627b914e90982f',
    messagingSenderId: '319340216446',
    projectId: 'arthub-d3e9c',
    authDomain: 'arthub-d3e9c.firebaseapp.com',
    databaseURL: 'https://arthub-d3e9c-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'arthub-d3e9c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0ZgNd0ngfM1PIEurUBKHId0vizNBjb0M',
    appId: '1:319340216446:android:a1b3f413627b914e90982f',
    messagingSenderId: '319340216446',
    projectId: 'arthub-d3e9c',
    databaseURL: 'https://arthub-d3e9c-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'arthub-d3e9c.appspot.com',
  );
}
