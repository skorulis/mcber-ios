//  Created by Alexander Skorulis on 18/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapPathCell: ThemedCollectionViewCell, SimpleModelCell {
    
    var offsetX:Int = 0
    var offsetY:Int = 0
    
    let shapeLayer = CAShapeLayer()
    
    typealias ModelType = MapPathModel
    var model:MapPathModel? {
        didSet {
            self.updateLine()
        }
    }
    
    override func buildView(theme: ThemeService) {
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
            offsetX = atts.offsetX
            offsetY = atts.offsetY
            self.updateLine()
        }
    }
    
    func updateLine() {
        guard let model = self.model else {return}
        let point1 = toCGPoint(model.point1)
        let point2 = toCGPoint(model.point2)
        
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        shapeLayer.path = path.cgPath
    }
    
    private func toCGPoint(_ point:MapPointModel) -> CGPoint {
        let x = CGFloat(point.x - offsetX) - self.frame.origin.x
        let y = CGFloat(point.y - offsetY) - self.frame.origin.y
        return CGPoint(x:x,y:y)
    }
    
}
