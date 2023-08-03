import Foundation

class Validator {
    func validateEmail(email: String) -> Bool{
        let emailRegEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEX)
        return emailTest.evaluate(with: email)
    }
    
    func validatePassword(password: String) -> Bool{
        let passwordRegEX = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEX)
        return passwordTest.evaluate(with: password)
    }
    
    func validateName(name: String) -> Bool{
        let nameRegEX = "^[ㄱ-ㅎ가-힣a-zA-Z0-9]+$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEX)
        return nameTest.evaluate(with: name)
    }
    
    func validatePhonenumber(phonenumber: String) -> Bool{
        let phonenumberRegEX = "^\\d{11}$"
        let phonenumberTest = NSPredicate(format: "SELF MATCHES %@", phonenumberRegEX)
        return phonenumberTest.evaluate(with: phonenumber)
    }
    
    func isNumericSixDigit(_ authnumber: String) -> Bool{
        let numericCharacterSet = CharacterSet.decimalDigits
        let inputCharacterSet = CharacterSet(charactersIn: authnumber)
        
        return inputCharacterSet.isSubset(of: numericCharacterSet) && authnumber.count == 6
    }

}
