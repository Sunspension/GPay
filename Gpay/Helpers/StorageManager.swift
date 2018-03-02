//
//  StorageManager.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 01/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import KeychainAccess

class StorageManager {
    
    private static let keychain = Keychain(service: "com.gpn.Gpay")
    
    static var auth: AuthResponse? {
        
        get {
            
            do {
                
                if let data = try keychain.getData("auth") {
                    
                    return try JSONDecoder().decode(AuthResponse.self, from: data)
                }
                
                return nil
            }
            catch {
                
                return nil
            }
        }
        
        set {
            
            if let auth = newValue {
                
                do {
                    
                    let data = try JSONEncoder().encode(auth)
                    try keychain.set(data, key: "auth")
                }
                catch { debugPrint("faild to save auth object") }
            }
        }
    }
}
