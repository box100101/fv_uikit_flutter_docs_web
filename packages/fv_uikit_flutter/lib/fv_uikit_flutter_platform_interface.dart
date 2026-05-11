import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fv_uikit_flutter_method_channel.dart';

abstract class FvUikitFlutterPlatform extends PlatformInterface {
  /// Constructs a FvUikitFlutterPlatform.
  FvUikitFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static FvUikitFlutterPlatform _instance = MethodChannelFvUikitFlutter();

  /// The default instance of [FvUikitFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelFvUikitFlutter].
  static FvUikitFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FvUikitFlutterPlatform] when
  /// they register themselves.
  static set instance(FvUikitFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
