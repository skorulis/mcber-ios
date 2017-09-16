//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ActivityItemCell: ThemedCollectionViewCell {

    let typeLabel = UILabel()
    let progress = ProgressView()
    
    let cancelButton = UIButton()
    let completeButton = UIButton()
    
    var completeBlock: ((ActivityModel) -> ())?
    var cancelBlock: ((ActivityModel) -> ())?
    
    var activity:ActivityModel? {
        didSet {
            typeLabel.text = activity?.activityType
            updateProgressFrame()
            updateRemainingLabel()
        }
    }
    
    override func buildView(theme: ThemeService) {
        cancelButton.setTitle("Cancel", for: .normal)
        completeButton.setTitle("Complete", for: .normal)
        
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        completeButton.setTitleColor(UIColor.black, for: .normal)
        
        cancelButton.addTarget(self, action: #selector(cancelPressed(sender:)), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completePressed(sender:)), for: .touchUpInside)
        
        self.contentView.addSubview(progress)
        self.contentView.addSubview(typeLabel)
        self.contentView.addSubview(completeButton)
        self.contentView.addSubview(cancelButton)
    }
    
    override func buildLayout(theme: ThemeService) {
        typeLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(theme.padding.edges)
        }
        progress.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(theme.padding.edges)
            make.height.equalTo(20)
        }
        completeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(progress.snp.top).offset(4)
            make.right.equalToSuperview().inset(theme.padding.edges)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(completeButton)
            make.left.equalToSuperview().inset(theme.padding.edges)
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateProgressFrame()
    }
    
    private func updateRemainingLabel() {
        if let a = activity {
            let currentTime = Date().timeIntervalSince1970
            let remaining = max(Int(a.finishTimestamp - currentTime),0)
            self.progress.label.text = "\(remaining)"
        }
    }
    
    private func updateProgressFrame() {
        if let a = activity {
            let currentTime:Double = Date().timeIntervalSince1970
            self.progress.setFraction(startValue: a.startTimestamp, finishValue: a.finishTimestamp, currentValue: currentTime)
        }
    }
    
    //MARK: Actions
    
    func cancelPressed(sender:Any) {
        cancelBlock?(self.activity!)
    }
    
    func completePressed(sender:Any) {
        completeBlock?(self.activity!)
    }

}
