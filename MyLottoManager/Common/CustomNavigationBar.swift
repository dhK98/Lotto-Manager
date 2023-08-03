import UIKit

class CustomNavigationBar {
    
    private weak var viewController: UIViewController?
    private let titleFontSize = 20
    private let cancelButtonTitle = "취소"
    let title: String?
    
    init(_ viewController: UIViewController, title: String) {
        self.viewController = viewController
        self.title = title
    }
    
    @objc func popTopControllerView(){
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
    func configureNavigationBar(){
        let customTitleLabel: UILabel = UILabel()
        customTitleLabel.text = self.title
        customTitleLabel.font = UIFont.systemFont(ofSize: CGFloat(self.titleFontSize), weight: .bold)
        
        let leftButton: UIButton = {
            let button: UIButton = UIButton()
            button.setTitle(self.cancelButtonTitle, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            button.backgroundColor = .systemTeal
            button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
            button.layer.cornerRadius = 6
            return button
        }()
        
        leftButton.addTarget(self, action: #selector(self.popTopControllerView), for: .touchUpInside)
        
        UIView.performWithoutAnimation {
            self.viewController?.navigationItem.titleView = customTitleLabel
            self.viewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
            self.viewController?.navigationItem.leftBarButtonItem?.width = 80
        }
    }
}
