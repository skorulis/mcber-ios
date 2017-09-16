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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "User"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed(sender:)))
        
        collectionView.register(clazz: ResourceCell.self)
        self.collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
        let resourceSection = SectionController()
        resourceSection.simpleNumberOfItemsInSection = resourceCount
        resourceSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:ResourceCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            let resource = self.resources[indexPath.row]
            cell.model = (resource,self.services.ref.elementResource(resource.resourceId) )
            return cell
        }
        
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
