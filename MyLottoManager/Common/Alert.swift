import UIKit

class Alert {
    static func createNotificationAlert(_ view: UIViewController, title: String, message: String? = nil){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(alertAction)
        view.present(alert, animated: true)
    }
}
