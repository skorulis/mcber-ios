//  Created by Alexander Skorulis on 18/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapPathCell: ThemedCollectionViewCell, SimpleModelCell {
    
    var layoutAttributes:MapLayoutAttributes?
    
    let shapeLayer = CAShapeLayer()
    
    typealias ModelType = MapPathModel
    var model:MapPathModel? {
        didSet {
            self.updateLine()
        }
    }
    
    override func buildView(theme: ThemeService) {
        self.clipsToBounds = true
        self.contentView.layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.red.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = self.contentView.bounds
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let atts = layoutAttributes as? MapLayoutAttributes {
            self.layoutAttributes = atts
            self.updateLine()
        }
    }
    
    func updateLine() {
        guard let model = self.model else {return}
        guard let atts = self.layoutAttributes else {return}
        let point1 = toCGPoint(model.point1,atts:atts)
        let point2 = toCGPoint(model.point2,atts:atts)
        
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        shapeLayer.path = path.cgPath
    }
    
    private func toCGPoint(_ point:MapPointModel, atts:MapLayoutAttributes) -> CGPoint {
        let x = CGFloat(point.x - atts.offsetX)*CGFloat(atts.zoomScale) - self.frame.origin.x
        let y = CGFloat(point.y - atts.offsetY)*CGFloat(atts.zoomScale) - self.frame.origin.y
        return CGPoint(x:x,y:y)
    }
    
}
