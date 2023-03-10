
import 'dart:async';

import 'package:flutter/services.dart';

class Updater {
  static const MethodChannel _channel = MethodChannel('updater');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
