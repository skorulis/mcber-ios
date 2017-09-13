//  Created by Alexander Skorulis on 12/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class RootViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.services.login.userDidLogin.add(object: self) { (login) in
            self.dismiss(animated: true, completion: nil)
            self.showMainUI()
        }
        
        self.services.login.userDidLogout.add(object: self) { (login) in
            self.showLogin()
        }
    }
    
    //TODO: Why doesn't this work in view did appear?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.services.login.isLoggedIn {
            self.showMainUI()
        } else {
            self.showLogin()
        }
    }
    
    func showMainUI() {
        let user = UserDetailsViewController(services: self.services)
        let activites = ActivityListViewController(services: self.services)
        let avatars = AvatarListViewController(services: self.services)
        
        let controllers:[UIViewController] = [user,activites,avatars]
        let tab = UITabBarController()
        tab.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        self.view.addSubview(tab.view)
        tab.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.addChildViewController(tab)
    }
    
    func showLogin() {
        let vc = LoginViewController(services: self.services)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }

}
