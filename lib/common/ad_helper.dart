import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  static String get projectListBannerId {
    if (kReleaseMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3766691232792823/9145792738'
          : 'ca-app-pub-3766691232792823/4532727908';
    } else {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
  }

  static String get projectDetailBannerId {
    if (kReleaseMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3766691232792823/4253618194'
          : 'ca-app-pub-3766691232792823/1090935677';
    } else {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
  }

  static String get homeBannerId {
    if (kReleaseMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3766691232792823/3341959766'
          : 'ca-app-pub-3766691232792823/4655041435';
    } else {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
  }

  static String get exitDialogBannerId {
    if (kReleaseMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3766691232792823/6277146303'
          : 'ca-app-pub-3766691232792823/8290768840'; // 사용 안함
    } else {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
  }
}
