import 'dart:convert';

class VmessConfig {
  final String address;
  final String host;
  final String uuid;
  final int port;
  final String name;

  VmessConfig({
    required this.address,
    required this.host,
    required this.uuid,
    required this.port,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'host': host,
      'uuid': uuid,
      'port': port,
      'name': name,
    };
  }

  static VmessConfig fromJson(Map<String, dynamic> json) {
    return VmessConfig(
      address: json['address'],
      host: json['host'],
      uuid: json['uuid'],
      port: json['port'],
      name: json['name'],
    );
  }
}