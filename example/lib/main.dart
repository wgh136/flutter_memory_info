import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_memory_info/flutter_memory_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? _totalPhysicalMemorySize;
  int? _freePhysicalMemorySize;
  int? _totalVirtualMemorySize;
  int? _freeVirtualMemorySize;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    int? totalPhysicalMemorySize;
    int? freePhysicalMemorySize;
    int? totalVirtualMemorySize;
    int? freeVirtualMemorySize;

    try {
      totalPhysicalMemorySize = await MemoryInfo.getTotalPhysicalMemorySize();
      freePhysicalMemorySize = await MemoryInfo.getFreePhysicalMemorySize();
      if (Platform.isWindows || Platform.isLinux) {
        totalVirtualMemorySize = await MemoryInfo.getTotalVirtualMemorySize();
        freeVirtualMemorySize = await MemoryInfo.getFreeVirtualMemorySize();
      }
    } on Exception {
      totalPhysicalMemorySize = -1;
      freePhysicalMemorySize = -1;
      totalVirtualMemorySize = -1;
      freeVirtualMemorySize = -1;
    }

    if (!mounted) return;

    setState(() {
      _totalPhysicalMemorySize = totalPhysicalMemorySize;
      _freePhysicalMemorySize = freePhysicalMemorySize;
      _totalVirtualMemorySize = totalVirtualMemorySize;
      _freeVirtualMemorySize = freeVirtualMemorySize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Total Physical Memory Size: $_totalPhysicalMemorySize\n'),
              Text('Free Physical Memory Size: $_freePhysicalMemorySize\n'),
              Text('Total Virtual Memory Size: $_totalVirtualMemorySize\n'),
              Text('Free Virtual Memory Size: $_freeVirtualMemorySize\n'),
            ],
          ),
        ),
      ),
    );
  }
}
