//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

protocol SimpleModelCell {
    associatedtype ModelType
    var model:ModelType? {get set}
}

extension SimpleModelCell {
    static func defaultCell(collectionView:UICollectionView,indexPath:IndexPath,model:ModelType?) -> Self {
        let ident = String(describing: Self.self)
        var cell:Self = collectionView.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as! Self
        if let themedCell = cell as? ThemedCollectionViewCell {
            themedCell.setup(theme: ThemeService.theme)
        }
        cell.model = model
        return cell
    }
    
    static func curriedDefaultCell(withModel: ModelType?) -> (UICollectionView,IndexPath) -> Self {
        return { collectionView,indexPath in
            return defaultCell(collectionView: collectionView, indexPath: indexPath, model: withModel)
        }
    }
    
    static func curriedDefaultCell(getModel:@escaping (IndexPath) -> ModelType?) -> (UICollectionView,IndexPath) -> Self {
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

protocol AutoSizeModelCell: SimpleModelCell {
    static var sizingCell:Self { get set }
}

extension AutoSizeModelCell {
    static func calculateSize(model:ModelType?, collectionView:UICollectionView) -> CGSize {
        var view = (sizingCell as! UIView)
        if let cell = sizingCell as? UICollectionViewCell {
            view = cell.contentView
        }
        view.frame.size.width = collectionView.frame.size.width
        sizingCell.model = model
        var fittingSize = UILayoutFittingCompressedSize
        fittingSize.width = collectionView.frame.size.width
        var size = view.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        size.width = fittingSize.width
        return size
        //return CGSize(width: 320, height: 200)
    }
    
    static func curriedCalculateSize(getModel:@escaping (IndexPath) -> ModelType?) -> (UICollectionView,UICollectionViewLayout, IndexPath) -> CGSize {
        return { collectionView,layout,indexPath in
            return calculateSize(model: getModel(indexPath), collectionView: collectionView)
        }
    }
}
