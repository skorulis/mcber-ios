//  Created by Alexander Skorulis on 9/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class BattleResultViewController: BaseSectionCollectionViewController {

    var result:ActivityResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Battle"
        
        let battleRes = result.battleResult!
        let battleResMonitor = MonitoredObject(initialValue: battleRes)
        let avatars = MonitoredArray(array: [battleRes.avatar1,battleRes.avatar2])
        
        let avatarSection = AvatarCell.defaultArraySection(data: avatars, collectionView: self.collectionView)
        
        let summary = BattleSummaryCell.defaultObjectSection(data: battleResMonitor, collectionView: self.collectionView)
        
        let nextVM = BasicTextViewModel(text: "Rewards")
        let nextSection = ForwardNavigationCell.defaultSection(object: nextVM, collectionView: collectionView)
        
        self.add(section: avatarSection)
        self.add(section: summary)
        self.add(section: nextSection)
        
    }
    
    @objc func nextPressed(sender:Any) {
        
    }

}
