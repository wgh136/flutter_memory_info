#ifndef FLUTTER_PLUGIN_FLUTTER_MEMORY_INFO_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_MEMORY_INFO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_memory_info {

class FlutterMemoryInfoPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterMemoryInfoPlugin();

  virtual ~FlutterMemoryInfoPlugin();

  // Disallow copy and assign.
  FlutterMemoryInfoPlugin(const FlutterMemoryInfoPlugin&) = delete;
  FlutterMemoryInfoPlugin& operator=(const FlutterMemoryInfoPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_memory_info

#endif  // FLUTTER_PLUGIN_FLUTTER_MEMORY_INFO_PLUGIN_H_
