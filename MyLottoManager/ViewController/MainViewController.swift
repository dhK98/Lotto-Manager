import UIKit

class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        print("first view didload")
        
        let label: UILabel = {
            let label = UILabel()
            label.text = "테스트"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10)
        ])
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("second view didload")
    }
}

class ThirdViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("thrid view didload")
    }
}


class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotification()
        setTabbar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTabBarHeight()
    }
    
    @objc func notificationButtonTapped() {
        // 알림 아이콘 버튼이 탭되었을 때 실행할 동작
        // 예: 알림 화면을 표시하거나 다른 알림 관련 동작 수행
        print("notification tapped")
    }
    
    func setTabbar(){
        self.tabBar.backgroundColor = .white
        
        self.tabBar.tintColor = .systemTeal
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.masksToBounds = true
        self.tabBar.unselectedItemTintColor = .systemGray5
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor  //테두리 색
        self.tabBar.layer.borderWidth = 0.4 //tabbar 테두리 굵
        
        let firstVC = FirstViewController()
        let secondVC = SecondViewController()
        let thridVC = ThirdViewController()
        
        let firstNavController = UINavigationController(rootViewController: firstVC)
        let secondNavController = UINavigationController(rootViewController: secondVC)
        let thridNavController = UINavigationController(rootViewController: thridVC)
        
        firstVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        firstVC.tabBarItem.image = UIImage(systemName: "house")
        firstVC.tabBarItem.title = "홈"
        
        secondVC.tabBarItem.selectedImage = UIImage(systemName: "pencil.circle.fill")
        secondVC.tabBarItem.image = UIImage(systemName: "pencil.circle")
        secondVC.tabBarItem.title = "로또"
        
        thridVC.tabBarItem.selectedImage = UIImage(systemName: "pencil.circle.fill")
        thridVC.tabBarItem.image = UIImage(systemName: "pencil.circle")
        thridVC.tabBarItem.title = "전체"
        
//        viewControllers = [firstNavController, secondNavController]
        setViewControllers([firstNavController, secondVC], animated: true)
    }
    
    func setTabBarHeight(){
        var tabFrame = self.tabBar.frame
           tabFrame.size.height = 88
           tabFrame.origin.y = self.view.frame.size.height - 88
           self.tabBar.frame = tabFrame
    }
    
    func setNotification(){
        let notificationIcon = UIImage(systemName: "bell.fill")
        let notificationButton = UIBarButtonItem(image: notificationIcon, style: .plain, target: self, action: #selector(notificationButtonTapped))
        
        // 네비게이션 바 오른쪽에 아이템 추가
        navigationItem.rightBarButtonItem = notificationButton
    }
}

