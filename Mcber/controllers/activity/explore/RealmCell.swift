//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class RealmCell: ThemedCollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var ref:ReferenceService = ReferenceService.instance
    let label = UILabel()
    let layout = UICollectionViewFlowLayout()
    var collectionView:UICollectionView!
    
    var didSelectLevel: ((Int) -> () )?
    
    var selectedLevel:Int? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var realm:RealmModel? {
        didSet {
            if let r = realm {
                let skill = ref.skill(r.elementId)
                label.text = "\(skill.name) Realm"
            }
        }
    }
    
    override func buildView(theme: ThemeService) {
        self.contentView.addSubview(label)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 40)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(clazz: RealmLevelCell.self)
        collectionView.backgroundColor = UIColor.clear
        self.contentView.addSubview(collectionView)
    }
    
    override func buildLayout(theme: ThemeService) {
        label.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(theme.padding.edges)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realm!.maximumLevel!
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:RealmLevelCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme!)
        cell.label.text = "\(indexPath.row+1)"
        cell.isSelected = (indexPath.row+1) == selectedLevel
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedLevel = (indexPath.row + 1)
        didSelectLevel?(indexPath.row+1)
    }

}
