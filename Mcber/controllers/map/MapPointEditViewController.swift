//  Created by Alexander Skorulis on 20/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapPointEditViewController: BaseSectionCollectionViewController {

    let point:MapPointModel
    
    let levelModel:StepperCellViewModel
    let radiusModel:StepperCellViewModel
    
    let affiliationsArray:MonitoredArray<StepperCellViewModel>
    
    init(services: ServiceLocator,point:MapPointModel) {
        self.point = point
        levelModel = StepperCellViewModel(title: "Level", value: point.level)
        levelModel.minValue = 0
        
        radiusModel = StepperCellViewModel(title: "Radius", value: point.radius)
        radiusModel.minValue = 20
        
        let affiliationsVM = point.affiliation.map { (aff) -> StepperCellViewModel in
            let stepper = StepperCellViewModel(title: aff.skill.name, value: aff.value)
            stepper.minValue = 0
            return stepper
        }
        
        affiliationsArray = MonitoredArray(array: affiliationsVM)
        
        super.init(services: services)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit point"
        
        collectionView.register(clazz: StepperCountCell.self)
        collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
        let topArray:MonitoredArray<StepperCellViewModel> = MonitoredArray(array: [levelModel,radiusModel])
        
        let section = StepperCountCell.defaultArraySection(data: topArray, collectionView: collectionView)
        self.add(section: section)
        
        let affiliationSection = StepperCountCell.defaultArraySection(data: affiliationsArray, collectionView: collectionView)
        affiliationSection.fixedHeaderHeight = 40
        affiliationSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Skill Affiliations")
        self.add(section: affiliationSection)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        point.level = levelModel.value
        point.radius = radiusModel.value
    }

}
