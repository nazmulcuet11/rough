//
//  CrossHairView.swift
//  HomePwner
//
//  Created by Nazmul Islam on 29/5/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class CrosshairView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRect.zero)
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        // Vertical
        path.move(to: CGPoint(x: center.x, y: center.y - 20))
        path.addLine(to: CGPoint(x: center.x, y: center.y + 20))
        
        // Horizontal
        path.move(to: CGPoint(x: center.x - 20, y: center.y))
        path.addLine(to: CGPoint(x: center.x + 20, y: center.y))
        
        UIColor.blue.setStroke()
        path.stroke()
    }
}
