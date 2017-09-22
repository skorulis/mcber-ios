//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

protocol SimpleModelCell {
    associatedtype ModelType
    var model:ModelType? {get set}
}

extension SimpleModelCell {
    static func defaultCell(collectionView:UICollectionView,indexPath:IndexPath,model:ModelType) -> Self {
        let ident = String(describing: Self.self)
        var cell:Self = collectionView.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as! Self
        if let themedCell = cell as? ThemedCollectionViewCell {
            themedCell.setup(theme: ThemeService.theme)
        }
        cell.model = model
        return cell
    }
    
    static func curriedDefaultCell(withModel: ModelType) -> (UICollectionView,IndexPath) -> Self {
        return { collectionView,indexPath in
            return defaultCell(collectionView: collectionView, indexPath: indexPath, model: withModel)
        }
    }
    
    static func curriedDefaultCell(getModel:@escaping (IndexPath) -> ModelType) -> (UICollectionView,IndexPath) -> Self {
        return { collectionView,indexPath in
            return defaultCell(collectionView: collectionView, indexPath: indexPath, model: getModel(indexPath))
        }
    }
    
    static func curriedSupplementaryView(withModel model:ModelType) -> (UICollectionView,String,IndexPath) -> Self {
        return { collectionView,kind,indexPath in
            let ident = String(describing: Self.self)
            var view:Self = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ident, for: indexPath) as! Self
            if let themedView = view as? ThemedCollectionReusableView {
                themedView.setup(theme: ThemeService.theme)
            }
            view.model = model
            return view
        }
    }

    
}
