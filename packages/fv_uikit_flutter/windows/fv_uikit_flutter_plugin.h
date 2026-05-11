#ifndef FLUTTER_PLUGIN_FV_UIKIT_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_FV_UIKIT_FLUTTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace fv_uikit_flutter {

class FvUikitFlutterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FvUikitFlutterPlugin();

  virtual ~FvUikitFlutterPlugin();

  // Disallow copy and assign.
  FvUikitFlutterPlugin(const FvUikitFlutterPlugin&) = delete;
  FvUikitFlutterPlugin& operator=(const FvUikitFlutterPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace fv_uikit_flutter

#endif  // FLUTTER_PLUGIN_FV_UIKIT_FLUTTER_PLUGIN_H_
