//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

enum ActivityType: String {
    case explore = "explore"
    case battle = "battle"
}

class ActivityListViewController: BaseSectionCollectionViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Activities"
        let types:[ActivityType] = [.explore, .battle]
        
        self.collectionView.register(clazz: ForwardNavigationCell.self)
        
        let startSection = SectionController()
        startSection.fixedCellCount = types.count
        startSection.fixedHeight = 40
        startSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:ForwardNavigationCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.label.text = types[indexPath.row].rawValue
            return cell
        }
        startSection.didSelectItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let type = types[indexPath.row]
            switch(type) {
            case .explore:
                let vc = StartExploreViewController(services: self.services)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .battle:
                
                break
            
            }
        }
        
        
        self.sections.append(startSection)
    }

}
