import Foundation

class UserInfo {
    
    static let shared = UserInfo()
    
    private init(){}
    
    var email: String?
    var name: String?
    var phonenumber: String?
    
}
