import Flutter
import UIKit
import Foundation


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
    case "getFreePhysicalMemorySize":
      result(getFreePhysicalMemory())
    case "getTotalVirtualMemorySize":
      result(getTotalVirtualMemorySize())
    case "getFreeVirtualMemorySize":
      result(getFreeVirtualMemory())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func getTotalPhysicalMemorySize() -> Int64 {
      let (used,tot)=MemoryInfo.getMemoryUsage()
    return Int64(tot)
  }
  
  private func getFreePhysicalMemory() -> Int64 {
      let (used,tot)=MemoryInfo.getMemoryUsage()
    
      return Int64(tot-used)
  }
  
  private func getTotalVirtualMemorySize() -> Int64 {
      return 0
  }
  
  private func getFreeVirtualMemory() -> Int64 {
    return 0
  }
}


class MemoryInfo {
    static func getMemoryUsage() -> (used: UInt64, total: UInt64) {
        var pageSize: vm_size_t = 0
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size/MemoryLayout<natural_t>.size)
        
        host_page_size(mach_host_self(), &pageSize)
        
        let kerr = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMem = UInt64(info.resident_size)
            
            var hostInfo = host_basic_info()
            var hostCount = UInt32(MemoryLayout<host_basic_info>.size / MemoryLayout<integer_t>.size)
            
            let hostResult = withUnsafeMutablePointer(to: &hostInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                    host_info(mach_host_self(),
                             HOST_BASIC_INFO,
                             $0,
                             &hostCount)
                }
            }
            
            if hostResult == KERN_SUCCESS {
                let totalMem = UInt64(hostInfo.max_mem)
                return (usedMem, totalMem)
            }
        }
        
        return (0, 0)
    }
}