import NetworkExtension

import NetworkExtension

@objc class VPNManager: NSObject {
    static let shared = VPNManager()

    func connectVPN(vpnConfig: [String: Any], completion: @escaping (Error?) -> Void) {
        let vpnManager = NEVPNManager.shared()
        
        vpnManager.loadFromPreferences { error in
            if let error = error {
                completion(error)
                return
            }
            
            let vpnProtocol = NEVPNProtocolIKEv2()
            vpnProtocol.serverAddress = vpnConfig["address"] as? String
            vpnProtocol.username = vpnConfig["username"] as? String
            
            if let passwordData = vpnConfig["password"] as? Data {
                vpnProtocol.passwordReference = passwordData
            }
            vpnProtocol.authenticationMethod = .sharedSecret
            
            guard let serverAddress = vpnProtocol.serverAddress, !serverAddress.isEmpty else {
                completion(NSError(domain: "VPNManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing server address"]))
                return
            }
            
            vpnManager.protocolConfiguration = vpnProtocol
            vpnManager.localizedDescription = "VPN Configuration"
            vpnManager.isEnabled = true
            
            do {
                vpnManager.saveToPreferences()
                try vpnManager.connection.startVPNTunnel()
                completion(nil)
            } catch let saveError {
                completion(saveError)
            }
        }
    }

    func disconnectVPN(completion: @escaping (Error?) -> Void) {
        let vpnManager = NEVPNManager.shared()
        vpnManager.connection.stopVPNTunnel()
        completion(nil)
    }
}
