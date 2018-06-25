//
//  CanvasView.swift
//  PlotCreator
//
//  Created by 藤井陽介 on 2018/06/18.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    var path: UIBezierPath?
    var temporaryPath: UIBezierPath?
    var points = [CGPoint]()
    var forcePaths = [ForcePath]()
    var pointCount = 0

    var isCallTouchMoved = false

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        isUserInteractionEnabled = true
    }

    /// Call when we call setNeedsDisplay()
    override func draw(_ rect: CGRect) {
        super.draw(rect)

//        if let bezier = self.path {
//            //            drawBezier(bezier)
//            UIColor.black.setStroke()
//            bezier.stroke()
//        }
//        if let bezier = self.temporaryPath {
//            //            drawBezier(bezier)
//            UIColor.black.setStroke()
//            bezier.stroke()
//        }
//
//        drawForcePath()
        var pointCount = 0
        for fp in forcePaths {
            for p in fp.points {
                plot(p)
            }
            pointCount += fp.points.count
        }
        print(pointCount)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)

        forcePaths.append(ForcePath(point: currentPoint, force: touch.force / touch.maximumPossibleForce))
//        path = UIBezierPath()
//        path?.move(to: currentPoint)
//        points = [currentPoint]
//        forcePaths.append(ForcePath(elements: .moveToPoint(currentPoint), force: touch.force / touch.maximumPossibleForce))
//        pointCount = 0
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        isCallTouchMoved = true
//        pointCount += 1
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)

        forcePaths.append(ForcePath(point: currentPoint, force: touch.force / touch.maximumPossibleForce))
//        points.append(currentPoint)
//        if points.count == 2 {
//            temporaryPath = UIBezierPath()
//            temporaryPath?.move(to: points[0])
//            temporaryPath?.addLine(to: points[1])
//        } else if points.count == 3 {
//            temporaryPath = UIBezierPath()
//            temporaryPath?.move(to: points[0])
//            temporaryPath?.addQuadCurve(to: points[2], controlPoint: points[1])
//        } else if points.count == 4 {
//            temporaryPath = UIBezierPath()
//            temporaryPath?.move(to: points[0])
//            temporaryPath?.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
//        } else if points.count == 5 {
//            points[3] = CGPoint(x: (points[2].x + points[4].x) * 0.5, y: (points[2].y + points[4].y) * 0.5)
//            if points[4] != points[3] {
//                let length = hypot(points[4].x - points[3].x, points[4].y - points[3].y) / 2.0
//                let angle = atan2(points[3].y - points[2].y, points[4].x - points[3].x)
//                let controlPoint = CGPoint(x: points[3].x + cos(angle) * length, y: points[3].y + sin(angle) * length)
//                temporaryPath = UIBezierPath()
//                temporaryPath?.move(to: points[3])
//                temporaryPath?.addQuadCurve(to: points[4], controlPoint: controlPoint)
//            } else {
//                temporaryPath = nil
//            }
//            path?.move(to: points[0])
//            path?.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
//            forcePaths.append(ForcePath(elements: .moveToPoint(points[0]), force: touch.force / touch.maximumPossibleForce))
//            forcePaths.append(ForcePath(elements: .addCurveToPoint(points[3], points[1], points[2]), force: touch.force / touch.maximumPossibleForce))
//            points = [points[3], points[4]]
//        }
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)

        forcePaths.append(ForcePath(point: currentPoint, force: touch.force / touch.maximumPossibleForce))
//        if !isCallTouchMoved {
//            path?.addLine(to: currentPoint)
//            forcePaths.append(ForcePath(elements: .addLineToPoint(currentPoint), force: touch.force / touch.maximumPossibleForce))
//        }
//        temporaryPath = nil
//        path = nil
//        isCallTouchMoved = false
        setNeedsDisplay()
    }

    func drawBezier(_ bezier: UIBezierPath) {
        var startPoint: CGPoint?
        var lastPoint: CGPoint?

        for element in bezier.cgPath.pathElements {
            switch element {
            case .moveToPoint(let point1):
                plot(point1)
                startPoint = point1
                lastPoint = point1
            case .addLineToPoint(let point1):
                if let point0 = lastPoint {
                    plot(point0, point1)
                }
                lastPoint = point1
            case .addQuadCurveToPoint(let point1, let point2):
                if let point0 = lastPoint {
                    plot(point0, point1, point2)
                }
                lastPoint = point2
            case .addCurveToPoint(let point1, let point2, let point3):
                if let point0 = lastPoint {
                    plot(point0, point1, point2, point3)
                }
                plot(point3)
                lastPoint = point3
            case .closeSubpath:
                if let startPoint = startPoint,
                    let lastPoint = lastPoint {
                    plot(lastPoint, startPoint)
                }
            }
        }
    }

//    func drawForcePath() {
//        var startPoint: CGPoint?
//        var lastPoint: CGPoint?
//
//        for i in 0 ..< forcePaths.count {
//            switch forcePaths[i].elements {
//            case .moveToPoint(let point1):
//                forcePaths[i].num = 1
//                plot(with: forcePaths[i].force, point1, i)
//                startPoint = point1
//                lastPoint = point1
//            case .addLineToPoint(let point1):
//                if let point0 = lastPoint {
//                    plot(with: forcePaths[i].force, point0, point1, i)
//                }
//                lastPoint = point1
//            case .addQuadCurveToPoint(let point1, let point2):
//                if let point0 = lastPoint {
//                    plot(with: forcePaths[i].force, point0, point1, point2, i)
//                }
//                lastPoint = point2
//            case .addCurveToPoint(let point1, let point2, let point3):
//                if let point0 = lastPoint {
//                    plot(with: forcePaths[i].force, point0, point1, point2, point3, i)
//                }
//                plot(with: forcePaths[i].force, point3, i)
//                lastPoint = point3
//            case .closeSubpath:
//                if let startPoint = startPoint,
//                    let lastPoint = lastPoint {
//                    plot(with: forcePaths[i].force, lastPoint, startPoint, i)
//                }
//            }
//        }
//    }
}

// MARK: - Plot Function

//extension CanvasView {
//
//    /// plot dot
//    func plot(with force: CGFloat, _ point: CGPoint, _ index: Int) {
//        let sqrt2 = sqrt(CGFloat(2.0))
//        UIColor.black.set()
//        let pointCount = Int(5 * force) + 1
//        if forcePaths[index].num * pointCount > forcePaths[index].points.count {
//            for _ in 0 ..< pointCount {
//                forcePaths[index].points.append(point.random(20.0 * (force + 0.1)))
//            }
//        }
//        for p in forcePaths[index].points {
//            plot(p)
//        }
//    }
//
//    /// plot line
//    func plot(with force: CGFloat, _ p0: CGPoint, _ p1: CGPoint, _ index: Int) {
//        let v = p1 - p0
//        let n = Int(v.length)
//        forcePaths[index].num = n
//        for i in 0 ..< n {
//            let t = CGFloat(i) / CGFloat(n)
//            let q = p0 + v * t
//            plot(with: force, q, index)
//        }
//    }
//
//    /// plot bezier curve with one control point
//    func plot(with force: CGFloat, _ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ index: Int) {
//        let n = Int((p1 - p0).length + (p2 - p1).length)
//        forcePaths[index].num = n
//        for i in 0 ..< n {
//            let t = CGFloat(i) / CGFloat(n)
//
//            let q1 = p0 + (p1 - p0) * t
//            let q2 = p1 + (p2 - p1) * t
//
//            let r = q1 + (q2 - q1) * t
//            plot(with: force, r, index)
//        }
//    }
//
//    /// plot bezier curve with twot control point
//    func plot(with force: CGFloat, _ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint, _ index: Int) {
//        let n = Int((p1 - p0).length + (p2 - p1).length + (p3 - p2).length)
//        forcePaths[index].num = n
//        for i in 0 ..< n {
//            let t = CGFloat(i) / CGFloat(n)
//
//            let q1 = p0 + (p1 - p0) * t
//            let q2 = p1 + (p2 - p1) * t
//            let q3 = p2 + (p3 - p2) * t
//
//            let r1 = q1 + (q2 - q1) * t
//            let r2 = q2 + (q3 - q2) * t
//
//            let s = r1 + (r2 - r1) * t
//            plot(with: force, s, index)
//        }
//    }
//}


extension CanvasView {

    /// plot dot
    func plot(_ point: CGPoint) {
        let sqrt2 = sqrt(CGFloat(2.0))
        UIColor.black.set()
        UIBezierPath(ovalIn: CGRect(x: point.x - 1, y: point.y - 1, width: sqrt2, height: sqrt2)).fill()
    }

    /// plot line
    func plot(_ p0: CGPoint, _ p1: CGPoint) {
        let v = p1 - p0
        let n = Int(v.length)
        for i in 0 ..< n {
            let t = CGFloat(i) / CGFloat(n)
            let q = p0 + v * t
            plot(q)
        }
    }

    /// plot bezier curve with one control point
    func plot(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint) {
        let n = Int((p1 - p0).length + (p2 - p1).length)
        for i in 0 ..< n {
            let t = CGFloat(i) / CGFloat(n)

            let q1 = p0 + (p1 - p0) * t
            let q2 = p1 + (p2 - p1) * t

            let r = q1 + (q2 - q1) * t
            plot(r)
        }
    }

    /// plot bezier curve with twot control point
    func plot(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) {
        let n = Int((p1 - p0).length + (p2 - p1).length + (p3 - p2).length)
        for i in 0 ..< n {
            let t = CGFloat(i) / CGFloat(n)

            let q1 = p0 + (p1 - p0) * t
            let q2 = p1 + (p2 - p1) * t
            let q3 = p2 + (p3 - p2) * t

            let r1 = q1 + (q2 - q1) * t
            let r2 = q2 + (q3 - q2) * t

            let s = r1 + (r2 - r1) * t
            plot(s)
        }
    }

}

