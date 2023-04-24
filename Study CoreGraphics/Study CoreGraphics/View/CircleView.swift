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
        let color = #colorLiteral(red: 0.1297133896, green: 0.7087992025, blue: 0.8522297656, alpha: 1).cgColor
        context.setLineWidth(4.0)
        context.setStrokeColor(color)
        let rectangle = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        context.addEllipse(in: rectangle)
        context.strokePath()
    }
}
