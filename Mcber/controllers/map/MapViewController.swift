//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapViewController: BaseCollectionViewController {
    
    let map:FullMapModel
    
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
        
        collectionView.minimumZoomScale = 0.25
        collectionView.maximumZoomScale = 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? map.paths.count : map.points.count
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section == 0) {
            let cell:MapPathCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.model = map.paths[indexPath.row]
            return cell;
        } else {
            let cell:MapPointCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.model = map.points[indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Center on spot
    }
    
    func centreViewAt(x:Int,y:Int) {
        
    }

}
