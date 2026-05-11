#include "include/fv_uikit_flutter/fv_uikit_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fv_uikit_flutter_plugin.h"

void FvUikitFlutterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fv_uikit_flutter::FvUikitFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
