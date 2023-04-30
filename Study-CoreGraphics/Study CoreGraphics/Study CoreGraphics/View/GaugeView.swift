//
//  GaugeView.swift
//  Study CoreGraphics
//
//  Created by 박재우 on 2023/05/01.
//

import UIKit

@IBDesignable
class GaugeView: UIView {
    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76

        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }

    @IBInspectable var counter: Int = 5 {
        didSet {
            if counter <= Constants.numberOfGlasses {
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange

    override func draw(_ rect: CGRect) {
        // 1 : 호를 회전할 중심점을 정의합니다.
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        // 2 : 뷰의 최대 치수를 기준으로 반지름을 계산합니다.
        let radius = max(bounds.width, bounds.height)

        // 3 : 호의 시작 각도와 끝 각도를 정의합니다.
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4

        // 4 : 정의한 중심점, 반지름 및 각도를 기준으로 경로를 만듭니다.
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius / 2 - Constants.arcWidth / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)

        // 5 : 경로를 마지막으로 칠하기 전에 선 너비와 색상을 설정합니다.
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()

        //MARK: - Draw the outline

        //1 - first calculate the difference between the two angles
        // 그려진 그림의 각도
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        // 단계별 각도
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
        // 원하는 단계만큼의 끝(?) 계산
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle

        //2 - draw the outer arc
        let outerArcRadius = bounds.width / 2 - Constants.halfOfLineWidth
        let outlinePath = UIBezierPath(
            arcCenter: center,
            radius: outerArcRadius,
            startAngle: startAngle,
            endAngle: outlineEndAngle,
            clockwise: true)

        //3 - draw the inner arc
        let innerArcRadius = bounds.width / 2 - Constants.arcWidth
        + Constants.halfOfLineWidth

        outlinePath.addArc(
            withCenter: center,
            radius: innerArcRadius,
            startAngle: outlineEndAngle,
            endAngle: startAngle,
            clockwise: false)

        //4 - close the path
        outlinePath.close()

        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
    }
}

@IBDesignable
class GaugeButton: UIButton {

    @IBInspectable var fillColor: UIColor = .green
    @IBInspectable var isAddButton: Bool = true

    private struct Constants {
      static let plusLineWidth: CGFloat = 3.0
      static let plusButtonScale: CGFloat = 0.6
      static let halfPointShift: CGFloat = 0.5
    }

    private var halfWidth: CGFloat {
      return bounds.width / 2
    }

    private var halfHeight: CGFloat {
      return bounds.height / 2
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()

        let plusWidth = min(bounds.width, bounds.height)
          * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2

        //create the path
        let plusPath = UIBezierPath()

        //set the path's line width to the height of the stroke
        plusPath.lineWidth = Constants.plusLineWidth

        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint (
          x: halfWidth - halfPlusWidth +  Constants .halfPointShift,
          y: halfHeight +  Constants .halfPointShift))

        plusPath.addLine(to: CGPoint (
          x: halfWidth + halfPlusWidth + Constants .halfPointShift,
          y: halfHeight + Constants .halfPointShift))

        if isAddButton {
            plusPath.move(to: CGPoint (
                x: halfWidth + Constants .halfPointShift,
                y: halfHeight - halfPlusWidth + Constants .halfPointShift))

            plusPath.addLine(to: CGPoint (
                x: halfWidth + Constants .halfPointShift,
                y: halfHeight + halfPlusWidth + Constants .halfPointShift))
        }
        //set the stroke color
        UIColor.white.setStroke()

        //draw the stroke
        plusPath.stroke()
    }
}
