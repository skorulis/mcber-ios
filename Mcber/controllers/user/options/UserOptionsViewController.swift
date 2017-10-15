//  Created by Alexander Skorulis on 15/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class UserOptionsViewController: BaseSectionCollectionViewController {

    lazy var user = self.services.state.user!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Options"
        setupDefaults()
        
        collectionView.register(clazz: StepperCountCell.self)
        
        let section = SectionController()
        section.simpleNumberOfItemsInSection = {[unowned self] in return self.user.options.count }
        section.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let opt = self.user.options[indexPath.row]
            let cell:StepperCountCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.modelDidChangeBlock = self.stepperChanged
            let vm = StepperCellViewModel(title: opt.optionName, value: opt.optionValue as! Int)
            vm.minValue = -1
            cell.model = vm
            return cell
        }
        
        self.sections.append(section)
    }
    
    func setupDefaults() {
        setOptionIfMissing(optionName: "item auto squelch level", defaultValue: -1)
        setOptionIfMissing(optionName: "gem auto squelch level", defaultValue: -1)
    }
    
    func setOptionIfMissing(optionName:String,defaultValue:Any) {
        let existing = user.getOption(name: optionName)
        if existing == nil {
            user.setOption(name: optionName, value: defaultValue)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _ = self.services.user.updateUserOptions(options: self.user.options)
    }
    
    func stepperChanged(vm:StepperCellViewModel) {
        self.user.setOption(name: vm.title, value: vm.value)
    }

}
