//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ActivityListViewController: BaseSectionCollectionViewController {

    var refreshTimer:Timer?
    
    var activities:[ActivityModel] {
        return self.services.state.activities
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Activities"
        let types:[ActivityType] = [.explore, .battle, .craft]
        
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
            case .craft:
                let vc = StartCraftViewController(services: self.services)
                self.navigationController?.pushViewController(vc, animated: true)
                break;
            }
        }
        
        let activitySection = SectionController()
        activitySection.numberOfItemsInSection = {[unowned self] (c:UICollectionView,s:Int) in
            return self.activities.count
        }
        activitySection.fixedHeight = 120
        activitySection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:ActivityItemCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.activity = self.activities[indexPath.row]
            cell.completeBlock = self.complete(activity:)
            cell.takeResults = self.takeResults(activity:)
            return cell
        }
        activitySection.fixedHeaderHeight = 40
        activitySection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "In Progress")
        
        self.sections.append(startSection)
        self.sections.append(activitySection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        self.refreshTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.collectionView.reloadData()
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.refreshTimer?.invalidate()
        self.refreshTimer = nil
    }
    
    func takeResults(activity:ActivityModel) {
        let vc = ActivityResultViewController(services: self.services)
        vc.result = activity.heldResults
        self.navigationController?.pushViewController(vc, animated: true)
        activity.heldResults = CombinedActivityResult()
        self.collectionView.reloadData()
    }
    
    func complete(activity:ActivityModel) {
        _ = self.services.activity.complete(activity: activity).then { [weak self] response -> Void in
            guard let strongSelf = self else {
                return
            }
            let vc = ActivityResultViewController(services: strongSelf.services)
            vc.result = CombinedActivityResult(result: response.result)
            strongSelf.navigationController?.pushViewController(vc, animated: true)
            strongSelf.collectionView.reloadData()
        }
    }

}
