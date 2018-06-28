//
//  CanvasView.swift
//  PlotCreator
//
//  Created by 藤井陽介 on 2018/06/18.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    static var pointSize: CGFloat = 2.0

    var path: UIBezierPath?
    var indicatorPath: UIBezierPath?
    var subIndicatorPath: UIBezierPath?
    var forcePaths = [ForcePath]()
    var currentPosition = 0
    var positionHistory: [Int] = [0]

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        isUserInteractionEnabled = true
    }

    /// Call when we call setNeedsDisplay()
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let path = path {
            UIColor.orange.setStroke()
            path.stroke()
        }

        if let subIndicator = subIndicatorPath {
            UIColor(red: 0.0, green: 0.2, blue: 0.2, alpha: 0.1).setFill()
            subIndicator.fill()
        }

        if let indicator = indicatorPath {
            UIColor(red: 0.0, green: 0.0, blue: 0.8, alpha: 0.5).setFill()
            indicator.fill()
        }

        var pointCount = 0
        for findex in 0 ..< positionHistory[currentPosition] {
            for p in forcePaths[findex].points {
                plot(p)
            }
            pointCount += forcePaths[findex]._points.count
        }
        if pointCount > 1000 {

            ForcePath.limitation = 1000.0 / Double(pointCount)
        } else {

            ForcePath.limitation = 1.0
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)

        forcePaths = Array<ForcePath>(forcePaths.prefix(positionHistory[currentPosition]))
        positionHistory = Array<Int>(positionHistory.prefix(currentPosition + 1))
        forcePaths.append(ForcePath(point: currentPoint, force: touch.force / touch.maximumPossibleForce))

        /// for user interaction
        path = UIBezierPath()
        path?.lineCapStyle = .round
        path?.lineJoinStyle = .round
        path?.lineWidth = 3.0
        path?.move(to: currentPoint)

        /// indicator
        setIndicator(currentPoint, touch.force / touch.maximumPossibleForce)

        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)

        forcePaths.append(ForcePath(point: currentPoint, force: touch.force / touch.maximumPossibleForce))

        path?.addLine(to: currentPoint)

        /// indicator
        setIndicator(currentPoint, touch.force / touch.maximumPossibleForce)

        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)

        forcePaths.append(ForcePath(point: currentPoint, force: touch.force / touch.maximumPossibleForce))
        positionHistory.append(forcePaths.count)
        currentPosition = positionHistory.count - 1

        path = nil
        indicatorPath = nil
        subIndicatorPath = nil

        setNeedsDisplay()
    }

    func redo() {
        if currentPosition < positionHistory.count - 1 {
            currentPosition += 1
        }
        setNeedsDisplay()
    }

    func undo() {
        if currentPosition > 0 {
            currentPosition -= 1
        }
        setNeedsDisplay()
    }

    private func setIndicator(_ point: CGPoint, _ force: CGFloat) {

        let radius = 20.0 * (force + 0.1) * 1.5

        indicatorPath = UIBezierPath(ovalIn:
            CGRect(x: point.x - radius, y: point.y - radius,
                   width: radius * 2.0, height: radius * 2.0))
        subIndicatorPath = UIBezierPath(ovalIn: CGRect(
            x: point.x - radius * 5.0, y: point.y - radius * 5.0,
            width: radius * 10.0, height: radius * 10.0))
    }
}

// MARK: - Plot Function

extension CanvasView {

    /// plot dot
    func plot(_ point: CGPoint) {
        let sqrt2 = sqrt(CanvasView.pointSize)
        UIColor.black.set()
        UIBezierPath(ovalIn: CGRect(
            x: point.x - CanvasView.pointSize / 2,
            y: point.y - CanvasView.pointSize / 2,
            width: sqrt2,
            height: sqrt2)).fill()
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

