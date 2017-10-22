//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import FontAwesomeKit

enum MapViewMode {
    case normal
    case addPoint
    case movePoint(MapPointModel)
    case addPath(MapPointModel)
}

class MapViewController: BaseCollectionViewController {
    
    private let kPathSection = 0
    private let kPointSection = 1
    
    private var mode:MapViewMode = .normal
    
    let map:FullMapModel
    let toolbar = UIToolbar()
    var originalScale:CGFloat = 1
    
    var tapGesture:UITapGestureRecognizer!
    
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
        self.edgesForExtendedLayout = .left
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(gesture:)))
        
        self.view.addSubview(self.toolbar)
        toolbar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
        collectionView.snp.remakeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(toolbar.snp.top)
        }
        
        let infoItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(infoPressed(sender:)))
        let pathItem = UIBarButtonItem(icon: FAKFontAwesome.chainIcon(withSize: 25), target: self, selector: #selector(addPathPressed(sender:)))
        let addPointItem = UIBarButtonItem(icon: FAKFontAwesome.plusIcon(withSize: 25), target: self, selector: #selector(addPointPressed(sender:)))
        let moveItem = UIBarButtonItem(icon: FAKFontAwesome.arrowsIcon(withSize: 25), target: self, selector: #selector(movePointPressed(sender:)))
        
        toolbar.items = [infoItem,pathItem,addPointItem,moveItem]
        collectionView.reloadData()
        collectionView.layoutSubviews()
        let deadlineTime = DispatchTime.now() + .milliseconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.centreViewAt(point: CGPoint(x:0,y:0), offset: self.collectionView.center, animated: false)
        }
        
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
        switch(mode) {
        case .addPath(let startPoint):
            if startPoint !== point {
                let path = MapPathModel(point1: startPoint, point2: point)
                map.add(path: path)
                mode = .normal
                self.collectionView.reloadData()
            }
        default:
            break;
        }
        mode = .normal
        
        centreViewAt(point:point.center,offset:collectionView.center, animated: true)
    }
    
    //Centre in absolute map coords
    func centreViewAt(point:CGPoint,offset:CGPoint, animated:Bool) {
        let mapPoint = mapLayout.absoluteToMap(point: point)
        var contentOffset = CGPoint(x: mapPoint.x - offset.x, y: mapPoint.y - offset.y)
        
        let maxX = mapLayout.collectionViewContentSize.width - collectionView.frame.width
        let maxY = mapLayout.collectionViewContentSize.height - collectionView.frame.height
        
        contentOffset.x = min(max(contentOffset.x,0),maxX)
        contentOffset.y = min(max(contentOffset.y,0),maxY)
        
        collectionView.setContentOffset(contentOffset, animated: animated)
    }
    
    //MARK: Actions
    
    @objc func tapped(gesture:UITapGestureRecognizer) {
        collectionView.removeGestureRecognizer(tapGesture)
        let p1 = gesture.location(ofTouch: 0, in: self.collectionView)
        let converted = self.mapLayout.viewToAbsolute(point: p1)
        switch(mode) {
        case .addPoint:
            let point = MapPointModel(id: map.nextPointId(), name: "Unknown", x: Int(converted.x), y: Int(converted.y))
            self.map.add(point: point)
        case .movePoint(let oldPoint):
            oldPoint.center = converted
        default:
            break
        }
        
        self.mapLayout.invalidateLayout()
        self.collectionView.reloadData()
        mode = .normal
    }
    
    @objc func pinched(gesture:UIPinchGestureRecognizer) {
        if gesture.state == .began {
            originalScale = self.mapLayout.zoomScale
        } else if gesture.state == .changed {
            let p1 = gesture.location(ofTouch: 0, in: self.collectionView)
            let p2 = gesture.location(ofTouch: 1, in: self.collectionView)
            let centre = CGPoint(x: (p1.x+p2.x)/2, y: (p1.y+p2.y)/2)
            
            let converted = self.mapLayout.viewToAbsolute(point: centre)
            let screenPos = CGPoint(x:centre.x - collectionView.contentOffset.x, y:centre.y - collectionView.contentOffset.y)
        
            
            let newScale = originalScale * gesture.scale
            self.mapLayout.zoomScale = min(max(newScale,0.25),1)
            self.layout.invalidateLayout()
            centreViewAt(point: converted, offset:screenPos, animated: false)
        }
    }
    
    @objc func infoPressed(sender:Any) {
        if let selectedPath = collectionView.indexPathsForSelectedItems?.first {
            let vc = MapPointEditViewController(services: self.services,point:map.points[selectedPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addPathPressed(sender:Any) {
        if let selectedPath = collectionView.indexPathsForSelectedItems?.first {
            mode = .addPath(map.points[selectedPath.row])
        }
    }
    
    @objc func addPointPressed(sender:Any) {
        mode = .addPoint
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    @objc func movePointPressed(sender:Any) {
        if let selectedPath = collectionView.indexPathsForSelectedItems?.first {
            mode = .movePoint(map.points[selectedPath.row])
            collectionView.addGestureRecognizer(tapGesture)
        }
    }

}
