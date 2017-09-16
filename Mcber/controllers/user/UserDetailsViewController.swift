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
    
    func resourceAt(indexPath:IndexPath) -> (ResourceModel,ResourceRefModel) {
        let resource = self.resources[indexPath.row]
        return self.services.ref.filledResource(resource: resource)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "User"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed(sender:)))
        
        collectionView.register(clazz: ResourceCell.self)
        collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
        let resourceSection = SectionController()
        resourceSection.simpleNumberOfItemsInSection = resourceCount
        resourceSection.cellForItemAt = ResourceCell.curriedDefaultCell(getModel: resourceAt(indexPath:))
        
        resourceSection.fixedHeaderHeight = 40
        resourceSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Resources")
        
        self.sections.append(resourceSection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    //MARK: Actions
    
    func logoutPressed(sender:UIBarButtonItem) {
        self.services.login.logout()
    }

}
