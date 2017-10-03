//  Created by Alexander Skorulis on 2/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class BaseStartActivityViewController: BaseSectionCollectionViewController {

    var selectedAvatar:AvatarModel?
    var estimatedActivity:ActivityModel?
    
    func avatarCount() -> Int {
        return self.selectedAvatar != nil ? 1 : 0
    }
    
    let avatarSection = SectionController()
    
    func estimate(indexPath:IndexPath) -> ActivityViewModel? {
        return estimatedActivity.map { ActivityViewModel(activity:$0,user:self.services.state.user!,theme:self.theme) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(clazz: AvatarCell.self)
        collectionView.register(clazz: ActivityEstimateCell.self)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionHeader)
        collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionFooter)
        
        avatarSection.fixedHeaderHeight = 40
        avatarSection.fixedCellCount = 0
        avatarSection.fixedHeight = 120
        avatarSection.simpleNumberOfItemsInSection = avatarCount
        avatarSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Avatar")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectAvatarPressed(id:)))
            return header
        }
        avatarSection.cellForItemAt = AvatarCell.curriedDefaultCell(getModel: {[unowned self] (IndexPath)->(AvatarModel) in return self.selectedAvatar! })
        
    }
    
    func startSection(title:String) -> SectionController {
        let theme = ThemeService.theme!
        let startSection = SectionController()
        startSection.fixedFooterHeight = 40
        startSection.fixedCellCount = 0
        startSection.sizeForItemAt = ActivityEstimateCell.curriedCalculateSize(getModel: estimate)
        startSection.cellForItemAt = ActivityEstimateCell.curriedDefaultCell(getModel: estimate)
        
        startSection.simpleNumberOfItemsInSection =  { [unowned self] in
            return self.estimate(indexPath:IndexPath(row: 0, section: 0)) != nil ? 1 : 0
        }
        
        startSection.referenceSizeForHeader = { [unowned self] (collectionView:UICollectionView,layout:UICollectionViewLayout,section:Int) in
            return self.estimate(indexPath:IndexPath(row: 0, section: 0)) != nil ? CGSize(width:collectionView.frame.width,height:40) : .zero
        }
        
        startSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            if (kind == UICollectionElementKindSectionHeader) {
                return SectionHeaderView.curriedHeaderFunc(theme: ThemeService.theme, text: "Preview")(collectionView,kind,indexPath)
            }
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: title)(collectionView,kind,indexPath)
            header.textColor = self.estimate(indexPath:indexPath) != nil ? theme.color.defaultText : theme.color.disabledText
            header.addTapTarget(target: self, action: #selector(self.startPressed(id:)))
            return header
        }
        return startSection
    }
    
    @objc func selectAvatarPressed(id:Any) {
        let vc = AvatarListViewController(services: self.services)
        vc.didSelectAvatar = {[unowned self] (vc:AvatarListViewController,avatar:AvatarModel) in
            vc.navigationController?.popViewController(animated: true)
            self.selectedAvatar = avatar
            self.tryUpdateEstimate()
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func startPressed(id:Any) {
        if let avatar = self.selectedAvatar {
            guard let promise = self.startActivity(avatar: avatar) else {
                return
            }
            promise.then { [weak self] (response) -> Void in
                self?.navigationController?.popViewController(animated: true)
                }.catch { [weak self] error in
                    self?.show(error: error)
            }
        }
    }
    
    func tryUpdateEstimate() {
        if let avatar = selectedAvatar {
            let promise = getEstimate(avatar:avatar)
            _ = promise?.then { [weak self] (response) -> Void in
                self?.estimatedActivity = response.activity
                self?.collectionView.reloadData()
            }
        }
    }
    
    func getEstimate(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return nil //Override in subclasses
    }
    
    func startActivity(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return nil //Override in subclasses
    }

}