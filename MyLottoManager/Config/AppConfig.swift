import Foundation

class AppConfig {
    // PC
    static let appURL = "http://localhost:8080"
    // mobile request hotspot network settings
//    static let appURL = "http://172.20.10.2:8080"
    // WiFI
//    static let appURL = "http://192.168.45.62:8080"
    static let loginURL = "/auth/login"
    static let phoneAuthRequest = "/auth/request"
    static let phoneAuthCheck = "/auth/check"
    static let signupURL = "/user"
    static let findEmail = "/user/email"
    static let updatePassword = "/user/password"
}
