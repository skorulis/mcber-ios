//  Created by Alexander Skorulis on 18/8/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import SnapKit

class LoginViewController: BaseViewController {

    let registerButton = UIButton()
    let loginButton = UIButton()
    let emailField = UITextField()
    let passwordField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        
        emailField.placeholder = "Email"
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.black, for: .normal)
        
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        
        emailField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.left.right.equalTo(emailField)
            make.top.equalTo(emailField.snp.bottom).offset(10)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordField.snp.bottom).offset(8)
        }
        
        
        registerButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        loginButton.addTarget(self, action: #selector(loginPressed(sender:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerPressed(sender:)), for: .touchUpInside)
        
    }
    
    @objc func registerPressed(sender:Any) {
        let vc = RegisterViewController(services: self.services)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginPressed(sender:Any) {
        if let email = emailField.text, let password = passwordField.text {
            self.services.login.login(email:email,password:password).catch(execute: { (error) in
                self.show(error: error)
            })
        }
        
    }
}
