//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class UserDetailsViewController: BaseSectionCollectionViewController {

    var resources:[ResourceModel] {
        return self.services.state.resources
    }
    
    func resourceCount() -> Int {
        return resources.count
    }
    
    func resourceAt(indexPath:IndexPath) -> ResourceModel {
        return self.resources[indexPath.row]
    }
    
    func itemCount() -> Int {
        return self.services.state.items.count
    }
    
    func itemAt(indexPath:IndexPath) -> ItemModel {
        return self.services.state.items[indexPath.row]
    }
    
    let itemSizingCell = ItemCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemSizingCell.frame = self.view.bounds
        itemSizingCell.setup(theme: self.theme)

        self.title = "User"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed(sender:)))
        
        collectionView.register(clazz: ResourceCell.self)
        collectionView.register(clazz: ItemCell.self)
        collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
        let resourceSection = SectionController()
        resourceSection.simpleNumberOfItemsInSection = resourceCount
        resourceSection.cellForItemAt = ResourceCell.curriedDefaultCell(getModel: resourceAt(indexPath:))
        
        resourceSection.fixedHeaderHeight = 40
        resourceSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Resources")
        
        self.sections.append(resourceSection)
        
        let itemSection = SectionController()
        itemSection.simpleNumberOfItemsInSection = itemCount
        itemSection.cellForItemAt = ItemCell.curriedDefaultCell(getModel: itemAt(indexPath:))
        itemSection.sizeForItemAt = { (collectionView:UICollectionView,layout:UICollectionViewLayout, indexPath:IndexPath) in
            let width = self.collectionView.frame.width
            self.itemSizingCell.frame = CGRect(x: 0, y: 0, width: width, height: 400)
            let height = self.itemSizingCell.calculateHeight(model: self.itemAt(indexPath: indexPath))
            return CGSize(width: width, height: height)
        }
        
        itemSection.fixedHeaderHeight = 40
        itemSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Items")
        
        self.sections.append(itemSection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    //MARK: Actions
    
    func logoutPressed(sender:UIBarButtonItem) {
        self.services.login.logout()
    }

}
