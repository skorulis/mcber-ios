//  Created by Alexander Skorulis on 3/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class StepperCellViewModel {
    var value:Int = 1
    let title:String
    
    init(title:String,value:Int = 1) {
        self.value = value
        self.title = title
    }
}

final class StepperCountCell: ThemedCollectionViewCell, AutoSizeModelCell, ModelChangeFeedbackCell {

    let stepper = UIStepper()
    let label = UILabel()
    let valueLabel = UILabel()
    
    static var sizingCell: StepperCountCell = setupCell(cell: StepperCountCell())
    typealias ModelType = StepperCellViewModel
    var model: StepperCellViewModel? {
        didSet {
            guard let model = model else {
                return
            }
            stepper.value = Double(model.value)
            label.text = model.title
            valueLabel.text = "\(model.value)"
        }
    }
    var modelDidChangeBlock: ((StepperCellViewModel) -> ())?
    
    override func buildView(theme: ThemeService) {
        stepper.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        stepper.minimumValue = 1
        
        self.contentView.addSubview(stepper)
        self.contentView.addSubview(label)
        self.contentView.addSubview(valueLabel)
    }
    
    override func buildLayout(theme: ThemeService) {
        stepper.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview().inset(theme.padding.edges)
        }
        label.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview().inset(theme.padding.edges)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.right.equalTo(stepper.snp.left).offset(-4)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func stepperValueChanged(sender:UIStepper) {
        model?.value = Int(sender.value)
        valueLabel.text = "\(model!.value)"
        modelDidChangeBlock?(model!)
    }
}
