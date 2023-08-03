import UIKit

class FindUserViewController: UIViewController {
    
    private var customNavigationBar: CustomNavigationBar?
    
    private let guideTitleFontSize = 20
    private let guideContentFontSize = 17
    private let segmentedControlLeft = 16
    private let segmentedControlRight = -16
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["이메일 찾기","패스워드 찾기"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let findEmailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let findPasswordView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var shouldHideFirstView: Bool? {
        didSet {
            guard let shouldHideFirstView = self.shouldHideFirstView else { return }
            self.findEmailView.isHidden = shouldHideFirstView
            self.findPasswordView.isHidden = !self.findEmailView.isHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        customNavigationBar = CustomNavigationBar(self, title: "계정 찾기")
        customNavigationBar?.configureNavigationBar()
        
        settingSegmentedControl()
    }
    
    func settingSegmentedControl(){
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.findEmailView)
        self.view.addSubview(self.findPasswordView)
        
        NSLayoutConstraint.activate([
            self.segmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.segmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            self.segmentedControl.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            self.findEmailView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.findEmailView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.findEmailView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.findEmailView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            self.findPasswordView.leftAnchor.constraint(equalTo: self.findEmailView.leftAnchor),
            self.findPasswordView.rightAnchor.constraint(equalTo: self.findEmailView.rightAnchor),
            self.findPasswordView.bottomAnchor.constraint(equalTo: self.findEmailView.bottomAnchor),
            self.findPasswordView.topAnchor.constraint(equalTo: self.findEmailView.topAnchor),
        ])
        
        settingFindEmailView()
        settingFindPasswordView()
        
        self.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        
        self.segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(segment: self.segmentedControl)
        
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideFirstView = segment.selectedSegmentIndex != 0
    }
    
    func settingFindEmailView(){
        let emailGuideTitleLabel: UILabel = {
            let label = UILabel()
            label.text = "이메일 찾기"
            label.font = UIFont.systemFont(ofSize: CGFloat(guideTitleFontSize),weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let emailGuideContentLabel: UILabel = {
            let label = UILabel()
            label.text = "휴대폰 번호 인증시, 가입된 이메일을 문자로 전송합니다."
            label.font = UIFont.systemFont(ofSize: CGFloat(guideContentFontSize))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let emailGuideStack: UIStackView = {
            let stack = UIStackView()
            stack.addArrangedSubview(emailGuideTitleLabel)
            stack.addArrangedSubview(emailGuideContentLabel)
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.alignment = .leading
            stack.distribution = .equalSpacing
            stack.spacing = 15
            stack.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layer.borderWidth = 2.0
            stack.layer.borderColor = UIColor.systemGray5.cgColor
            stack.layer.cornerRadius = 8
            return stack
        }()
        
        self.findEmailView.addSubview(emailGuideStack)
        
        
        
        NSLayoutConstraint.activate([
            emailGuideStack.topAnchor.constraint(equalTo: self.findEmailView.topAnchor, constant: 12),
            emailGuideStack.leftAnchor.constraint(equalTo: self.findEmailView.leftAnchor, constant: CGFloat(segmentedControlLeft)),
            emailGuideStack.rightAnchor.constraint(equalTo: self.findEmailView.rightAnchor, constant: CGFloat(segmentedControlRight))
        ])
        
    }
    
    func settingFindPasswordView(){
        let passwordGuideTitleLabel: UILabel = {
            let label = UILabel()
            label.text = "패스워드 찾기"
            label.font = UIFont.systemFont(ofSize: CGFloat(guideTitleFontSize), weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let passwordGuideContentLabel: UILabel = {
            let label = UILabel()
            label.text = "이메일 입력 후 휴대폰 번호 인증시, 패스워드 변경이 가능합니다."
            label.translatesAutoresizingMaskIntoConstraints = false
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: CGFloat(guideContentFontSize))
            return label
        }()
        
        let passwordGuideStack: UIStackView = {
            let stack = UIStackView()
            stack.addArrangedSubview(passwordGuideTitleLabel)
            stack.addArrangedSubview(passwordGuideContentLabel)
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.alignment = .leading
            stack.distribution = .equalSpacing
            stack.spacing = 15
            stack.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layer.borderWidth = 2.0
            stack.layer.borderColor = UIColor.systemGray5.cgColor
            stack.layer.cornerRadius = 8
            return stack
        }()
        
        self.findPasswordView.addSubview(passwordGuideStack)
        
        
        
        NSLayoutConstraint.activate([
            passwordGuideStack.topAnchor.constraint(equalTo: self.findPasswordView.topAnchor, constant: 12),
            passwordGuideStack.leftAnchor.constraint(equalTo: self.findPasswordView.leftAnchor, constant: CGFloat(segmentedControlLeft)),
            passwordGuideStack.rightAnchor.constraint(equalTo: self.findPasswordView.rightAnchor, constant: CGFloat(segmentedControlRight))
        ])
    }
    
}


