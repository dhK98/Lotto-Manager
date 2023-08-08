import UIKit

class SignupViewController: UIViewController {
    
    private var emailLabel: UILabel?
    private var emailTextField: UITextField?
    private var emailGuideLabel: UILabel?
    private var passwordLabel: UILabel?
    private var passwordTextField: UITextField?
    private var passwordGuideLabel: UILabel?
    private var passwordCheckLabel: UILabel?
    private var passwordCheckTextField: UITextField?
    private var passwordCheckGuideLabel: UILabel?
    private var nameLabel: UILabel?
    private var nameTextField: UITextField?
    private var nameGuideLabel: UILabel?
    private var phonenumberLabel: UILabel?
    private var phonenumberTextField: UITextField?
    private var requestAuthButton: UIButton?
    private var phonenumberGuideLabel: UILabel?
    private var authnumberTextField: UITextField?
    private var checkAuthnumberButton: UIButton?
    private var signupButton: UIButton?
    private var authnumberGuideLabel: UILabel?
    
    private var emailValidation = false
    private var passwordValidation = false
    private var passwordCheckValidation = false
    private var nameValidation = false
    private var phonenumberValidation = false
    private var authnumberValidation = false
    
    private var isAuth: Bool?
    
    let labelFontSize = 17
    let guideFontSize = 14
    let trailing = -50
    let leading = 50
    
    private let authCaller = APICaller<ResponseModel>()
    private let signupCaller = APICaller<SignupModel>()
    
    private let validator = Validator()
    
    private var customNavigationBar: CustomNavigationBar?
    
    private var keyboardAdjustments: KeyboardAdjustments?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.isAuth = false
        
        customNavigationBar = CustomNavigationBar(self,title: "회원가입")
        customNavigationBar?.configureNavigationBar()
        
        darwSingupView()
        
        setTextFieldDelegate()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        keyboardAdjustments = KeyboardAdjustments(view: self.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        self.signupButton?.addTarget(self, action: #selector(signup), for: .touchUpInside)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardAdjustments!.keyboardWillShow(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardAdjustments!.keyboardWillHide(notification)
    }
    func setTextFieldDelegate(){
        self.emailTextField?.delegate = self
        self.passwordTextField?.delegate = self
        self.passwordCheckTextField?.delegate = self
        self.nameTextField?.delegate = self
        self.phonenumberTextField?.delegate = self
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func darwSingupView(){
        createEmailLabel()
        createEmailTextField()
        createEmailGuideLabel()
        createPasswordLabel()
        createPasswordTextField()
        createPasswordGuideLabel()
        createPasswordCheckLabel()
        createPasswordCheckTextField()
        createPasswordCheckGuideLabel()
        createNameLabel()
        createNameTextField()
        createNameGuideLabel()
        createPhonenumberLabel()
        createPhonenumberTextFieldAndButton()
        createPhonenumberGuideLabel()
        createSignupButton()
    }
    
    
    func isEnableSignupButton(){
        if self.emailValidation && self.passwordValidation && self.passwordCheckValidation && self.nameValidation && self.isAuth!{
            self.signupButton?.isEnabled = true
        } else {
            self.signupButton?.isEnabled = false
        }
    }
    
    func validatePhonenumber(){
        if let phonenumber: String = self.phonenumberTextField!.text {
            phonenumberValidation = self.validator.validatePhonenumber(phonenumber: phonenumber)
        }
        if !phonenumberValidation {
            self.phonenumberGuideLabel?.isHidden = false
            self.requestAuthButton?.isEnabled = false
        } else {
            self.phonenumberGuideLabel?.isHidden = true
            self.requestAuthButton?.isEnabled = true
        }
    }
    
    func validateAuthnumber(){
        guard let authnumber = self.authnumberTextField?.text else {return}
        authnumberValidation = self.validator.isNumericSixDigit(authnumber)
        if !authnumberValidation {
            self.authnumberGuideLabel?.isHidden = false
            self.checkAuthnumberButton?.isEnabled = false
        } else {
            self.authnumberGuideLabel?.isHidden = true
            self.checkAuthnumberButton?.isEnabled = true
        }
    }
    
    @objc func checkAuth(_ sender: UIButton){
        self.validateAuthnumber()
        if !authnumberValidation || isAuth! {
            return
        }
        
        guard let phonenumber = phonenumberTextField?.text else {return}
        guard let authnumber = authnumberTextField?.text else {return}
        
        let parameters: [String: AnyHashable] = [
            "phonenumber": phonenumber as AnyHashable,
            "authnumber": authnumber as AnyHashable,
            "type": AuthType.SIGNUP.authTypeDescription as AnyHashable,
        ]
        
        self.authCaller.callAPI(endpoint: AppConfig.phoneAuthCheck, method: .post, parameters: parameters, isAuth: false ){result in
            
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.createNotificationAlert(self, title: "잠시후 다시 시도해주세요.",message: error.localizedDescription)
                }
                break
            case .success(let res):
                DispatchQueue.main.async {
                    if res.message{
                        self.isAuth = true
                        self.authnumberTextField?.removeFromSuperview()
                        self.checkAuthnumberButton?.removeFromSuperview()
                        self.authnumberGuideLabel?.removeFromSuperview()
                        self.authnumberTextField = nil
                        self.checkAuthnumberButton = nil
                        self.authnumberGuideLabel = nil
                        self.requestAuthButton?.setTitle("인증완료", for: .normal)
                        self.isEnableSignupButton()
                    }else {
                        Alert.createNotificationAlert(self, title: "인증번호가 다릅니다.")
                    }
                }
                break
            }
        }
        
    }
    
    @objc func signup(_ sender:UIButton){
        // call signup API
        let parameters: [String:AnyHashable] = [
            "email":self.emailTextField!.text as AnyHashable,
            "password":self.passwordTextField!.text as AnyHashable,
            "name":self.nameTextField!.text as AnyHashable,
            "phonenumber":self.phonenumberTextField!.text as AnyHashable,
        ]
        self.signupCaller.callAPI(endpoint: AppConfig.signupURL, method: .post, parameters: parameters, isAuth: false){ result in
            switch result {
            case .failure(let error):
                switch error {
                case let .invalidStatusCode(statusCode, message):
                    if statusCode == 409 {
                        if message == "already exist account" {
                            DispatchQueue.main.async {
                                Alert.createNotificationAlert(self, title: "이미 가입되어 있는 이메일입니다.", message: error.localizedDescription)
                            }
                            return
                        } else if message == "already exist name" {
                            DispatchQueue.main.async {
                                Alert.createNotificationAlert(self, title: "이미 존재하는 이름 입니다.", message: error.localizedDescription)
                            }
                            return
                        } else if message == "already exist phonenumber"{
                            DispatchQueue.main.async {
                                Alert.createNotificationAlert(self, title: "이미 가입되어 있는 휴대폰번호입니다.", message: error.localizedDescription)
                                self.phonenumberTextField?.isEnabled = true
                                self.phonenumberTextField?.backgroundColor = .white
                                self.isAuth = false
                                self.requestAuthButton?.setTitle("인증", for: .normal)
                            }
                            return
                        }
                    } else {
                        DispatchQueue.main.async {
                            Alert.createNotificationAlert(self, title: "네트워크 상태를 확인해주세요.", message: error.localizedDescription)
                        }
                        return
                    }
                default:
                    DispatchQueue.main.async {
                        Alert.createNotificationAlert(self, title: "네트워크 상태를 확인해주세요.", message: error.localizedDescription)
                    }
                    return
                }
                
            case .success(let model):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "\(model.name)님 회원가입을 환영합니다. 로그인을 해주세요.", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "확인", style: .default){_ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(alertAction)
                    self.present(alert, animated: true)
                }
                break
            }
        }
    }
}

// MARK: - View
extension SignupViewController {
    
    @objc func requestAuth(_ sender: UIButton){
        validatePhonenumber()
        if !self.phonenumberValidation {
            return
        }
        // phonenumberTextField 편집 불가 상태 전환
        self.phonenumberTextField?.isEnabled = false
        self.phonenumberTextField?.backgroundColor = .systemGray6
        
        guard let phonenumber = phonenumberTextField?.text else {return}
        
        let parameters: [String: AnyHashable] = [
            "phonenumber": phonenumber as AnyHashable,
            "type": AuthType.SIGNUP.authTypeDescription as AnyHashable,
        ]
        
        self.authCaller.callAPI(endpoint: AppConfig.phoneAuthRequest, method: .post, parameters: parameters, isAuth: false) { result in
            switch result {
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
                DispatchQueue.main.async {
                    Alert.createNotificationAlert(self, title: "인증번호가 전송되었습니다.")
                }
                break
            }
            
            // self.authnumberTextField 이 존재한다면, 인증요청만, 아니라면 인증번호 입력창 생성
            guard let isAuth = self.isAuth else {return}
            if self.authnumberTextField == nil && self.checkAuthnumberButton == nil && !isAuth {
                DispatchQueue.main.async {
                    let authnumberTextField: UITextField = {
                        let textField: UITextField = UITextField()
                        textField.placeholder = "인증번호를 입력해주세요."
                        textField.layer.borderWidth = 1
                        textField.layer.cornerRadius = 6
                        textField.layer.borderColor = UIColor.gray.cgColor
                        textField.addLeftPadding()
                        textField.keyboardType = .numberPad
                        return textField
                    }()
                    
                    let checkAuthnumberButton: UIButton = {
                        let button: UIButton = UIButton()
                        button.setTitle("확인", for: .normal)
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
                        button.backgroundColor = .systemTeal
                        button.layer.cornerRadius = 6
                        return button
                    }()
                    
                    let authnumberGuideLabel: UILabel = {
                        let label:UILabel = UILabel()
                        label.text = "6자리, 숫자만 입력해주세요."
                        label.font = UIFont.systemFont(ofSize: CGFloat(self.guideFontSize), weight: .light)
                        label.textColor = .red
                        return label
                    }()
                    
                    self.view.addSubview(authnumberTextField)
                    self.view.addSubview(checkAuthnumberButton)
                    self.view.addSubview(authnumberGuideLabel)
                    
                    authnumberTextField.translatesAutoresizingMaskIntoConstraints = false
                    checkAuthnumberButton.translatesAutoresizingMaskIntoConstraints = false
                    authnumberGuideLabel.translatesAutoresizingMaskIntoConstraints = false
                    
                    guard let phonenumberGuideLabel = self.phonenumberGuideLabel else {return}
                    
                    NSLayoutConstraint.activate([
                        checkAuthnumberButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
                        checkAuthnumberButton.topAnchor.constraint(equalTo: phonenumberGuideLabel.bottomAnchor, constant: 5),
                        checkAuthnumberButton.heightAnchor.constraint(equalToConstant: 40),
                        checkAuthnumberButton.widthAnchor.constraint(equalToConstant: 60),
                        authnumberTextField.topAnchor.constraint(equalTo: phonenumberGuideLabel.bottomAnchor, constant: 5),
                        authnumberTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
                        authnumberTextField.trailingAnchor.constraint(equalTo: checkAuthnumberButton.leadingAnchor, constant: -5),
                        authnumberTextField.heightAnchor.constraint(equalToConstant: 40),
                        authnumberGuideLabel.topAnchor.constraint(equalTo: authnumberTextField.bottomAnchor, constant: 4),
                        authnumberGuideLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
                        authnumberGuideLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
                    ])
                    
                    authnumberGuideLabel.isHidden = true
                    
                    self.phonenumberGuideLabel = phonenumberGuideLabel
                    self.authnumberTextField = authnumberTextField
                    self.checkAuthnumberButton = checkAuthnumberButton
                    self.authnumberGuideLabel = authnumberGuideLabel
                    self.checkAuthnumberButton?.addTarget(self, action: #selector(self.checkAuth), for: .touchUpInside)
                    self.authnumberTextField?.delegate = self
                }
            }
        }
    }
    
    func createEmailLabel(){
        let emailLabel: UILabel = {
            let label: UILabel = UILabel()
            label.text = "이메일"
            label.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize), weight: .light)
            return label
        }()
        
        let starLabel: UILabel = {
            let label:UILabel = UILabel()
            label.text = "*"
            label.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize), weight: .light)
            label.textColor = .red
            return label
        }()
        
        self.view.addSubview(emailLabel)
        self.view.addSubview(starLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            starLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            starLabel.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 2),
        ])
        
        self.emailLabel = emailLabel
    }
    
    func createEmailTextField(){
        let emailTextField: UITextField = {
            let textField: UITextField = UITextField()
            textField.placeholder = "이메일을 설정해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.autocorrectionType = .no
            textField.addLeftPadding()
            textField.keyboardType = .emailAddress
            return textField
        }()
        
        self.view.addSubview(emailTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        guard let emailLabel = self.emailLabel else {return}
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.emailTextField = emailTextField
    }
    
    func createEmailGuideLabel(){
        let emailGuideLabel: UILabel = {
            let label:UILabel = UILabel()
            label.text = "이메일 형식으로 입력해주세요."
            label.font = UIFont.systemFont(ofSize: CGFloat(guideFontSize), weight: .light)
            label.textColor = .red
            return label
        }()
        
        self.view.addSubview(emailGuideLabel)
        
        emailGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let emailTextField = self.emailTextField else { return }
        
        NSLayoutConstraint.activate([
            emailGuideLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 4),
            emailGuideLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            emailGuideLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
        ])
        
        emailGuideLabel.isHidden = true
        
        self.emailGuideLabel = emailGuideLabel
    }
    
    func createPasswordLabel(){
        let passwordLabel: UILabel = {
            let label: UILabel = UILabel()
            label.text = "패스워드"
            label.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize), weight: .light)
            return label
        }()
        
        let starLabel: UILabel = {
            let label:UILabel = UILabel()
            label.text = "*"
            label.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize), weight: .light)
            label.textColor = .red
            return label
        }()
        
        self.view.addSubview(passwordLabel)
        self.view.addSubview(starLabel)
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let emailGuideLabel = self.emailGuideLabel else {return}
        
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: emailGuideLabel.bottomAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            starLabel.topAnchor.constraint(equalTo: emailGuideLabel.bottomAnchor, constant: 10),
            starLabel.leadingAnchor.constraint(equalTo: passwordLabel.trailingAnchor, constant: 2),
        ])
        
        self.passwordLabel = passwordLabel
    }
    
    func createPasswordTextField(){
        let passwordTextField: UITextField = {
            let textField: UITextField = UITextField()
            textField.placeholder = "패스워드를 입력해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.addLeftPadding()
            textField.isSecureTextEntry = true
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            }
            return textField
        }()
        
        self.view.addSubview(passwordTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        guard let passwordLabel = self.passwordLabel else {return}
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.passwordTextField = passwordTextField
    }
    
    func createPasswordGuideLabel(){
        let passwordGuideLabel: UILabel = {
            let label:UILabel = UILabel()
            label.text = "8자리 이상, 숫자 영어 특수문자를 포함시켜주세요."
            label.font = UIFont.systemFont(ofSize: CGFloat(guideFontSize), weight: .light)
            label.textColor = .red
            return label
        }()
        
        self.view.addSubview(passwordGuideLabel)
        
        passwordGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let passwordTextField = self.passwordTextField else { return }
        
        NSLayoutConstraint.activate([
            passwordGuideLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4),
            passwordGuideLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            passwordGuideLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
        ])
        
        passwordGuideLabel.isHidden = true
        
        self.passwordGuideLabel = passwordGuideLabel
    }
    
    func createPasswordCheckLabel(){
        let passwordCheckLabel: UILabel = {
            let label: UILabel = UILabel()
            label.text = "패스워드 확인"
            label.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize), weight: .light)
            return label
        }()
        
        let starLabel: UILabel = {
            let label:UILabel = UILabel()
            label.text = "*"
            label.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize), weight: .light)
            label.textColor = .red
            return label
        }()
        
        self.view.addSubview(passwordCheckLabel)
        self.view.addSubview(starLabel)
        
        passwordCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let passwordGuideLabel = self.passwordGuideLabel else {return}
        
        NSLayoutConstraint.activate([
            passwordCheckLabel.topAnchor.constraint(equalTo: passwordGuideLabel.bottomAnchor, constant: 10),
            passwordCheckLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            starLabel.topAnchor.constraint(equalTo: passwordGuideLabel.bottomAnchor, constant: 10),
            starLabel.leadingAnchor.constraint(equalTo: passwordCheckLabel.trailingAnchor, constant: 2),
        ])
        
        self.passwordCheckLabel = passwordCheckLabel
    }
    
    func createPasswordCheckTextField(){
        let passwordCheckTextField: UITextField = {
            let textField: UITextField = UITextField()
            textField.placeholder = "패스워드를 다시 입력해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.addLeftPadding()
            textField.isSecureTextEntry = true
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            }
            return textField
        }()
        
        self.view.addSubview(passwordCheckTextField)
        
        passwordCheckTextField.translatesAutoresizingMaskIntoConstraints = false
        
        guard let passwordCheckLabel = self.passwordCheckLabel else {return}
        
        NSLayoutConstraint.activate([
            passwordCheckTextField.topAnchor.constraint(equalTo: passwordCheckLabel.bottomAnchor, constant: 10),
            passwordCheckTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            passwordCheckTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            passwordCheckTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.passwordCheckTextField = passwordCheckTextField
    }
    
    func createPasswordCheckGuideLabel(){
        let passwordCheckGuideLabel: UILabel = {
            let label:UILabel = UILabel()
            label.text = "비밀번호와 동일하게 입력해주세요."
            label.font = UIFont.systemFont(ofSize: CGFloat(guideFontSize), weight: .light)
            label.textColor = .red
            return label
        }()
        
        self.view.addSubview(passwordCheckGuideLabel)
        
        passwordCheckGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let passwordCheckTextField = self.passwordCheckTextField else { return }
        
        NSLayoutConstraint.activate([
            passwordCheckGuideLabel.topAnchor.constraint(equalTo: passwordCheckTextField.bottomAnchor, constant: 4),
            passwordCheckGuideLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            passwordCheckGuideLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
        ])
        
        passwordCheckGuideLabel.isHidden = true
        
        self.passwordCheckGuideLabel = passwordCheckGuideLabel
    }
    
    func createNameLabel(){
        let nameLabel: UILabel = {
            let label: UILabel = UILabel()
            label.text = "어플리케이션 사용자 이름"
            label.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize), weight: .light)
            return label
        }()
        
        let starLabel: UILabel = {
            let label:UILabel = UILabel()
            label.text = "*"
            label.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize), weight: .light)
            label.textColor = .red
            return label
        }()
        
        self.view.addSubview(nameLabel)
        self.view.addSubview(starLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let passwordCheckGuideLabel = self.passwordCheckGuideLabel else {return}
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: passwordCheckGuideLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            starLabel.topAnchor.constraint(equalTo: passwordCheckGuideLabel.bottomAnchor, constant: 10),
            starLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 2),
        ])
        
        self.nameLabel = nameLabel
    }
    
    func createNameTextField(){
        let nameTextField: UITextField = {
            let textField: UITextField = UITextField()
            textField.placeholder = "사용할 이름을 입력해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.addLeftPadding()
            return textField
        }()
        
        self.view.addSubview(nameTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        guard let nameLabel = self.nameLabel else {return}
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.nameTextField = nameTextField
    }
    
    func createNameGuideLabel(){
        let nameGuideLabel: UILabel = {
            let label:UILabel = UILabel()
            label.text = "영어 숫자 한글을 사용하여 입력해주세요."
            label.font = UIFont.systemFont(ofSize: CGFloat(guideFontSize), weight: .light)
            label.textColor = .red
            return label
        }()
        
        self.view.addSubview(nameGuideLabel)
        
        nameGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let nameTextField = self.nameTextField else { return }
        
        NSLayoutConstraint.activate([
            nameGuideLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 4),
            nameGuideLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            nameGuideLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
        ])
        
        nameGuideLabel.isHidden = true
        
        self.nameGuideLabel = nameGuideLabel
    }
    
    func createPhonenumberLabel(){
        let phonenumberLabel: UILabel = {
            let label: UILabel = UILabel()
            label.text = "휴대폰번호"
            label.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize), weight: .light)
            return label
        }()
        
        let starLabel: UILabel = {
            let label:UILabel = UILabel()
            label.text = "*"
            label.font = UIFont.systemFont(ofSize: CGFloat(labelFontSize), weight: .light)
            label.textColor = .red
            return label
        }()
        
        self.view.addSubview(phonenumberLabel)
        self.view.addSubview(starLabel)
        
        phonenumberLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let nameGuideLabel = self.nameGuideLabel else {return}
        
        NSLayoutConstraint.activate([
            phonenumberLabel.topAnchor.constraint(equalTo: nameGuideLabel.bottomAnchor, constant: 10),
            phonenumberLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            starLabel.topAnchor.constraint(equalTo: nameGuideLabel.bottomAnchor, constant: 10),
            starLabel.leadingAnchor.constraint(equalTo: phonenumberLabel.trailingAnchor, constant: 2),
        ])
        
        self.phonenumberLabel = phonenumberLabel
    }
    
    func createPhonenumberTextFieldAndButton(){
        let phonenumberTextField: UITextField = {
            let textField: UITextField = UITextField()
            textField.placeholder = "휴대폰번호를 입력해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.addLeftPadding()
            textField.keyboardType = .numberPad
            return textField
        }()
        
        let requestAuthButton: UIButton = {
            let button: UIButton = UIButton()
            button.setTitle("인증번호", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            button.backgroundColor = .systemTeal
            button.layer.cornerRadius = 6
            return button
        }()
        
        self.view.addSubview(phonenumberTextField)
        self.view.addSubview(requestAuthButton)
        
        phonenumberTextField.translatesAutoresizingMaskIntoConstraints = false
        requestAuthButton.translatesAutoresizingMaskIntoConstraints = false
        
        guard let phonenumberLabel = self.phonenumberLabel else {return}
        
        NSLayoutConstraint.activate([
            requestAuthButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            requestAuthButton.topAnchor.constraint(equalTo: phonenumberLabel.bottomAnchor, constant: 10),
            requestAuthButton.heightAnchor.constraint(equalToConstant: 40),
            requestAuthButton.widthAnchor.constraint(equalToConstant: 60),
            phonenumberTextField.topAnchor.constraint(equalTo: phonenumberLabel.bottomAnchor, constant: 10),
            phonenumberTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            phonenumberTextField.trailingAnchor.constraint(equalTo: requestAuthButton.leadingAnchor, constant: -5),
            phonenumberTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        requestAuthButton.addTarget(self, action: #selector(requestAuth(_:)), for: .touchUpInside)
        
        self.phonenumberTextField = phonenumberTextField
        self.requestAuthButton = requestAuthButton
    }
    
    func createPhonenumberGuideLabel(){
        let phonenumberGuideLabel: UILabel = {
            let label:UILabel = UILabel()
            label.text = "휴대폰 번호는 \'-\'를 제외하고 입력해주세요."
            label.font = UIFont.systemFont(ofSize: CGFloat(guideFontSize), weight: .light)
            label.textColor = .red
            return label
        }()
        
        self.view.addSubview(phonenumberGuideLabel)
        
        phonenumberGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let phonenumberTextField = self.phonenumberTextField else { return }
        
        NSLayoutConstraint.activate([
            phonenumberGuideLabel.topAnchor.constraint(equalTo: phonenumberTextField.bottomAnchor, constant: 4),
            phonenumberGuideLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            phonenumberGuideLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
        ])
        
        phonenumberGuideLabel.isHidden = true
        
        self.phonenumberGuideLabel = phonenumberGuideLabel
    }
    
    func createSignupButton(){
        let signupButton: UIButton = {
            let button: UIButton = UIButton()
            button.backgroundColor = UIColor.systemTeal
            button.setTitle("회원가입", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            button.isEnabled = false
            return button
        }()
        
        self.view.addSubview(signupButton)
        
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signupButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            signupButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        self.signupButton = signupButton
    }
    
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.systemTeal.cgColor
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray.cgColor
        if textField == self.emailTextField{
            if let email: String = self.emailTextField!.text {
                emailValidation = self.validator.validateEmail(email: email)
            }
            if !emailValidation {
                self.emailGuideLabel?.isHidden = false
            } else {
                self.emailGuideLabel?.isHidden = true
            }
        } else if textField == self.passwordTextField {
            if let password: String = self.passwordTextField!.text {
                passwordValidation = self.validator.validatePassword(password: password)
            }
            if !passwordValidation {
                self.passwordGuideLabel?.isHidden = false
            } else {
                self.passwordGuideLabel?.isHidden = true
            }
            
            if !self.passwordCheckTextField!.text!.isEmpty && !self.isSameTextBothTextField(self.passwordTextField!, self.passwordCheckTextField!) {
                passwordCheckValidation = false
            } else {
                passwordCheckValidation = true
            }
            
            if !passwordCheckValidation {
                self.passwordCheckGuideLabel?.isHidden = false
            } else {
                self.passwordCheckGuideLabel?.isHidden = true
            }
            
        } else if textField == self.passwordCheckTextField {
            passwordCheckValidation = isSameTextBothTextField(self.passwordTextField!, self.passwordCheckTextField!)
            
            if !passwordCheckValidation {
                self.passwordCheckGuideLabel?.isHidden = false
            } else {
                self.passwordCheckGuideLabel?.isHidden = true
            }
            
        } else if textField == self.nameTextField {
            if let name: String = self.nameTextField!.text {
                nameValidation = self.validator.validateName(name: name)
            }
            
            if !nameValidation {
                self.nameGuideLabel?.isHidden = false
            } else {
                self.nameGuideLabel?.isHidden = true
            }
            
        } else if textField == self.phonenumberTextField {
            validatePhonenumber()
            
        } else if textField == self.authnumberTextField {
            self.validateAuthnumber()
        }
        self.isEnableSignupButton()
        
    }
    
    func isSameTextBothTextField(_ first: UITextField, _ second: UITextField) -> Bool{
        if first.text == second.text && !(first.text?.isEmpty ?? false) {
            return true
        }
        return false
    }
}

