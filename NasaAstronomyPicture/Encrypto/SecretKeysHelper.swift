//
//  EnvironmentHelper.swift
//  Bonfire
//
//  Created by Prakashini Pattabiraman on 04/06/19.
//  Copyright © 2019 Prakashini Pattabiraman. All rights reserved.
//

import Foundation
import CryptoSwift

final class SecretKeysHelper {
    
    static let shared = SecretKeysHelper()
    var apiKey: String?
    var baseUrl: String?

    func decryptPlist() {
        var plistData: [String: AnyObject] = [:] //Our secure data
        do {
            if let path = Bundle.main.path(forResource: SecretKeysConstants.SECRET_KEYS_FILE_NAME, ofType: Constants.ENC_STRING)  {
                let data_enc = NSData.init(contentsOfFile: path)! as Data
                let aes = try AES(key: [UInt8](hex: String(Constants.ENV_HEX_CODE)), blockMode: ECB(), padding: .noPadding)
                let decryptedDta = try data_enc.decrypt(cipher: aes)
                var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
                plistData = try PropertyListSerialization.propertyList(from: decryptedDta, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]
            }
            if let data = plistData[NAPEnvironment.shared.environment.rawValue] as? [String : String] {
                apiKey = data["apiKey"]
                baseUrl = data["baseUrl"]
            }
            
        } catch {
            debugPrint("Secret Keys Helper :\(error)")
            
        }
    }
}
