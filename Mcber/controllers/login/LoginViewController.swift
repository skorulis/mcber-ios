//  Created by Alexander Skorulis on 18/8/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import SnapKit

class LoginViewController: BaseViewController {

    let registerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(registerButton)
        
        registerButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        registerButton.addTarget(self, action: #selector(registerPressed(sender:)), for: .touchUpInside)
        
    }
    
    func registerPressed(sender:Any) {
        let vc = RegisterViewController(services: self.services)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
