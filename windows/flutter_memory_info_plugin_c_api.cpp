#include "include/flutter_memory_info/flutter_memory_info_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_memory_info_plugin.h"

void FlutterMemoryInfoPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_memory_info::FlutterMemoryInfoPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
