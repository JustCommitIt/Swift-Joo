//
//  CircleView.swift
//  Study CoreGraphics
//
//  Created by 박재우 on 2023/04/17.
//

import UIKit

class CircleView: UIView {

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let shadowOffset = CGSize(width: -10, height: 15)
        let color = #colorLiteral(red: 0.1297133896, green: 0.7087992025, blue: 0.8522297656, alpha: 1).cgColor

        context.saveGState()
        context.setShadow(offset: shadowOffset, blur: 5.0)
        context.setLineWidth(4.0)
        context.setStrokeColor(color)

        let rectangle = CGRect(x: bounds.width / 4, y: bounds.height / 4, width: bounds.width / 2, height: bounds.height / 2)
        context.addEllipse(in: rectangle)
        context.strokePath()
        context.restoreGState()
    }
}
