import Foundation

struct LoginModel: Decodable {
    let access_token: String
    let user: userInfo
}

struct userInfo: Decodable {
    let name: String
    let phonenumber: String
}
