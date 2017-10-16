//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class AvatarListViewController: BaseSectionCollectionViewController {

    var didSelectAvatar: ((AvatarListViewController,AvatarModel) -> () )?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Avatars"
        
        let avatarViewModel:MonitoredArrayView<AvatarViewModel,AvatarModel> = self.services.state.monitoredAvatars.map { avatar in
            
            return AvatarViewModel(avatar:avatar)
        }
        
        let avatarSection = AvatarCell.defaultArraySection(data: avatarViewModel, collectionView: collectionView)
        avatarSection.didSelectItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let avatar = self.services.state.monitoredAvatars[indexPath.row]
            if let select = self.didSelectAvatar {
                select(self,avatar)
            } else {
                let vc = AvatarDetailViewController(services:self.services,avatar:avatar)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.add(section: avatarSection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }

}
