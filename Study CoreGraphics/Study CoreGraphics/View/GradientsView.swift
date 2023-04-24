//
//  GradientsView.swift
//  Study CoreGraphics
//
//  Created by 박재우 on 2023/04/24.
//

import UIKit

class GradientsView: UIView {

    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()

            let locations: [CGFloat] = [ 0.0, 0.25, 0.5, 0.75 ]

            let colors = [UIColor.red.cgColor,
                          UIColor.green.cgColor,
                          UIColor.blue.cgColor,
                          UIColor.yellow.cgColor]

            let colorspace = CGColorSpaceCreateDeviceRGB()

            let gradient = CGGradient(colorsSpace: colorspace,
                          colors: colors as CFArray, locations: locations)

            var startPoint = CGPoint()
            var endPoint =  CGPoint()

            startPoint.x = 0.0
            startPoint.y = 0.0
            endPoint.x = 700
            endPoint.y = 600

            if let gradient = gradient {
                context?.drawLinearGradient(gradient,
                                        start: startPoint, end: endPoint,
                                        options: .drawsBeforeStartLocation)
            }
    }

}
