import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter_platform_interface.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFvUikitFlutterPlatform
    with MockPlatformInterfaceMixin
    implements FvUikitFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FvUikitFlutterPlatform initialPlatform = FvUikitFlutterPlatform.instance;

  test('$MethodChannelFvUikitFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFvUikitFlutter>());
  });

  test('getPlatformVersion', () async {
    FvUikitFlutter fvUikitFlutterPlugin = FvUikitFlutter();
    MockFvUikitFlutterPlatform fakePlatform = MockFvUikitFlutterPlatform();
    FvUikitFlutterPlatform.instance = fakePlatform;

    expect(await fvUikitFlutterPlugin.getPlatformVersion(), '42');
  });
}
