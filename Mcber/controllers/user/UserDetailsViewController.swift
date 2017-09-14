//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class UserDetailsViewController: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Users"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed(sender:)))
    }
    
    func logoutPressed(sender:UIBarButtonItem) {
        self.services.login.logout()
    }

}
