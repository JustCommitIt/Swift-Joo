//
//  GraphView.swift
//  Study CoreGraphics
//
//  Created by 박재우 on 2023/04/28.
//

import UIKit

class GraphView: UIView {

    private var datas: [Double]?
    private var color: UIColor?
    private var points: [CGPoint] = []
    private var movingLine: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    private var movingCircle: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        view.layer.cornerRadius = view.layer.bounds.width / 2
        view.layer.borderColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        view.layer.borderWidth = 1.5
        view.clipsToBounds = true
        return view
    }()

    convenience init(data: [Double], color: UIColor) {
        self.init()
        self.datas = data
        self.color = color
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.5049715909, green: 0.5049715909, blue: 0.5049715909, alpha: 0.3490790563)

        addSubview(movingLine)
        addSubview(movingCircle)
        movingLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movingLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            movingLine.widthAnchor.constraint(equalToConstant: 3),
            movingLine.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let datas = datas, let color = color else { return }
        color.setStroke()

        points = convertPoint(from: datas)
        let curveLinePath = UIBezierPath(quadCurve: points)

        curveLinePath?.lineWidth = 2
        curveLinePath?.lineJoinStyle = .round
        curveLinePath?.lineCapStyle = .round
        curveLinePath?.stroke()

        points.forEach { point in
            let pointPath = UIBezierPath(ovalIn: CGRect(x: point.x - 2, y: point.y - 2, width: 4, height: 4))
            UIColor.gray.set()
            pointPath.fill()
        }

        drawHorizontalLine()
        drawVerticalLine()

        guard let clippingPath = curveLinePath?.copy() as? UIBezierPath else { return }
        clippingPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        clippingPath.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        clippingPath.close()
        clippingPath.addClip()

        guard let context = UIGraphicsGetCurrentContext() else {
              return
            }
        let colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6038907284).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1644246689).cgColor]

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let colorLocations: [CGFloat] = [0.0, 1.0]

        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: colorLocations
        ) else {
            return
        }


        let hightestYPoint = points.max { $0.y > $1.y }
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: hightestYPoint!.y),
            end: CGPoint(x: 0, y: bounds.height),
            options: [])
        context.restoreGState()
    }

    func prepare(data: [Double], color: UIColor) {
        self.datas = data
        self.color = color
    }

    private func convertPoint(from datas: [Double]) -> [CGPoint] {
        guard datas.count > 0,
              let bottom = datas.minimunPoint(),
              let top = datas.maximunPoint() else {
            return []
        }

        let width = bounds.width
        let height = bounds.height
        var points: [CGPoint] = []

        points = datas.enumerated().map { index, data in
            let x = width / CGFloat(datas.count - 1) * CGFloat(index)
            let y = height / (top - bottom) * (top - data)
            return CGPoint(x: x, y: y)
        }

        return points
    }

    private func drawHorizontalLine() {
        guard let max = datas?.maximunPoint(), let min = datas?.minimunPoint() else { return }
        let widthStart = bounds.minX
        let widthEnd = bounds.maxX
        let count = Int(abs(max - min) / 5)
        let lineSpacing = bounds.height / CGFloat(count)

        let path = UIBezierPath()

        for i in 1...count {
            let y = CGFloat(i) * lineSpacing
            path.move(to: CGPoint(x: widthStart, y: y))
            path.addLine(to: CGPoint(x: widthEnd, y: y))
        }

        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setStroke()
        path.stroke()
    }

    private func drawVerticalLine() {
        let heightStart = bounds.minY
        let heightEnd = bounds.maxY
        let path = UIBezierPath()
        let pattern: [CGFloat] = [1, 3]

        for j in 1...3 {
            let x = bounds.maxX / 4 * CGFloat(j)
            path.move(to: CGPoint(x: x, y: heightStart))
            path.addLine(to: CGPoint(x: x, y: heightEnd))
            path.setLineDash(pattern, count: pattern.count, phase: 0)
        }

        #colorLiteral(red: 0.5, green: 0.5, blue: 0.5000000596, alpha: 0.8).setStroke()
        path.stroke()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedPoint = touches.first?.location(in: self) else { return }

        movingLine.isHidden = false
        movingLine.center = CGPoint(x: touchedPoint.x, y: movingLine.center.y)

        movingCircle.isHidden = false
        let circleY = UIBezierPath().movingCircleY(from: touchedPoint.x, points: points)
        movingCircle.center = CGPoint(x: touchedPoint.x, y: circleY)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingLine.isHidden = true
        movingCircle.isHidden = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedPoint = touches.first?.location(in: self) else { return }

        if touchedPoint.x >= 0, touchedPoint.x <= bounds.maxX {
            movingLine.center = CGPoint(x: touchedPoint.x, y: movingLine.center.y)
            let circleY = UIBezierPath().movingCircleY(from: touchedPoint.x, points: points)
            movingCircle.center = CGPoint(x: touchedPoint.x, y: circleY)
        }
    }
}

public extension UIBezierPath {
    convenience init?(quadCurve points: [CGPoint]) {
        guard points.count > 1 else {
            return nil
        }

        self.init()

        // 시작점 표시
        var p0 = points[0]
        move(to: p0)

        // 값이 2개라면 직선으로 표시
        guard points.count != 2 else {
            addLine(to: points[1])
            return
        }

        // 중간점을 잡고 2개의 곡선 만들기
        for i in 1..<points.count {
            let p2 = midPoint(from: p0, to: points[i])

            addQuadCurve(to: p2, controlPoint: controlPoint(p0: p0, p2: p2))
            addQuadCurve(to: points[i], controlPoint: controlPoint(p0: points[i], p2: p2))

            p0 = points[i]
        }
    }

    func movingCircleY(from circleX: Double, points: [CGPoint]) -> Double {
        var circleY: Double = 0.0

        guard let firstIndex = points.lastIndex(where: { $0.x < circleX }) else { return circleY }

        let midPoint = midPoint(from: points[firstIndex], to: points[firstIndex + 1])

        if circleX > midPoint.x {
            let p2 = midPoint
            let p0 = points[firstIndex + 1]
            circleY = cacultatedY(circleX: circleX, p0: p0, p2: p2)
        } else {
            let p0 = points[firstIndex]
            let p2 = midPoint
            circleY = cacultatedY(circleX: circleX, p0: p0, p2: p2)
        }

        return circleY
    }

    private func cacultatedY(circleX: Double, p0: CGPoint, p2: CGPoint) -> Double {
        let p1 = controlPoint(p0: p0, p2: p2)
        let t = (circleX - p0.x) / (p2.x - p0.x)
        return pow(1 - t, 2) * p0.y + 2 * (1 - t) * t * p1.y + pow(t, 2) * p2.y
    }

    private func midPoint(from p1: CGPoint, to p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }

    // 상향곡선으로 그릴 때에는 p0에 목적지로 두어야 하고,
    // 하향곡선에서는 p2에 목적지를 두어야 한다
    private func controlPoint(p0: CGPoint, p2: CGPoint) -> CGPoint {
        var p1 = midPoint(from: p0, to: p2)
        p1.y = p0.y

        return p1
    }
}

extension Array where Element == Double {
    func minimunPoint() -> Double? {
        guard var min = self.min() else {
            return nil
        }

        min /= 5
        min = floor(min) - 1
        min *= 5
        min -= 10

        return min
    }

    func maximunPoint() -> Double? {
        guard var max = self.max() else {
            return nil
        }

        max /= 5
        max = floor(max) + 1
        max *= 5
        max += 10

        return max
    }
}
