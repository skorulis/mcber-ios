//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

enum AvatarListType {
    case plain
    case free
}

class AvatarListViewController: BaseSectionCollectionViewController {

    var listType:AvatarListType = .plain
    var didSelectAvatar: ((AvatarListViewController,AvatarModel) -> () )?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Avatars"
        
        let avatarViewModel:MonitoredArrayView<AvatarViewModel,AvatarModel> = self.services.state.monitoredAvatars.map {[unowned self] avatar in
            return self.mapAvatar(avatar: avatar)
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
    
    func mapAvatar(avatar:AvatarModel) -> AvatarViewModel {
        switch(self.listType) {
        case .plain:
            return AvatarViewModel(avatar:avatar)
        case .free:
            let hasActivity = self.services.state.user?.avatarActivity(avatarId: avatar._id) != nil
            let status = hasActivity ? "BUSY" : "FREE"
            let color = hasActivity ? self.theme.color.negativeColor : self.theme.color.positiveColor
            return AvatarViewModel(avatar:avatar,status:status,statusColor:color)
        }
        
    }

}
