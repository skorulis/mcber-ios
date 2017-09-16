//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

enum ActivityType: String {
    case explore = "explore"
    case battle = "battle"
}

class ActivityListViewController: BaseSectionCollectionViewController {

    var activities:[ActivityModel] {
        return self.services.state.activities
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Activities"
        let types:[ActivityType] = [.explore, .battle]
        
        self.collectionView.register(clazz: ForwardNavigationCell.self)
        self.collectionView.register(clazz: ActivityItemCell.self)
        self.collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
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
        
        let activitySection = SectionController()
        activitySection.numberOfItemsInSection = {[unowned self] (c:UICollectionView,s:Int) in
            return self.activities.count
        }
        activitySection.fixedHeight = 100
        activitySection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:ActivityItemCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.activity = self.activities[indexPath.row]
            return cell
        }
        activitySection.fixedHeaderHeight = 40
        activitySection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "In Progress")
        

        self.sections.append(startSection)
        self.sections.append(activitySection)
    }

}
