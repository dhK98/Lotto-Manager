import UIKit

class FindUserViewController: UIViewController {
    
    private var customNavigationBar: CustomNavigationBar?
    
    private let guideTitleFontSize = 17
    private let guideContentFontSize = 17
    private let customerServiceInfoSize = 15
    private let segmentedControlLeft = 16
    private let segmentedControlRight = -16
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["이메일 찾기","패스워드 찾기"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private var findEmailView: UIView?
    
    private var findPasswordView: UIView?
    
    private var shouldHideFirstView: Bool? {
        didSet {
            guard let shouldHideFirstView = self.shouldHideFirstView,let findEmailView = self.findEmailView, let findPasswordView = self.findPasswordView else { return }
            findEmailView.isHidden = shouldHideFirstView
            findPasswordView.isHidden = findEmailView.isHidden
        }
    }
    
    let returnButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = UIColor.systemTeal
        button.setTitle("돌아가기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var topGuideTitleText: String? {
        didSet {
            topGuideTitleLabel?.text = topGuideTitleText
        }
    }
    private var topGuideContentText: String? {
        didSet {
            topGuideContentLabel?.text = topGuideContentText
        }
    }
    private var topGuideTitleLabel: UILabel?
    private var topGuideContentLabel: UILabel?
    private var topGuideStack: UIStackView?
    
    private var bottomGuideStack: UIStackView?
    
    private var emailAuthLabel: UILabel?
    private var emailPhonenumberTextField: UITextField?
    private var emailRequestAuthButton: UIButton?
    private var emailAuthnumberTextField: UITextField?
    private var emailCheckAuthButton: UIButton?
    private var emailAuthGuideLabel: UILabel?
    
    private var passwordAuthLabel: UILabel?
    private var passwordPhonenumberTextField: UITextField?
    private var passwordRequestAuthButton: UIButton?
    private var passwordAuthnumberTextField: UITextField?
    private var passwordCheckAuthButton: UIButton?
    private var passwordAuthGuideLabel: UILabel?
    
    private var phonenumberTextField: UITextField?
    private var requestAuthButton: UIButton?
    private var authnumberTextField: UITextField?
    private var checkAuthButton: UIButton?
    private var authGuideLabel: UILabel?
    
    private var emailRequestAuthStackView: UIStackView?
    private var emailCheckAuthStackView: UIStackView?
    private var passwordRequestAuthStackView: UIStackView?
    private var passwordCheckAuthStackView: UIStackView?
    
    private var emailTextField: UITextField?
    private var passwordTextField: UITextField?
    private var passwordCheckTextField: UITextField?
    private var changePasswordButton: UIButton?
    
    private var keyboardAdjustments: KeyboardAdjustments?
    
    private let validator = Validator()
    
    private var isAuth = false
    private var isValidatePhonenumber = false
    private var isValidateAuthnumber = false
    private var isValidateEmail = false
    private var isValidatePassword = false
    private var isValidateCheckPassword = false
    
    private let authCaller = APICaller<ResponseModel>()
    private let findEmailCaller = APICaller<FindEmailModel>()
    
    private var phonenumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        customNavigationBar = CustomNavigationBar(self, title: "계정 찾기")
        customNavigationBar?.configureNavigationBar()
        createReturnButton()
        settingSegmentedControl()
        setTopGuideStack()
        setbottomGuideStack()
        keyboardAdjustments = KeyboardAdjustments(view: self.view)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(segment: self.segmentedControl)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardAdjustments!.keyboardWillShow(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardAdjustments!.keyboardWillHide(notification)
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func settingSegmentedControl(){
        self.view.addSubview(self.segmentedControl)
        
        NSLayoutConstraint.activate([
            self.segmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.segmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            self.segmentedControl.heightAnchor.constraint(equalToConstant: 50),
        ])
        self.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideFirstView = segment.selectedSegmentIndex != 0
        isAuth = false
        isValidatePhonenumber = false
        isValidateAuthnumber = false
        isValidateEmail = false
        isValidatePassword = false
        isValidateCheckPassword = false
        phonenumber = nil
        if !self.shouldHideFirstView! {
            let findEmailView: UIView = {
                let view = UIView()
                view.backgroundColor = .white
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            self.findEmailView = findEmailView
            setFindEmailView()
            topGuideTitleText = "이메일 찾기"
            topGuideContentText = "휴대폰 번호 인증시, 가입된 이메일을 문자로 전송합니다."
            emailRequestAuthButton?.addTarget(self, action: #selector(requestEmailAuth), for: .touchUpInside)
            emailCheckAuthButton?.addTarget(self, action: #selector(checkAuthEmail), for: .touchUpInside)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            findEmailView.addGestureRecognizer(tapRecognizer)
            self.authGuideLabel = emailAuthGuideLabel
            self.phonenumberTextField = emailPhonenumberTextField
            self.authnumberTextField = emailAuthnumberTextField
            self.requestAuthButton = emailRequestAuthButton
            self.checkAuthButton = emailCheckAuthButton
            emailTextField = nil
            passwordTextField = nil
            passwordCheckTextField = nil
        } else {
            let findPasswordView: UIView = {
                let view = UIView()
                view.backgroundColor = .white
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            self.findPasswordView = findPasswordView
            setFindPasswordView()
            topGuideTitleText = "패스워드 찾기"
            topGuideContentText = "이메일 입력 후 휴대폰 번호 인증시, 패스워드 변경이 가능합니다."
            passwordRequestAuthButton?.addTarget(self, action: #selector(requestPasswordAuth), for: .touchUpInside)
            passwordCheckAuthButton?.addTarget(self, action: #selector(checkAuthPassword), for: .touchUpInside)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            findPasswordView.addGestureRecognizer(tapRecognizer)
            self.authGuideLabel = passwordAuthGuideLabel
            self.phonenumberTextField = passwordPhonenumberTextField
            self.authnumberTextField = passwordAuthnumberTextField
            self.requestAuthButton = passwordRequestAuthButton
            self.checkAuthButton = passwordCheckAuthButton
        }
    }
    
    func createReturnButton(){
        self.view.addSubview(returnButton)
        
        NSLayoutConstraint.activate([
            self.returnButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            self.returnButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.returnButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.returnButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        returnButton.addTarget(self, action: #selector(popTopViewController), for: .touchUpInside)
    }
    
    @objc func popTopViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setTopGuideStack(){
        let topGuideTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: CGFloat(guideTitleFontSize),weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.topGuideTitleLabel = topGuideTitleLabel
        
        let topGuideContentLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: CGFloat(guideContentFontSize))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.topGuideContentLabel = topGuideContentLabel
        
        let topGuideStack: UIStackView = {
            let stack = UIStackView()
            stack.addArrangedSubview(topGuideTitleLabel)
            stack.addArrangedSubview(topGuideContentLabel)
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
        
        self.view.addSubview(topGuideStack)
        
        NSLayoutConstraint.activate([
            topGuideStack.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 12),
            topGuideStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: CGFloat(segmentedControlLeft)),
            topGuideStack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: CGFloat(segmentedControlRight))
        ])
        
        self.topGuideStack = topGuideStack
    }
    
    func setbottomGuideStack(){
        let bottomGuideTitleLabel: UILabel = {
            let label = UILabel()
            label.text = "고객센터"
            label.font = UIFont.systemFont(ofSize: CGFloat(guideTitleFontSize),weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let bottomGuideContentLabel: UILabel = {
            let label = UILabel()
            label.text = "가입하신 휴대폰 번호가 변경될시, 000-0000-0000로 문의를 주시거나\n카카오톡 OOO 채널을 추가 후 문의를 주세요."
            label.font = UIFont.systemFont(ofSize: CGFloat(guideContentFontSize))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let customerServiceInfoLabel: UILabel = {
            let label = UILabel()
            label.text = "고객센터: 000-0000-0000\n부산광역시, 수영구 OO로 OOO-OO\n상담은 공휴일,토요일제외 10 ~ 17시까지 가능합니다."
            label.font = UIFont.systemFont(ofSize: CGFloat(customerServiceInfoSize))
            label.lineBreakMode = .byCharWrapping
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let bottomGuideStack: UIStackView = {
            let stack = UIStackView()
            stack.addArrangedSubview(bottomGuideTitleLabel)
            stack.addArrangedSubview(bottomGuideContentLabel)
            stack.addArrangedSubview(customerServiceInfoLabel)
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.alignment = .leading
            stack.distribution = .equalSpacing
            stack.spacing = 8
            stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layer.borderWidth = 2.0
            stack.layer.borderColor = UIColor.systemGray5.cgColor
            stack.layer.cornerRadius = 8
            return stack
        }()
        
        self.view.addSubview(bottomGuideStack)
        
        NSLayoutConstraint.activate([
            bottomGuideStack.bottomAnchor.constraint(equalTo: self.returnButton.topAnchor, constant: -30),
            bottomGuideStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: CGFloat(segmentedControlLeft)),
            bottomGuideStack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: CGFloat(segmentedControlRight))
        ])
        
        self.bottomGuideStack = bottomGuideStack
    }
    
    func setFindEmailView(){
        guard let findEmailView = self.findEmailView else {return}
        
        self.view.addSubview(findEmailView)
        
        guard let topGuideStack = self.topGuideStack, let bottomGuideStack = self.bottomGuideStack else {return}
        
        NSLayoutConstraint.activate([
            findEmailView.topAnchor.constraint(equalTo: topGuideStack.bottomAnchor, constant: 10),
            findEmailView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: CGFloat(segmentedControlLeft)),
            findEmailView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: CGFloat(segmentedControlRight)),
            findEmailView.bottomAnchor.constraint(equalTo: bottomGuideStack.topAnchor, constant: -10)
        ])
        
        (self.emailAuthLabel ,self.emailPhonenumberTextField, self.emailRequestAuthButton, self.emailAuthnumberTextField, self.emailCheckAuthButton, self.emailAuthGuideLabel, self.emailRequestAuthStackView, self.emailCheckAuthStackView) = createAuthComponents(findEmailView)
    }
    
    func setFindPasswordView(){
        guard let findPasswordView = self.findPasswordView else {return}
        self.view.addSubview(findPasswordView)
        
        guard let topGuideStack = self.topGuideStack, let bottomGuideStack = self.bottomGuideStack else {return}
        
        NSLayoutConstraint.activate([
            findPasswordView.topAnchor.constraint(equalTo: topGuideStack.bottomAnchor, constant: 10),
            findPasswordView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: CGFloat(segmentedControlLeft)),
            findPasswordView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: CGFloat(segmentedControlRight)),
            findPasswordView.bottomAnchor.constraint(equalTo: bottomGuideStack.topAnchor, constant: -10)
        ])
        
        (self.passwordAuthLabel ,self.passwordPhonenumberTextField, self.passwordRequestAuthButton, self.passwordAuthnumberTextField, self.passwordCheckAuthButton, self.passwordAuthGuideLabel, self.passwordRequestAuthStackView, self.passwordCheckAuthStackView) = createAuthComponents(findPasswordView)
    }
    
    func createAuthComponents(_ view: UIView) -> (UILabel, UITextField, UIButton, UITextField, UIButton, UILabel, UIStackView, UIStackView){
        let authLabel: UILabel = {
            let label = UILabel()
            label.text = "휴대폰 인증"
            label.font = UIFont.systemFont(ofSize: CGFloat(guideContentFontSize), weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let phonenumberTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "휴대폰 번호를 입력해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.addLeftPadding()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.delegate = self
            return textField
        }()
        
        let requestAuthButton: UIButton = {
            let button = UIButton()
            button.setTitle("인증", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            button.backgroundColor = .systemTeal
            button.layer.cornerRadius = 6
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let requestAuthStackView: UIStackView = {
            let stack = UIStackView()
            stack.addArrangedSubview(phonenumberTextField)
            stack.addArrangedSubview(requestAuthButton)
            stack.spacing = 8
            stack.axis = .horizontal
            stack.alignment = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fill
            return stack
        }()
        
        let authnumberTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "인증요청을 먼저 시도해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.addLeftPadding()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.delegate = self
            textField.isEnabled = false
            return textField
        }()
        
        let checkAuthButton: UIButton = {
            let button = UIButton()
            button.setTitle("확인", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            button.backgroundColor = .systemTeal
            button.layer.cornerRadius = 6
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let checkAuthStackView: UIStackView = {
            let stack = UIStackView()
            stack.addArrangedSubview(authnumberTextField)
            stack.addArrangedSubview(checkAuthButton)
            stack.spacing = 8
            stack.axis = .horizontal
            stack.alignment = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fill
            return stack
        }()
        
        let authGuideLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = .red
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        
        view.addSubview(authLabel)
        view.addSubview(requestAuthStackView)
        view.addSubview(checkAuthStackView)
        view.addSubview(authGuideLabel)
        
        
        NSLayoutConstraint.activate([
            authLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            authLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(segmentedControlLeft)),
            authLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(segmentedControlRight))
        ])
        
        
        NSLayoutConstraint.activate([
            requestAuthStackView.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: 15),
            requestAuthStackView.leftAnchor.constraint(equalTo: authLabel.leftAnchor),
            requestAuthStackView.rightAnchor.constraint(equalTo: authLabel.rightAnchor),
            requestAuthButton.heightAnchor.constraint(equalToConstant: 40),
            requestAuthButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            checkAuthStackView.topAnchor.constraint(equalTo: requestAuthStackView.bottomAnchor, constant: 15),
            checkAuthStackView.leftAnchor.constraint(equalTo: requestAuthStackView.leftAnchor),
            checkAuthStackView.rightAnchor.constraint(equalTo: requestAuthStackView.rightAnchor),
            checkAuthButton.heightAnchor.constraint(equalToConstant: 40),
            checkAuthButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            authGuideLabel.topAnchor.constraint(equalTo: checkAuthStackView.bottomAnchor, constant: 5),
            authGuideLabel.leftAnchor.constraint(equalTo: checkAuthStackView.leftAnchor, constant: 5),
            authGuideLabel.rightAnchor.constraint(equalTo: checkAuthStackView.rightAnchor),
        ])
        
        return (authLabel, phonenumberTextField, requestAuthButton, authnumberTextField, checkAuthButton, authGuideLabel, requestAuthStackView, checkAuthStackView)
    }
    
}

// MARK: - method
extension FindUserViewController {
    func requestAuth(type: AuthType){
        guard let phonenumber = self.phonenumberTextField?.text else {return}
        isValidatePhonenumber = validator.validatePhonenumber(phonenumber: phonenumberTextField?.text ?? "")
        if !isValidatePhonenumber {
            return
        }
        self.phonenumberTextField?.isEnabled = false
        self.phonenumberTextField?.backgroundColor = .systemGray6
        
        let parameters: [String: AnyHashable] = [
            "phonenumber": phonenumber as AnyHashable,
            "type": type.authTypeDescription as AnyHashable
        ]
        authCaller.callAPI(endpoint: AppConfig.phoneAuthRequest, method: .post, parameters: parameters){ result in
            switch result{
            case .failure(let error):
                switch error {
                case let .invalidStatusCode(statusCode, _):
                    //                    print("statusCode: \(statusCode)")
                    //                    print("message: \(message)")
                    if statusCode == 400 {
                        print("인증 타입 오류")
                    }
                    return
                default:
                    print("default error: \(error)")
                    return
                }
                
            case .success(_):
                self.phonenumber = phonenumber
                DispatchQueue.main.async {
                    Alert.createNotificationAlert(self, title: "인증번호가 전송되었습니다.")
                    self.authnumberTextField?.isEnabled = true
                }
                break
            }
        }
    }
    @objc func requestEmailAuth() {
        requestAuth(type: .FINDEMAIL)
    }
    
    @objc func requestPasswordAuth() {
        requestAuth(type: .FINDPASSWORD)
    }
    
    func checkAuth(type: AuthType ,next: @escaping () -> Void){
        guard let authnumber = self.authnumberTextField?.text else {return}
        isValidateAuthnumber = validator.isNumericSixDigit(authnumber)
        if !isValidateAuthnumber {
            return
        }
        let parameters: [String: AnyHashable] = [
            "phonenumber": self.phonenumber as AnyHashable,
            "authnumber": authnumber as AnyHashable,
            "type": type.authTypeDescription as AnyHashable
        ]
        authCaller.callAPI(endpoint: AppConfig.phoneAuthCheck, method: .post, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
                return
            case .success(let res):
                if res.message{
                    self.isAuth = true
                    next()
                } else {
                    DispatchQueue.main.async {
                        self.authGuideLabel?.text = "인증번호가 다릅니다."
                    }
                }
                break
            }
        }
    }
    
    @objc func checkAuthEmail(){
        checkAuth(type: .FINDEMAIL) {
            guard let phonennumber = self.phonenumber else {return}
            let parameter: [String: AnyHashable] = [
                "phonenumber": phonennumber as AnyHashable
            ]
            self.findEmailCaller.callAPI(endpoint: AppConfig.findEmail, method: .post, parameters: parameter){ result in
                switch result{
                case .failure(let error):
                    switch error {
                    case let .invalidStatusCode(statusCode, _):
                        if statusCode == 404{
                            DispatchQueue.main.async {
                                Alert.createNotificationAlert(self, title: "해당 번호로 가입된 계정이 존재하지 않습니다.")
                                self.authnumberTextField?.text = ""
                                self.authnumberTextField?.isEnabled = false
                                self.phonenumberTextField?.isEnabled = true
                                self.phonenumberTextField?.backgroundColor = .white
                            }
                            
                        } else {
                            print("invalidStatusCode: \(error)")
                        }
                    default:
                        print("error: \(error)")
                    }
                    return
                case .success(let model):
                    DispatchQueue.main.async { [self] in
                        self.emailRequestAuthStackView?.removeFromSuperview()
                        self.emailCheckAuthStackView?.removeFromSuperview()
                        self.emailAuthGuideLabel?.removeFromSuperview()
                        self.emailAuthLabel?.removeFromSuperview()
                        // memory optimization
                        self.emailAuthGuideLabel = nil
                        self.emailPhonenumberTextField = nil
                        self.emailAuthnumberTextField = nil
                        self.emailCheckAuthButton = nil
                        self.emailRequestAuthButton = nil
                        self.emailCheckAuthStackView = nil
                        self.emailRequestAuthStackView = nil
                        self.emailAuthGuideLabel = nil
                        self.emailAuthLabel = nil
                        
                        let emailTitleLabel: UILabel = {
                            let label = UILabel()
                            label.font = UIFont.systemFont(ofSize: CGFloat(guideTitleFontSize), weight: .bold)
                            label.text = "가입된 이메일"
                            label.translatesAutoresizingMaskIntoConstraints = false
                            return label
                        }()
                        
                        let emailContentLabel: UILabel = {
                           let label = UILabel()
                            label.text = "\(phonennumber) 번호로 가입된 이메일은\n\"\(model.email)\" 입니다."
                            label.font = UIFont.systemFont(ofSize: CGFloat(self.guideContentFontSize))
                            label.lineBreakMode = .byWordWrapping
                            label.numberOfLines = 0
                            label.textAlignment = .center
                            label.translatesAutoresizingMaskIntoConstraints = false
                            return label
                        }()
                        
                        guard let findEmailView = self.findEmailView else {return}
                        
                        findEmailView.addSubview(emailTitleLabel)
                        findEmailView.addSubview(emailContentLabel)
                        
                        NSLayoutConstraint.activate([
                            emailTitleLabel.topAnchor.constraint(equalTo: findEmailView.topAnchor, constant: 15),
                            emailTitleLabel.leftAnchor.constraint(equalTo: findEmailView.leftAnchor, constant: CGFloat(self.segmentedControlLeft)),
                            emailTitleLabel.rightAnchor.constraint(equalTo: findEmailView.rightAnchor, constant: CGFloat(self.segmentedControlRight))
                        ])
                        
                        NSLayoutConstraint.activate([
                            emailContentLabel.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 60),
                            emailContentLabel.leftAnchor.constraint(equalTo: emailTitleLabel.leftAnchor),
                            emailContentLabel.rightAnchor.constraint(equalTo: emailTitleLabel.rightAnchor)
                        ])
                        
                        findEmailView.layer.borderWidth = 2.0
                        findEmailView.layer.borderColor = UIColor.systemTeal.cgColor
                        findEmailView.layer.cornerRadius = 8
                    }
                }
            }
        }
    }
    
    @objc func checkAuthPassword(){
        checkAuth(type: .FINDPASSWORD) {
            DispatchQueue.main.async {
                self.passwordRequestAuthStackView?.removeFromSuperview()
                self.passwordCheckAuthStackView?.removeFromSuperview()
                self.passwordAuthGuideLabel?.removeFromSuperview()
                self.passwordAuthLabel?.removeFromSuperview()
                
                self.passwordAuthGuideLabel = nil
                self.passwordPhonenumberTextField = nil
                self.passwordAuthnumberTextField = nil
                self.passwordCheckAuthButton = nil
                self.passwordRequestAuthButton = nil
                self.passwordCheckAuthStackView = nil
                self.passwordRequestAuthStackView = nil
                self.passwordAuthGuideLabel = nil
                self.passwordAuthLabel = nil
                self.modifyPasswordView()
            }
        }
    }
    
    func modifyPasswordView(){
        let passwordLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: CGFloat(self.guideTitleFontSize), weight: .bold)
            label.text = "패스워드 변경"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let emailTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "이메일을 입력해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.addLeftPadding()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.delegate = self
            return textField
        }()
        
        let passwordTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "변경할 패스워드를 입력해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.addLeftPadding()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.delegate = self
            textField.isSecureTextEntry = true
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            }
            return textField
        }()
        
        let passwordCheckTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "입력한 패스워드와 동일하게 입력해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.addLeftPadding()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.delegate = self
            textField.isSecureTextEntry = true
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            }
            return textField
        }()
        
        let changePasswordButton: UIButton = {
            let button = UIButton()
            button.setTitle("변경", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            button.backgroundColor = .systemTeal
            button.layer.cornerRadius = 6
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        guard let findPasswordView = self.findPasswordView else {return}
        
        findPasswordView.addSubview(passwordLabel)
        findPasswordView.addSubview(emailTextField)
        findPasswordView.addSubview(passwordTextField)
        findPasswordView.addSubview(passwordCheckTextField)
        findPasswordView.addSubview(changePasswordButton)
        
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: findPasswordView.topAnchor, constant: 10),
            passwordLabel.rightAnchor.constraint(equalTo: findPasswordView.rightAnchor, constant: CGFloat(segmentedControlRight)),
            passwordLabel.leftAnchor.constraint(equalTo: findPasswordView.leftAnchor, constant: CGFloat(segmentedControlLeft))
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            emailTextField.rightAnchor.constraint(equalTo: passwordLabel.rightAnchor),
            emailTextField.leftAnchor.constraint(equalTo: passwordLabel.leftAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            passwordTextField.rightAnchor.constraint(equalTo: passwordLabel.rightAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: passwordLabel.leftAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            passwordCheckTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            passwordCheckTextField.rightAnchor.constraint(equalTo: passwordLabel.rightAnchor),
            passwordCheckTextField.leftAnchor.constraint(equalTo: passwordLabel.leftAnchor),
            passwordCheckTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            changePasswordButton.topAnchor.constraint(equalTo: passwordCheckTextField.bottomAnchor, constant: 8),
            changePasswordButton.rightAnchor.constraint(equalTo: passwordLabel.rightAnchor),
            changePasswordButton.leftAnchor.constraint(equalTo: passwordLabel.leftAnchor),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        findPasswordView.layer.borderWidth = 2.0
        findPasswordView.layer.borderColor = UIColor.systemGray5.cgColor
        findPasswordView.layer.cornerRadius = 8
        
        changePasswordButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        
        self.emailTextField = emailTextField
        self.passwordTextField = passwordTextField
        self.passwordCheckTextField = passwordCheckTextField
        self.changePasswordButton = changePasswordButton
    }
    
    @objc func changePassword(){
        if !isAuth {
            return
        }
        isValidateEmail = validator.validateEmail(email: emailTextField?.text ?? "")
        isValidatePassword = validator.validatePassword(password: passwordTextField?.text ?? "")
        isValidateCheckPassword = self.passwordCheckTextField?.text == self.passwordTextField?.text && !(self.passwordTextField?.text?.isEmpty ?? true)
        if !isValidateEmail {
            Alert.createNotificationAlert(self, title: "이메일을 올바르게 입력해주세요.")
            return
        }
        if !isValidatePassword {
            Alert.createNotificationAlert(self, title: "패스워드 형식")
            return
        }
        if !isValidateCheckPassword {
            Alert.createNotificationAlert(self, title: "패스워드 재입력란 확인")
            return
        }
        let parameters: [String: AnyHashable] = [
            "email":self.emailTextField?.text as AnyHashable,
            "password": self.passwordTextField?.text as AnyHashable,
            "phonenumber": self.phonenumber as AnyHashable
        ]
        authCaller.callAPI(endpoint: AppConfig.updatePassword, method: .post, parameters: parameters){ result in
            switch result {
            case .failure(let error):
                switch error{
                case let .invalidStatusCode(statusCode, _):
                    if statusCode == 404 {
                        DispatchQueue.main.async {
                            self.emailTextField?.text = ""
                            Alert.createNotificationAlert(self, title: "이메일이 존재하지 않습니다.")
                        }
                    } else {
                        print("error: \(error)")
                    }
                default:
                    print("error: \(error)")
                }
                return
            case .success( _):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "패스워드 변경이 완료되었습니다.", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "확인", style: .default){_ in
                        self.didChangeValue(segment: self.segmentedControl)
                    }
                    alert.addAction(alertAction)
                    self.present(alert, animated: true)
                }
                return
            }
        }
    }
}

extension FindUserViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.systemTeal.cgColor
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray.cgColor
        if textField === self.phonenumberTextField{
            guard let texfield = phonenumberTextField else {return}
            authnumberTextField?.isEnabled = false
            isValidatePhonenumber = validator.validatePhonenumber(phonenumber: texfield
                .text ?? "")
            if !isValidatePhonenumber{
                authGuideLabel?.text = "11자리, 숫자만 입력해주세요."
            } else {
                authGuideLabel?.text = nil
            }
        }
        else if textField === self.authnumberTextField {
            guard let textField = authnumberTextField else {return}
            isValidateAuthnumber = validator.isNumericSixDigit(textField.text ?? "")
            if !isValidateAuthnumber{
                authGuideLabel?.text = "6자리, 숫자만 입력해주세요."
            } else {
                authGuideLabel?.text = nil
            }
        } else if textField === self.emailTextField {
            isValidateEmail = validator.validateEmail(email: textField.text ?? "")
        } else if textField === self.passwordTextField {
            isValidatePassword = validator.validatePassword(password: textField.text ?? "")
        } else if textField === self.passwordCheckTextField{
            isValidateCheckPassword = textField.text == self.passwordTextField?.text && !(self.passwordTextField?.text?.isEmpty ?? true)
        }

    }
}
