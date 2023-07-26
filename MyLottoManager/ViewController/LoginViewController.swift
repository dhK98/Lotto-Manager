import UIKit

class LoginViewController: UIViewController {
    
    private var idTextField: UITextField?
    private var passwordTextField: UITextField?
    private var logoImageView: UIImageView?
    private var signupLabel: UILabel?
    private var findPasswordLabel: UILabel?
    private var loginButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        drawLoginView()
        
        self.idTextField?.delegate = self
        self.passwordTextField?.delegate = self
        
        let signupTapGesgureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(pushSignupViewController))
        signupLabel?.isUserInteractionEnabled = true
        signupLabel?.addGestureRecognizer(signupTapGesgureRecongnizer)
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func drawLoginView(){
        createLogoImage()
        createTextField()
        createSignupLabel()
        createFindPasswordLabel()
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
        let idTextField: UITextField = {
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
        
        self.view.addSubview(idTextField)
        self.view.addSubview(passwordTextField)
        
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        guard let imageView: UIImageView = self.logoImageView else {return}
        
        NSLayoutConstraint.activate([
            // idTextField 제약 조건
            idTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            idTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 70),
            idTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            idTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            idTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // passwordTextField 제약 조건
            passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.idTextField = idTextField
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
    
    func createFindPasswordLabel(){
        let findPasswordLabel: UILabel = {
            let label: UILabel = UILabel()
            label.text = "이메일 및 패스워드 찾기"
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 15)
            return label
        }()
        
        self.view.addSubview(findPasswordLabel)
        
        findPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let signupLabel:UILabel = self.signupLabel else {return}
        
        NSLayoutConstraint.activate([
            findPasswordLabel.topAnchor.constraint(equalTo: signupLabel.bottomAnchor, constant: 8),
            findPasswordLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50)
        ])
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
    
    @objc func login(){
        print("login")
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
        if textField == self.idTextField {
            self.passwordTextField?.becomeFirstResponder()
        } else {
            self.passwordTextField?.resignFirstResponder()
        }
        return true
    }
}
