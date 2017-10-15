//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class UserDetailsViewController: BaseSectionCollectionViewController {
    
    lazy var resources = self.services.state.monitoredResources
    lazy var items = self.services.state.monitoredItems
    lazy var gems = self.services.state.monitoredGems
    
    let itemSizingCell = ItemCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.services.state.monitoredUser?.observers.add(object: self, { _ in
            print("Reload user page")
            self.collectionView.reloadData()
        })
        
        itemSizingCell.frame = self.view.bounds
        itemSizingCell.setup(theme: self.theme)

        self.title = "User"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed(sender:)))
        
        collectionView.register(clazz: ResourceCell.self)
        collectionView.register(clazz: ItemCell.self)
        collectionView.register(clazz: GemCell.self)
        collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
        let topSection = UserCell.defaultArraySection(data: self.services.state.monitoredUser!, collectionView: collectionView)
        topSection.willDisplayCell = {[unowned self] (c,cell,indexPath) in
            guard let userCell = cell as? UserCell else { return }
            userCell.buyAvatarButton.addTarget(self, action: #selector(self.buyAvatarPressed(sender:)), for: .touchUpInside)
            userCell.optionsButton.addTarget(self, action: #selector(self.optionsPressed(sender:)), for: .touchUpInside)
        }
        self.sections.append(topSection)
        
        let resourceSection = SectionController()
        resourceSection.simpleNumberOfItemsInSection = resources.elementCount
        resourceSection.cellForItemAt = ResourceCell.curriedDefaultCell(getModel: resources.elementAt(indexPath:))
        
        resourceSection.fixedHeaderHeight = 40
        resourceSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Resources")
        
        self.sections.append(resourceSection)
        
        let itemSection = SectionController()
        itemSection.simpleNumberOfItemsInSection = items.elementCount
        itemSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell = ItemCell.curriedDefaultCell(getModel: self.items.elementAt(indexPath:))(collectionView,indexPath)
            cell.deleteBlock = {[unowned self] item in
                _ = self.services.user.breakdown(item: item).then { [unowned self] response -> Void in
                    self.collectionView.reloadData()
                    let resultVC = ActivityResultViewController(services: self.services)
                    resultVC.result = CombinedActivityResult(resources: response.resources)
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
            return cell
        }
        
        /*itemSection.sizeForItemAt = { (collectionView:UICollectionView,layout:UICollectionViewLayout, indexPath:IndexPath) in
            return CGSize(width: collectionView.frame.width, height: 50)
        }*/
        
        itemSection.fixedHeaderHeight = 40
        itemSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Items")
        
        self.sections.append(itemSection)
        
        let gemSection = SectionController()
        gemSection.simpleNumberOfItemsInSection = gems.elementCount
        gemSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell = GemCell.curriedDefaultCell(getModel: self.gems.elementAt(indexPath:))(collectionView,indexPath)
            cell.deleteBlock = {[unowned self] gem in
                _ = self.services.user.breakdown(gem: gem).then { [unowned self] response -> Void in
                    self.collectionView.reloadData()
                    let resultVC = ActivityResultViewController(services: self.services)
                    resultVC.result = CombinedActivityResult(resources: response.resources)
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
            return cell
        }
    
        gemSection.fixedHeaderHeight = 40
        gemSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Gems")
        
        self.sections.append(gemSection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    //MARK: Actions
    
    @objc func optionsPressed(sender:Any) {
        let vc = UserOptionsViewController(services:self.services)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buyAvatarPressed(sender:Any) {
        _ = self.services.user.buyAvatarSlot().then {[weak self] response -> Void in
            self?.collectionView.reloadData()
        } .catch {[weak self] (error) in
            self?.show(error: error)
        }
    }
    
    @objc func logoutPressed(sender:UIBarButtonItem) {
        self.services.login.logout()
    }

}
