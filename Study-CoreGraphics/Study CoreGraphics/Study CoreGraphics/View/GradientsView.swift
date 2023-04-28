//
//  GradientsView.swift
//  Study CoreGraphics
//
//  Created by 박재우 on 2023/04/24.
//

import UIKit

class GradientsView: UIView {

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let locations: [CGFloat] = [0.0, 0.33, 0.66, 1.0]

        let colors = [UIColor.red.cgColor,
                      UIColor.green.cgColor,
                      UIColor.blue.cgColor,
                      UIColor.yellow.cgColor]

        let colorspace = CGColorSpaceCreateDeviceRGB()

        guard let gradient = CGGradient(colorsSpace: colorspace,
                                        colors: colors as CFArray,
                                        locations: locations) else {
            return
        }

        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: bounds.width, y: bounds.height)

        context.drawLinearGradient(gradient,
                                    start: startPoint, end: endPoint,
                                    options: .drawsBeforeStartLocation)
    }

}
