//  Created by Alexander Skorulis on 9/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class BaseInstantActivityViewController: BaseSectionCollectionViewController {

    let selectedAvatar = OptionalMonitoredObject<AvatarModel>(element:nil)
    
    var avatarSection:SectionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionHeader)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionFooter)
        
        avatarSection = AvatarCell.defaultArraySection(data: selectedAvatar, collectionView: collectionView)
        avatarSection.fixedHeaderHeight = 40
        avatarSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Avatar")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectAvatarPressed(sender:)))
            return header
        }
    }
    
    func startSection(title:String) -> SectionController {
        let theme = ThemeService.theme!
        let startSection = SectionController()
        startSection.fixedFooterHeight = 40
        startSection.fixedCellCount = 0
        
        startSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: title)(collectionView,kind,indexPath)
            header.textColor = self.isReady() ? theme.color.defaultText : theme.color.disabledText
            header.addTapTarget(target: self, action: #selector(self.startPressed(sender:)))
            return header
        }
        return startSection
    }
    
    func isReady() -> Bool {
        return self.selectedAvatar.object != nil
    }
    
    func performActivity(avatar:AvatarModel) -> Promise<ActivityCompleteResponse>? {
        return nil
    }
    
    //MARK: Actions
    
    @objc func startPressed(sender:Any) {
        if !self.isReady() {
            return
        }
        let promise = performActivity(avatar:self.selectedAvatar.object!)
        _ = promise?.then(execute: {[unowned self] (response) -> Void in
            let vc = BattleResultViewController(services: self.services)
            vc.result = response.result
            self.navigationController?.pushViewController(vc, animated: true)
            
        })
    }
    
    @objc func selectAvatarPressed(sender:Any) {
        let vc = AvatarListViewController(services: self.services)
        vc.didSelectAvatar = {[unowned self] (vc:AvatarListViewController,avatar:AvatarModel) in
            vc.navigationController?.popViewController(animated: true)
            self.selectedAvatar.object = avatar
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
