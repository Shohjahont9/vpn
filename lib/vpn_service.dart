import 'package:flutter/services.dart';
import 'package:vpn/vmess_config.dart';

class VPNService {
  static const MethodChannel _channel = MethodChannel('com.yourapp/vpn');

  static Future<void> connectVPN(VmessConfig vpnConfig) async {
    try {
      // Construct VPN config for iOS or Android as necessary
      final Map<String, dynamic> vpnConfigMap = {
        'address': vpnConfig.address,
        'host': vpnConfig.host,
        'uuid': vpnConfig.uuid,
        'port': vpnConfig.port,
        'name': vpnConfig.name,
        // Add any other necessary fields required by your VPN implementation
      };
      await _channel.invokeMethod('connectVPN', vpnConfigMap);
    } on PlatformException catch (e) {
      print('Error connecting to VPN: ${e.message}');
    }
  }

  static Future<void> disconnectVPN() async {
    try {
      await _channel.invokeMethod('disconnectVPN');
    } on PlatformException catch (e) {
      print('Error disconnecting VPN: ${e.message}');
    }
  }
}