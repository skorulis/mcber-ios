//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ActivityItemCell: ThemedCollectionViewCell {

    let typeLabel = UILabel()
    let progress = ProgressView()
    
    let cancelButton = UIButton()
    let completeButton = UIButton()
    
    let autoRepeatSwitch = UISwitch()
    let autoRepeatLabel = UILabel()
    
    var completeBlock: ((ActivityModel) -> ())?
    var takeResults: ((ActivityModel) -> ())?
    var cancelBlock: ((ActivityModel) -> ())?
    var autoChangeBlock: ((ActivityModel,Bool) -> ())?
    
    let ref = ReferenceService.instance!
    
    var activity:ActivityModel? {
        didSet {
            guard let activity = self.activity else { return }
            typeLabel.text = self.activityText(activity: activity)
            autoRepeatSwitch.isOn = activity.autoRepeat
            cancelButton.isHidden = activity.isFinished()
            updateCompleteButton()
            updateProgressFrame()
            updateRemainingLabel()
        }
    }
    
    func updateCompleteButton() {
        guard let activity = self.activity else { return }
        if activity.autoRepeat {
            completeButton.alpha = activity.heldResults.experience.count > 0 ? 1 : 0
            completeButton.setTitle("Unseen results", for: .normal)
        } else {
            completeButton.alpha = 1
            completeButton.setTitle("Complete", for: .normal)
        }
    }
    
    func activityText(activity:ActivityModel) -> String {
        switch (activity.activityType) {
        case .explore:
            let realm = activity.realm!
            let element = ref.skill(realm.elementId)
            return "Explore \(element.name) realm level \(realm.level)"
        case .craft:
            return "Craft"
        case .craftGem:
            return "Craft Gem"
        case .socketGem:
            return "Socket gem"
        }
    }
    
    override func buildView(theme: ThemeService) {
        cancelButton.setTitle("Cancel", for: .normal)
        completeButton.setTitle("Complete", for: .normal)
        
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        completeButton.setTitleColor(UIColor.black, for: .normal)
        
        cancelButton.addTarget(self, action: #selector(cancelPressed(sender:)), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completePressed(sender:)), for: .touchUpInside)
        
        autoRepeatSwitch.addTarget(self, action: #selector(autoRepeatChanged(sender:)), for: .valueChanged)
        
        self.contentView.addSubview(progress)
        self.contentView.addSubview(typeLabel)
        self.contentView.addSubview(completeButton)
        self.contentView.addSubview(cancelButton)
        self.contentView.addSubview(autoRepeatSwitch)
        self.contentView.addSubview(autoRepeatLabel)
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
        autoRepeatLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeLabel)
            make.centerY.equalTo(autoRepeatSwitch)
        }
        
        autoRepeatSwitch.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(theme.padding.edges)
            make.top.equalTo(typeLabel.snp.bottom).offset(2)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateProgressFrame()
    }
    
    private func updateRemainingLabel() {
        if let a = activity {
            let currentTime = Date().timeIntervalSince1970
            let remaining = max(Int(a.finishTimestamp - currentTime) + 1,0)
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
    
    @objc func autoRepeatChanged(sender:UISwitch) {
        self.activity?.autoRepeat = sender.isOn
        autoChangeBlock?(self.activity!,sender.isOn)
        self.updateCompleteButton()
    }
    
    @objc func cancelPressed(sender:Any) {
        cancelBlock?(self.activity!)
    }
    
    @objc func completePressed(sender:Any) {
        if (self.activity?.autoRepeat ?? false) {
            takeResults?(self.activity!)
        } else {
            completeBlock?(self.activity!)
        }
        
    }

}
