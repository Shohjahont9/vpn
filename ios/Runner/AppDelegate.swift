import Flutter
import UIKit
import NetworkExtension

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let vpnChannel = FlutterMethodChannel(name: "com.yourapp/vpn",
                                              binaryMessenger: controller.binaryMessenger)
        
        vpnChannel.setMethodCallHandler { (call, result) in
            if call.method == "connectVPN" {
                if let args = call.arguments as? [String: Any] {
                    VPNManager.shared.connectVPN(vpnConfig: args) { error in
                        if let error = error {
                            result(FlutterError(code: "VPN_ERROR", message: error.localizedDescription, details: nil))
                        } else {
                            result(nil)
                        }
                    }
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments required to connect VPN", details: nil))
                }
            } else if call.method == "disconnectVPN" {
                VPNManager.shared.disconnectVPN { error in
                    if let error = error {
                        result(FlutterError(code: "VPN_ERROR", message: error.localizedDescription, details: nil))
                    } else {
                        result(nil)
                    }
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
