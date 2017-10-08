//  Created by Alexander Skorulis on 9/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class RandomBattleViewController: BaseInstantActivityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Random Battle"
        
        self.add(section:avatarSection)
    }

}
