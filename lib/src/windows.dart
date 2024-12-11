import 'package:win32/win32.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

int? getTotalPhysicalMemorySize() {
  final memoryStatus = calloc<MEMORYSTATUSEX>();
  memoryStatus.ref.dwLength = sizeOf<MEMORYSTATUSEX>();
  try {
    if (FAILED(GlobalMemoryStatusEx(memoryStatus))) {
      throw WindowsException(HRESULT_FROM_WIN32(GetLastError()));
    }
    final memorySize = memoryStatus.ref.ullTotalPhys;
    return memorySize;
  } finally {
    free(memoryStatus);
  }
}

int? getFreePhysicalMemorySize() {
  final memoryStatus = calloc<MEMORYSTATUSEX>();
  memoryStatus.ref.dwLength = sizeOf<MEMORYSTATUSEX>();
  try {
    if (FAILED(GlobalMemoryStatusEx(memoryStatus))) {
      throw WindowsException(HRESULT_FROM_WIN32(GetLastError()));
    }
    final memorySize = memoryStatus.ref.ullAvailPhys;
    return memorySize;
  } finally {
    free(memoryStatus);
  }
}

int? getTotalVirtualMemorySize() {
  final memoryStatus = calloc<MEMORYSTATUSEX>();
  memoryStatus.ref.dwLength = sizeOf<MEMORYSTATUSEX>();
  try {
    if (FAILED(GlobalMemoryStatusEx(memoryStatus))) {
      throw WindowsException(HRESULT_FROM_WIN32(GetLastError()));
    }
    final memorySize = memoryStatus.ref.ullTotalVirtual;
    return memorySize;
  } finally {
    free(memoryStatus);
  }
}

int? getFreeVirtualMemorySize() {
  final memoryStatus = calloc<MEMORYSTATUSEX>();
  memoryStatus.ref.dwLength = sizeOf<MEMORYSTATUSEX>();
  try {
    if (FAILED(GlobalMemoryStatusEx(memoryStatus))) {
      throw WindowsException(HRESULT_FROM_WIN32(GetLastError()));
    }
    final memorySize = memoryStatus.ref.ullAvailVirtual;
    return memorySize;
  } finally {
    free(memoryStatus);
  }
}
