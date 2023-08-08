import Foundation

enum AuthType {
    case SIGNUP
    case FINDEMAIL
    case FINDPASSWORD
    
    var authTypeDescription: String? {
        switch self {
        case .SIGNUP:
            return "signup"
        case .FINDEMAIL:
            return "findemail"
        case .FINDPASSWORD:
            return "findpassword"
        }
    }
}
