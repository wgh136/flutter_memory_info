import 'dart:io';
import 'package:flutter/services.dart';
import 'src/windows.dart' as windows;

abstract class MemoryInfo {
  static const methodChannel = MethodChannel('flutter_memory_info');

  /// Get the total physical memory size in bytes.
  ///
  /// Support platforms: Android, iOS, macOS, Linux, Windows.
  static Future<int?> getTotalPhysicalMemorySize() async {
    if (Platform.isWindows) {
      return windows.getTotalPhysicalMemorySize();
    } else {
      return methodChannel.invokeMethod('getTotalPhysicalMemorySize');
    }
  }

  /// Get the free physical memory size in bytes.
  ///
  /// Support platforms: Android, iOS, macOS, Linux, Windows.
  static Future<int?> getFreePhysicalMemorySize() async {
    if (Platform.isWindows) {
      return windows.getFreePhysicalMemorySize();
    } else {
      return methodChannel.invokeMethod('getFreePhysicalMemorySize');
    }
  }

  /// Get the total virtual memory size in bytes.
  ///
  /// Support platforms: Windows, Linux.
  static Future<int?> getTotalVirtualMemorySize() async {
    if (Platform.isWindows) {
      return windows.getTotalVirtualMemorySize();
    } else {
      return methodChannel.invokeMethod('getTotalVirtualMemorySize');
    }
  }

  /// Get the free virtual memory size in bytes.
  ///
  /// Support platforms: Windows, Linux.
  static Future<int?> getFreeVirtualMemorySize() async {
    if (Platform.isWindows) {
      return windows.getFreeVirtualMemorySize();
    } else {
      return methodChannel.invokeMethod('getFreeVirtualMemorySize');
    }
  }
}
