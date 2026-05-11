import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fv_uikit_flutter_platform_interface.dart';

/// An implementation of [FvUikitFlutterPlatform] that uses method channels.
class MethodChannelFvUikitFlutter extends FvUikitFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fv_uikit_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
