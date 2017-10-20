//  Created by Alexander Skorulis on 20/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapPointEditViewController: BaseSectionCollectionViewController {

    let point:MapPointModel
    
    let levelModel:StepperCellViewModel
    
    init(services: ServiceLocator,point:MapPointModel) {
        self.point = point
        levelModel = StepperCellViewModel(title: "Point Level", value: point.level)
        levelModel.minValue = 0
        super.init(services: services)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit point"
        
        collectionView.register(clazz: StepperCountCell.self)
        
        let section = StepperCountCell.defaultSection(object: levelModel, collectionView: collectionView)
        self.add(section: section)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        point.level = levelModel.value
    }

}
