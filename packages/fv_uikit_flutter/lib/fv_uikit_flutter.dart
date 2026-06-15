import 'fv_uikit_flutter_platform_interface.dart';
export 'src/ui/atoms/index.dart';
export 'src/ui/molecules/index.dart';
export 'src/core/tokens/index.dart';
export 'src/ui/organisms/index.dart';

class FvUikitFlutter {
  Future<String?> getPlatformVersion() {
    return FvUikitFlutterPlatform.instance.getPlatformVersion();
  }
}
