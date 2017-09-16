//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ActivityItemCell: ThemedCollectionViewCell {

    let typeLabel = UILabel()
    let remainingLabel = UILabel()
    let emptyProgressBar = UIView()
    let fullProgressBar = UIView()
    
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
        fullProgressBar.backgroundColor = UIColor.gray
        emptyProgressBar.backgroundColor = UIColor.orange
        
        cancelButton.setTitle("Cancel", for: .normal)
        completeButton.setTitle("Complete", for: .normal)
        
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        completeButton.setTitleColor(UIColor.black, for: .normal)
        
        cancelButton.addTarget(self, action: #selector(cancelPressed(sender:)), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completePressed(sender:)), for: .touchUpInside)
        
        self.emptyProgressBar.addSubview(fullProgressBar)
        self.contentView.addSubview(emptyProgressBar)
        self.contentView.addSubview(typeLabel)
        self.contentView.addSubview(remainingLabel)
        self.contentView.addSubview(completeButton)
        self.contentView.addSubview(cancelButton)
    }
    
    override func buildLayout(theme: ThemeService) {
        typeLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(theme.padding.edges)
        }
        emptyProgressBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(theme.padding.edges)
            make.height.equalTo(20)
        }
        remainingLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(emptyProgressBar)
            make.left.equalTo(emptyProgressBar).offset(20)
        }
        completeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(emptyProgressBar.snp.top).offset(4)
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
            self.remainingLabel.text = "\(remaining)"
        }
    }
    
    private func updateProgressFrame() {
        if let a = activity {
            let totalTime = a.finishTimestamp - a.startTimestamp
            let currentTime = Date().timeIntervalSince1970
            let remaining = a.finishTimestamp - currentTime
            let remainingFrac = max(0, remaining / totalTime)
            let width = emptyProgressBar.frame.width * CGFloat(1-remainingFrac)
            fullProgressBar.frame = CGRect(x: 0, y: 0, width: width, height: fullProgressBar.frame.height)
            
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