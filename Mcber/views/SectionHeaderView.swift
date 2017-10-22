//  Created by Alexander Skorulis on 8/8/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class SectionHeaderView: ThemedCollectionReusableView {

    let label = UILabel()
    let rightButton = UIButton()
    
    override func buildView(theme: ThemeService) {
        label.textAlignment = .center
        label.font = theme.font.title
        label.textColor = theme.color.defaultText
        self.addSubview(label)
        self.addSubview(rightButton)
    }
    
    override func buildLayout(theme: ThemeService) {
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(theme.padding.right)
        }
    }
    
    class func basicHeader(collectionView:UICollectionView,kind:String,indexPath:IndexPath,theme:ThemeService,text:String) -> SectionHeaderView {
        let header:SectionHeaderView = collectionView.dequeueSetupView(kind: kind, indexPath: indexPath, theme: theme)
        header.label.text = text
        return header
    }
    
    class func curriedHeaderFunc(theme:ThemeService,text:String) -> (UICollectionView,String,IndexPath) -> SectionHeaderView {
        return { collectionView,kind,indexPath in
            return basicHeader(collectionView: collectionView, kind: kind, indexPath: indexPath, theme: theme, text: text)
        }
        
    }

}
