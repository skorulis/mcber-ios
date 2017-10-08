//  Created by Alexander Skorulis on 9/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class BaseInstantActivityViewController: BaseSectionCollectionViewController {

    let selectedAvatar = OptionalMonitoredObject<AvatarModel>(element:nil)
    
    var avatarSection:SectionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionHeader)
        
        avatarSection = AvatarCell.defaultArraySection(data: selectedAvatar, collectionView: collectionView)
        avatarSection.fixedHeaderHeight = 40
        avatarSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Avatar")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectAvatarPressed(id:)))
            return header
        }
    }
    
    @objc func selectAvatarPressed(id:Any) {
        let vc = AvatarListViewController(services: self.services)
        vc.didSelectAvatar = {[unowned self] (vc:AvatarListViewController,avatar:AvatarModel) in
            vc.navigationController?.popViewController(animated: true)
            self.selectedAvatar.object = avatar
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
