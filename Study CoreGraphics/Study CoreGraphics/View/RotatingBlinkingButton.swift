//
//  RotatingBlinkingButton.swift
//  Study CoreGraphics
//
//  Created by 박재우 on 2023/04/16.
//

import UIKit

@IBDesignable
class RotatingBlinkingButton: UIButton {

    @IBInspectable var colorOfBorder: UIColor = .systemPink
    @IBInspectable var colorOfBackground: UIColor = .white
    private var isPressed: Bool = true
    private var direction: CGFloat = 0.0

    override func draw(_ rect: CGRect) {
        layer.borderColor = colorOfBorder.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 20
        layer.backgroundColor = colorOfBackground.cgColor

        guard let myContext = UIGraphicsGetCurrentContext() else { return }

        let width = bounds.width
        let height = bounds.height

        if isPressed {
            myContext.move(to: CGPoint(x: width * 0.2, y: height * 0.5))
            myContext.addLine(to: CGPoint(x: width * 0.5, y: height * 0.8))
            myContext.addLine(to: CGPoint(x: width * 0.7, y: height * 0.2))
        }

        myContext.setLineWidth(5)
        myContext.setLineJoin(.round)
        myContext.setLineCap(.round)
        colorOfBorder.setStroke()
        myContext.drawPath(using: .stroke)


        if direction >= 2 * .pi {
            direction = .pi / 6
        } else {
            direction += .pi / 6
        }
        transform = CGAffineTransform(rotationAngle: direction)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isPressed = !isPressed
        setNeedsDisplay()
    }
}
