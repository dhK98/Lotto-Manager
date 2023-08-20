import UIKit

class LoginViewController: UIViewController {
    
    private var emailTextField: UITextField?
    private var passwordTextField: UITextField?
    private var logoImageView: UIImageView?
    private var signupLabel: UILabel?
    private var findUserLabel: UILabel?
    private var loginButton: UIButton?
    
    private let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        drawLoginView()
        
        self.emailTextField?.delegate = self
        self.passwordTextField?.delegate = self
        
        let signupTapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(pushSignupViewController))
        signupLabel?.isUserInteractionEnabled = true
        signupLabel?.addGestureRecognizer(signupTapGestureRecongnizer)
        
        let findUserTapGestureRecongniger = UITapGestureRecognizer(target: self, action: #selector(pushFindUserViewController))
        self.findUserLabel?.isUserInteractionEnabled = true
        self.findUserLabel?.addGestureRecognizer(findUserTapGestureRecongniger)
        
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func drawLoginView(){
        createLogoImage()
        createTextField()
        createSignupLabel()
        createFindUserLabel()
        createLoginButton()
    }
    
    func createLogoImage(){
        let logoImageView: UIImageView = {
            let imageView: UIImageView = UIImageView(image: UIImage(systemName: "building.columns.circle"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .systemTeal
            return imageView
        }()
        
        self.view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        self.logoImageView = logoImageView
    }
    
    func createTextField(){
        let emailTextField: UITextField = {
            let textField = UITextField()
            textField.addLeftPadding()
            textField.placeholder = "이메일을 입력해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            return textField
        }()
        
        let passwordTextField: UITextField = {
            let textField = UITextField()
            textField.addLeftPadding()
            textField.placeholder = "패스워드를 입력해주세요."
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.isSecureTextEntry = true
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            }
            return textField
        }()
        
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        guard let imageView: UIImageView = self.logoImageView else {return}
        
        NSLayoutConstraint.activate([
            // idTextField 제약 조건
            emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 70),
            emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // passwordTextField 제약 조건
            passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.emailTextField = emailTextField
        self.passwordTextField = passwordTextField
    }
    
    func createSignupLabel(){
        let signupLabel: UILabel = {
            let label: UILabel = UILabel()
            label.text = "회원가입 바로가기"
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 15)
            return label
        }()
        
        self.view.addSubview(signupLabel)
        
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let passwordTextField:UITextField = self.passwordTextField else {return}
        
        NSLayoutConstraint.activate([
            signupLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            signupLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50)
        ])
        
        self.signupLabel = signupLabel
    }
    
    func createFindUserLabel(){
        let findUserLabel: UILabel = {
            let label: UILabel = UILabel()
            label.text = "이메일 및 패스워드 찾기"
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 15)
            return label
        }()
        
        self.view.addSubview(findUserLabel)
        
        findUserLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let signupLabel:UILabel = self.signupLabel else {return}
        
        NSLayoutConstraint.activate([
            findUserLabel.topAnchor.constraint(equalTo: signupLabel.bottomAnchor, constant: 8),
            findUserLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50)
        ])
        
        self.findUserLabel = findUserLabel
    }
    
    func createLoginButton(){
        let loginButton: UIButton = {
            let button: UIButton = UIButton()
            button.backgroundColor = UIColor.systemTeal
            button.setTitle("로그인", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            return button
        }()
        
        self.view.addSubview(loginButton)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        self.loginButton = loginButton
    }
    
    @objc func pushSignupViewController(){
        let signupViewController = SignupViewController()
        self.navigationController?.pushViewController(signupViewController, animated: true)
    }
    
    @objc func pushFindUserViewController(){
        let findUserViewController = FindUserViewController()
        self.navigationController?.pushViewController(findUserViewController, animated: true)
    }
    
    @objc func login(){
        if let email = emailTextField!.text, let password = passwordTextField!.text {
            if !validator.validateEmail(email: email) || !validator.validatePassword(password: password) {
                Alert.createNotificationAlert(self, title: "이메일 또는 패스워드를 확인해주세요.")
                return
            }
            let parameters: [String: AnyHashable] = [
                "email":email,
                "password":password
            ]
            APICaller.sheared.callAPI(endpoint: AppConfig.loginURL, method: .post, parameters: parameters, existRefreshToken: true, isAuth: false){ (result: Result<LoginModel, CustomError>) in
                switch result {
                case .failure(let error):
                    switch error {
                    case let .invalidStatusCode(statusCode, _):
                        if statusCode == 401 {
                            DispatchQueue.main.async {
                                Alert.createNotificationAlert(self, title: "이메일 또는 패스워드를 확인해주세요.")
                                print("error: \(error)")
                            }
                            return
                        } else {
                            DispatchQueue.main.async {
                                Alert.createNotificationAlert(self, title: "서버 및 네트워크가 원활하지 않습니다.")
                                print("error: \(error)")
                            }
                            return
                        }
                    default:
                        DispatchQueue.main.async {
                            Alert.createNotificationAlert(self, title: "서버 및 네트워크가 원활하지 않습니다.")
                            print("error: \(error)")
                            return
                        }
                    }
                        
                                        
                case .success(let model):
                    // 1.store data in keychain (password, access_token)
                    let isStorePassword = Keychain.shered.save(data: password, key: Keychain.passwordKey, account: email)
                    if !isStorePassword {
                        print("password keychain 저장 오류 발생")
                        return
                    }
                    let isStoreAccessToken = Keychain.shered.save(data: model.access_token, key: Keychain.jwtAccessTokenKey, account: email)
                    if !isStoreAccessToken {
                        print("accessToken keychain 저장 오류 발생")
                        return
                    }
                    if let refreshToken = UserDefaults.standard.string(forKey: UserDefaults.userRefreshTokenKey) {
                        let isStoreRefreshToken = Keychain.shered.save(data: refreshToken , key: Keychain.jwtRefreshTokenKey, account: email)
                        if !isStoreRefreshToken {
                            print("refreshToken keychain 저장 오류 발생")
                            return
                        }
                        UserDefaults.standard.removeObject(forKey: UserDefaults.userRefreshTokenKey)
                    }
                    
                    // 2.store data in user defaults (name, phonenumber)
                    UserDefaults.standard.set(email, forKey: UserDefaults.userEmailKey)
                    UserDefaults.standard.set(model.user.name, forKey: UserDefaults.userNameKey)
                    UserDefaults.standard.set(model.user.phonenumber, forKey: UserDefaults.userPhonenumberKey)
                    // 2.push main screen
                    DispatchQueue.main.async {
                        let mainTabBarController = MainTabBarController()
                        self.navigationController?.pushViewController( mainTabBarController, animated: true)
                    }
                    break
                }
            }
        }
        
    }
}

extension UITextField {
    func addLeftPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.systemTeal.cgColor
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField?.becomeFirstResponder()
        } else {
            self.passwordTextField?.resignFirstResponder()
        }
        return true
    }
}
