//  Created by Alexander Skorulis on 13/5/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import SnapKit

extension UICollectionView {
    public func register(clazz:AnyClass) {
        let ident = String(describing: clazz)
        register(clazz, forCellWithReuseIdentifier: ident)
    }
    
    func register(clazz:AnyClass,forKind kind:String) {
        let ident = String(describing: clazz)
        self.register(clazz, forSupplementaryViewOfKind: kind, withReuseIdentifier: ident)
    }
    
    public func dequeueReusableView<T:ThemedCollectionReusableView>(kind:String,indexPath:IndexPath) -> T {
        let ident = String(describing: T.self)
        let view:T = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ident, for: indexPath) as! T
        return view
    }
    
    public func dequeueSetupView<T:ThemedCollectionReusableView>(kind:String,indexPath:IndexPath,theme:ThemeService) -> T {
        let view:T = dequeueReusableView(kind: kind, indexPath: indexPath)
        view.setup(theme: theme)
        return view
    }
    
    public func dequeueSetupCell<T:ThemedCollectionViewCell>(indexPath:IndexPath,theme:ThemeService,fillWidth:Bool = false) -> T {
        let ident = String(describing: T.self)
        let cell:T = dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as! T
        if fillWidth {
            cell.contentView.snp.remakeConstraints { (make) in
                make.width.equalTo(self.frame.size.width)
            }
        }
        cell.setup(theme: theme)
        return cell
    }

}

open class BaseCollectionViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var layout:UICollectionViewLayout!
    public var collectionView:UICollectionView!
    var autoFillWidth = false
    
    var flowLayout:UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if layout == nil {
            layout = UICollectionViewFlowLayout()
        }
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout!)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if self.autoFillWidth {
            collectionView?.visibleCells.forEach { (cell) in
                cell.contentView.snp.remakeConstraints({ (make) in
                    make.width.equalTo(size.width)
                })
                cell.setNeedsLayout()
            }
        }
        coordinator.animate(alongsideTransition: { (coord) in
            self.layout?.invalidateLayout()
        }, completion: nil)
    }
    
    //MARK: abstract
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        preconditionFailure("This method must be overridden")
    }
    
}
