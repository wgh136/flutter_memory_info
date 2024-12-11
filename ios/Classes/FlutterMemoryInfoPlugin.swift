import Flutter
import UIKit
import mach
import mach_host

public class FlutterMemoryInfoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_memory_info", binaryMessenger: registrar.messenger())
    let instance = FlutterMemoryInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getTotalPhysicalMemorySize":
      result(getTotalPhysicalMemorySize())
    case "getFreePhysicalMemory":
      result(getFreePhysicalMemory())
    case "getTotalVirtualMemorySize":
      result(getTotalVirtualMemorySize())
    case "getFreeVirtualMemory": 
      result(getFreeVirtualMemory())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func getTotalPhysicalMemorySize() -> Int64 {
    return Int64(ProcessInfo.processInfo.physicalMemory)
  }
  
  private func getFreePhysicalMemory() -> Int64 {
    var pageSize: vm_size_t = 0
    var vmStats = vm_statistics64()
    var size: mach_msg_type_number_t = UInt32(MemoryLayout<vm_statistics64_data_t>.stride / MemoryLayout<integer_t>.stride)
    
    let hostPort: mach_port_t = mach_host_self()
    let psErr: kern_return_t = host_page_size(hostPort, &pageSize)
    let vmErr: kern_return_t = host_statistics64(hostPort, HOST_VM_INFO64, &vmStats.withUnsafeMutableBytes { pointer -> UnsafeMutablePointer<integer_t> in
      return pointer.baseAddress!.assumingMemoryBound(to: integer_t.self)
    }, &size)
    
    if psErr == KERN_SUCCESS && vmErr == KERN_SUCCESS {
      let freeSize = Int64(vmStats.free_count) * Int64(pageSize)
      return freeSize
    }
    
    return 0
  }
  
  private func getTotalVirtualMemorySize() -> Int64 {
    var totalVirtualMemory: Int64 = 0
    var machHost = mach_host_self()
    var hostVMInfo = host_vm_info_data_t()
    var count = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
    
    let result = host_statistics(machHost, HOST_VM_INFO, &hostVMInfo.withUnsafeMutableBytes { pointer -> UnsafeMutablePointer<integer_t> in
      return pointer.baseAddress!.assumingMemoryBound(to: integer_t.self)
    }, &count)
    
    if result == KERN_SUCCESS {
      let pageSize = vm_kernel_page_size
      totalVirtualMemory = Int64(hostVMInfo.free_count + hostVMInfo.active_count + hostVMInfo.inactive_count + hostVMInfo.wire_count) * Int64(pageSize)
    }
    
    return totalVirtualMemory
  }
  
  private func getFreeVirtualMemory() -> Int64 {
    var machHost = mach_host_self()
    var hostVMInfo = host_vm_info_data_t()
    var count = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
    
    let result = host_statistics(machHost, HOST_VM_INFO, &hostVMInfo.withUnsafeMutableBytes { pointer -> UnsafeMutablePointer<integer_t> in
      return pointer.baseAddress!.assumingMemoryBound(to: integer_t.self)
    }, &count)
    
    if result == KERN_SUCCESS {
      let pageSize = vm_kernel_page_size
      return Int64(hostVMInfo.free_count) * Int64(pageSize)
    }
    
    return 0
  }
}