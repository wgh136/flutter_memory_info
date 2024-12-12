import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_memory_info/flutter_memory_info_platform_interface.dart';
import 'package:flutter_memory_info/flutter_memory_info_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMemoryInfoPlatform
    with MockPlatformInterfaceMixin
    implements FlutterMemoryInfoPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMemoryInfoPlatform initialPlatform = FlutterMemoryInfoPlatform.instance;

  test('$MethodChannelFlutterMemoryInfo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMemoryInfo>());
  });

  test('getPlatformVersion', () async {
    FlutterMemoryInfo flutterMemoryInfoPlugin = FlutterMemoryInfo();
    MockFlutterMemoryInfoPlatform fakePlatform = MockFlutterMemoryInfoPlatform();
    FlutterMemoryInfoPlatform.instance = fakePlatform;

    expect(await flutterMemoryInfoPlugin.getPlatformVersion(), '42');
  });
}
