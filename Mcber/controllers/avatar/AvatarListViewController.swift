//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit


//TODO: Make section controller
class AvatarListViewController: BaseCollectionViewController {

    var didSelectAvatar: ((AvatarListViewController,AvatarModel) -> () )?
    
    var avatars:[AvatarModel] {
        return self.services.state.user?.avatars ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Avatars"
        self.collectionView.register(clazz: AvatarCell.self)   
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.flowLayout?.itemSize = CGSize(width: self.collectionView.frame.size.width, height: 120)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.avatars.count
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AvatarCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
        let vm = AvatarViewModel(avatar: avatars[indexPath.row])
        cell.model = vm
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let select = didSelectAvatar {
            select(self,self.avatars[indexPath.row])
        } else {
            let vc = AvatarDetailViewController(services: self.services,avatar:self.avatars[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}
