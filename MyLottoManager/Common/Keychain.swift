import UIKit
import Security

class Keychain {
    static let shered = Keychain()
    
    static let passwordKey = "com.example.MyLottoManager.password"
    static let jwtAccessTokenKey = "com.example.MyLottoManager.AccessToken"
    static let jwtRefreshTokenKey = "com.example.MyLottoManager.RefreshToken"
    
    func transformData(data:String) -> Data{
        return data.data(using: String.Encoding.utf8)!
    }
    
    func save(data: String, key: String, account: String) -> Bool{
        // Creating query
        let _data = transformData(data: data)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecValueData as String: _data,
            kSecAttrService as String: key,
            kSecAttrAccount as String: account,
        ]
        // Adding Data to Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // Checking for status
        switch status {

        case errSecSuccess:
            // Success
            return true
        case errSecDuplicateItem:
            // Update Field
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: key,
                kSecAttrAccount as String: account,
            ]
            let updateAttr = [kSecValueData as String: _data] as CFDictionary
            let status = SecItemUpdate(updateQuery as CFDictionary, updateAttr)
            if status == errSecSuccess {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    func load(key: String, account: String) -> Data?{
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
        ]
        
        // To Copy the data
        var resultData: CFTypeRef?
        SecItemCopyMatching(query as CFDictionary, &resultData)
        
        return (resultData as? Data)
    }
    
    func delete(key: String, account: String) -> Bool{
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key,
            kSecAttrAccount as String: account,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {return false}
        return true
    }
}
