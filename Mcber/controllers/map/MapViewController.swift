//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapViewController: BaseCollectionViewController {
    
    private let kPathSection = 0
    private let kPointSection = 1
    
    let map:FullMapModel
    var originalScale:Double = 1
    
    var mapLayout:MapCollectionViewLayout! {
        return self.layout as! MapCollectionViewLayout
    }
    
    override init(services: ServiceLocator) {
        self.map = services.map.generateTestMap()
        super.init(services: services)
        self.layout = MapCollectionViewLayout(map: self.map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(clazz: MapPointCell.self)
        collectionView.register(clazz: MapPathCell.self)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinched(gesture:)))
        collectionView.addGestureRecognizer(pinchGesture)
    }
    
    //MARK: UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == kPathSection ? map.paths.count : map.points.count
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section == kPathSection) {
            let cell:MapPathCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.model = map.paths[indexPath.row]
            return cell;
        } else {
            let cell:MapPointCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.model = map.points[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == kPointSection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let point = self.map.points[indexPath.row]
        centreViewAt(x: point.x, y: point.y)
    }
    
    //Centre in absolute map coords
    func centreViewAt(x:Int,y:Int) {
        let px = CGFloat(x - mapLayout.xOffset)
        let py = CGFloat(y - mapLayout.yOffset)
        let offset = CGPoint(x: px - collectionView.frame.width/2, y: py - collectionView.frame.height/2)
        
        collectionView.setContentOffset(offset, animated: true)
    }
    
    //MARK: Actions
    
    @objc func pinched(gesture:UIPinchGestureRecognizer) {
        if gesture.state == .began {
            originalScale = self.mapLayout.zoomScale
        } else if gesture.state == .changed {
            print(gesture.scale)
            let newScale = originalScale * Double(gesture.scale)
            self.mapLayout.zoomScale = Double(min(max(newScale,0.25),1))
            self.layout.invalidateLayout()
        }
    }

}
