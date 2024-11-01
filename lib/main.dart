import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vpn/vmess_config.dart';

import 'vpn_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LinkListScreen(),
    );
  }
}

class LinkListScreen extends StatelessWidget {

  List<String> linksList = [
   "vmess://eyJhZGQiOiAiMzcuMS4xOTQuMjAyIiwgImFpZCI6ICIwIiwgImhvc3QiOiAiZHJpdmUuZ29vZ2xlLmNvbSIsICJpZCI6ICJhMWQwY2NlMC03MmUwLTRmYzctOGRiNy0yMTQzNTg1NWVhYmIiLCAibmV0IjogInRjcCIsICJwYXRoIjogIi8iLCAicG9ydCI6IDgwODEsICJwcyI6ICJHZXJtYW55IFtWTWVzcyAtIHRjcF0iLCAic2N5IjogImF1dG8iLCAidGxzIjogIm5vbmUiLCAidHlwZSI6ICJodHRwIiwgInYiOiAiMiJ9",
   "vmess://eyJhZGQiOiAiMTkyLjE2OC4xLjEiLCAiYWlkIjogIjAiLCAiaG9zdCI6ICJ3d3cuZ29vZ2xlLmNvbSIsICJpZCI6ICJhMWQwY2NlMC03MmUwLTRmYzctOGRiNy0yMTQzNTg1NWVhYmIiLCAibmV0IjogInRjcCIsICJwYXRoIjogIi8iLCAicG9ydCI6IDgwODEsICJwcyI6ICJQb2xhbmQgW1ZNZXNzIC0gdGNwXSIsICJzY3kiOiAiYXV0byIsICJ0bHMiOiAibm9uZSIsICJ0eXBlIjogImh0dHAiLCAidiI6ICIyIn0=",
   "vmess://eyJhZGQiOiAiMzcuMS4xOTQuMjAyIiwgImFpZCI6ICIwIiwgImhvc3QiOiAiZ29vZ2xlLmNvbSIsICJpZCI6ICJhMWQwY2NlMC03MmUwLTRmYzctOGRiNy0yMTQzNTg1NWVhYmIiLCAibmV0IjogIndzIiwgInBhdGgiOiAiLyIsICJwb3J0IjogODA4MCwgInBzIjogIkdlcm1hbnkgW1ZNZXNzIC0gd3NdIiwgInNjeSI6ICJhdXRvIiwgInRscyI6ICJub25lIiwgInR5cGUiOiAiIiwgInYiOiAiMiJ9",
   "vmess://eyJhZGQiOiAiMTkyLjE2OC4xLjEiLCAiYWlkIjogIjAiLCAiaG9zdCI6ICJnb29nbGUuY29tIiwgImlkIjogImExZDBjY2UwLTcyZTAtNGZjNy04ZGI3LTIxNDM1ODU1ZWFiYiIsICJuZXQiOiAid3MiLCAicGF0aCI6ICIvIiwgInBvcnQiOiA4MDgwLCAicHMiOiAiUG9sYW5kIFtWTWVzcyAtIHdzXSIsICJzY3kiOiAiYXV0byIsICJ0bHMiOiAibm9uZSIsICJ0eXBlIjogIiIsICJ2IjogIjIifQ==",
   "vless://268d243d-9b41-49d1-b56d-07c8ebba7f6d@37.1.194.202:8443?security=reality&type=tcp&headerType=&path=&host=&sni=cdn.discordapp.com&fp=chrome&pbk=eOGwWtcwAX29_IoDGDW1D_vU7Pkj_QO66k1ofIccvhY&sid=c6fdec6b9b5b628f#Germany%20%5BVLESS%20-%20tcp%5D",
   "vless://268d243d-9b41-49d1-b56d-07c8ebba7f6d@192.168.1.1:8443?security=reality&type=tcp&headerType=&path=&host=&sni=cdn.discordapp.com&fp=chrome&pbk=eOGwWtcwAX29_IoDGDW1D_vU7Pkj_QO66k1ofIccvhY&sid=c6fdec6b9b5b628f#Poland%20%5BVLESS%20-%20tcp%5D",
   "vless://268d243d-9b41-49d1-b56d-07c8ebba7f6d@37.1.194.202:2053?security=reality&type=grpc&headerType=&serviceName=xyz&authority=&mode=gun&sni=cdn.discordapp.com&fp=chrome&pbk=eOGwWtcwAX29_IoDGDW1D_vU7Pkj_QO66k1ofIccvhY&sid=c6fdec6b9b5b628f#Germany%20%5BVLESS%20-%20grpc%5D",
   "vless://268d243d-9b41-49d1-b56d-07c8ebba7f6d@192.168.1.1:2053?security=reality&type=grpc&headerType=&serviceName=xyz&authority=&mode=gun&sni=cdn.discordapp.com&fp=chrome&pbk=eOGwWtcwAX29_IoDGDW1D_vU7Pkj_QO66k1ofIccvhY&sid=c6fdec6b9b5b628f#Poland%20%5BVLESS%20-%20grpc%5D",
   "ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNToyR04zZjVYNUh0ZE1sQjhFRk1zN3JB@37.1.194.202:1080#Germany%20%5BShadowsocks%20-%20tcp%5D",
   "ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNToyR04zZjVYNUh0ZE1sQjhFRk1zN3JB@192.168.1.1:1080#Poland%20%5BShadowsocks%20-%20tcp%5D",
  ];

  LinkListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    List<VmessConfig> vmessList = parseLinks(linksList);

    return Scaffold(
      appBar: AppBar(title: Text('Links')),
      body: vmessList.isNotEmpty
          ? ListView.builder(
        itemCount: vmessList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(vmessList[index].name),
            onTap: () {
              _connectToVPN(vmessList[index]);
            },
          );
        },
      )
          : Center(child: Text('No links available')),
    );
  }

  void _connectToVPN(VmessConfig vpnConfig) async {
    await VPNService.connectVPN(vpnConfig);
  }

  void _disconnectFromVPN() async {
    await VPNService.disconnectVPN();
  }

  List<VmessConfig> parseLinks(List<String> links) {
    List<VmessConfig> configs = [];
    for (var link in links) {
      if (link.startsWith('vmess://')) {
        try {
          var base64String = link.replaceFirst('vmess://', '');

          var decoded = utf8.decode(base64.decode(base64String));

          var jsonMap = json.decode(decoded);

          configs.add(VmessConfig(
            address: jsonMap['add'],
            host: jsonMap['host'],
            uuid: jsonMap['id'],
            port: jsonMap['port'],
            name: jsonMap['ps'],
          ));
        } catch (e) {
          print('Error parsing link: $link, Error: $e');
        }
      }
    }
    return configs;
  }
}
