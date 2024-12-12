#include "include/flutter_memory_info/flutter_memory_info_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include "flutter_memory_info_plugin_private.h"
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

using std::string;
using std::cerr;
using std::endl;
using std::stringstream;
using std::ifstream;

#define FLUTTER_MEMORY_INFO_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), flutter_memory_info_plugin_get_type(), \
                              FlutterMemoryInfoPlugin))

struct _FlutterMemoryInfoPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(FlutterMemoryInfoPlugin, flutter_memory_info_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void flutter_memory_info_plugin_handle_method_call(
    FlutterMemoryInfoPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;
  const gchar* method = fl_method_call_get_name(method_call);

  ifstream meminfo("/proc/meminfo");
  if (!meminfo.is_open()) {
    cerr << "Error: Unable to open /proc/meminfo" << endl;
    return;
  }
  string line;
  long totalMemory = 0, freeMemory = 0;
  long swapTotal = 0, swapFree = 0;

  while (getline(meminfo, line)) {
        stringstream ss(line);
        string key;
        long value;
        string unit;

        // Read the key and value from each line (key is the memory info name, value is in kB)
        ss >> key >> value >> unit;

        // Extract total memory
        if (key == "MemTotal:") {
            totalMemory = value;
        }

        // Extract free memory
        if (key == "MemFree:") {
            freeMemory = value;
        }

        // Extract swap memory information
        if (key == "SwapTotal:") {
            swapTotal = value;
        }

        if (key == "SwapFree:") {
            swapFree = value;
        }

        // If both values are found, stop reading
        if (totalMemory > 0 && freeMemory > 0 && swapTotal > 0 && swapFree > 0) {
            break;
        }
  }

  meminfo.close();

  if (strcmp(method, "getTotalPhysicalMemorySize") == 0) {
    g_autoptr(FlValue) result = fl_value_new_int((int64_t)totalMemory);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else if (strcmp(method, "getFreePhysicalMemorySize") == 0) {
    g_autoptr(FlValue) result = fl_value_new_int((int64_t)freeMemory);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else if (strcmp(method, "getTotalVirtualMemorySize") == 0) {
    g_autoptr(FlValue) result = fl_value_new_int((int64_t)swapTotal);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else if (strcmp(method, "getFreeVirtualMemorySize") == 0) {
    g_autoptr(FlValue) result = fl_value_new_int((int64_t)swapFree);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void flutter_memory_info_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(flutter_memory_info_plugin_parent_class)->dispose(object);
}

static void flutter_memory_info_plugin_class_init(FlutterMemoryInfoPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = flutter_memory_info_plugin_dispose;
}

static void flutter_memory_info_plugin_init(FlutterMemoryInfoPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  FlutterMemoryInfoPlugin* plugin = FLUTTER_MEMORY_INFO_PLUGIN(user_data);
  flutter_memory_info_plugin_handle_method_call(plugin, method_call);
}

void flutter_memory_info_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FlutterMemoryInfoPlugin* plugin = FLUTTER_MEMORY_INFO_PLUGIN(
      g_object_new(flutter_memory_info_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "flutter_memory_info",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
