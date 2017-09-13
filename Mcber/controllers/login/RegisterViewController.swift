//  Created by Alexander Skorulis on 31/8/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class RegisterViewController: BaseViewController {

    let registerButton = UIButton()
    let emailField = UITextField()
    let passwordField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Register"
        
        emailField.placeholder = "Email"
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        
        emailField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.left.right.equalTo(emailField)
            make.top.equalTo(emailField.snp.bottom).offset(10)
        }
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(registerButton)
        
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        registerButton.addTarget(self, action: #selector(registerPressed(sender:)), for: .touchUpInside)
        
    }
    
    func registerPressed(sender:Any) {
        guard let email = emailField.text else {
            return
        }
        guard let password = passwordField.text else {
            return
        }
        _ = self.services.login.signup(email: email, password: password).then { response -> Void in
            
        }
    }

}
