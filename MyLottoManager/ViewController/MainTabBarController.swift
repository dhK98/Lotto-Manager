import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTabbarHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setTabbar(){
        self.tabBar.backgroundColor = .white
        
        self.tabBar.tintColor = .systemTeal
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.masksToBounds = true
        self.tabBar.unselectedItemTintColor = .systemGray5
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor  //테두리 색
        self.tabBar.layer.borderWidth = 0.4
        
        let homeVC = HomeViewController()
        let lottoVC = LottoViewController()
        let settingVC = MySettingViewController()
        
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.tabBarItem.title = "홈"
        
        lottoVC.tabBarItem.selectedImage = UIImage(systemName: "pencil.circle.fill")
        lottoVC.tabBarItem.image = UIImage(systemName: "pencil.circle")
        lottoVC.tabBarItem.title = "로또"
        
        settingVC.tabBarItem.selectedImage = UIImage(systemName: "pencil.circle.fill")
        settingVC.tabBarItem.image = UIImage(systemName: "pencil.circle")
        settingVC.tabBarItem.title = "설정"
        
        setViewControllers([homeVC, lottoVC,settingVC], animated: true)
    }
    
    func setTabbarHeight(){
        let tabBarHeight: CGFloat = 88 // 원하는 높이
        tabBar.frame.size.height = tabBarHeight
        tabBar.frame.origin.y = view.frame.size.height - tabBarHeight
    }
}

