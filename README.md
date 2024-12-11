# flutter_memory_info

A Flutter plugin for getting memory info.

## Usage

```dart
import 'package:flutter_memory_info/flutter_memory_info.dart';

void checkMemory() async {
    print('Total memory: ${await FlutterMemoryInfo.getTotalPhysicalMemorySize()}');
    print('Free memory: ${await FlutterMemoryInfo.getFreePhysicalMemorySize()}');
    print('Total virtual memory: ${await FlutterMemoryInfo.getTotalVirtualMemorySize()}');
    print('Free virtual memory: ${await FlutterMemoryInfo.getFreeVirtualMemorySize()}');
}
```