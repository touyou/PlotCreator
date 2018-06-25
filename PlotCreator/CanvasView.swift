//
//  CanvasView.swift
//  PlotCreator
//
//  Created by 藤井陽介 on 2018/06/18.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit

class CanvasView: UIView {

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

        var pointCount = 0
        for findex in 0 ..< positionHistory[currentPosition] {
            for p in forcePaths[findex].points {
                plot(p)
            }
            pointCount += forcePaths[findex].points.count
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)

        forcePaths = Array<ForcePath>(forcePaths.prefix(positionHistory[currentPosition]))
        positionHistory = Array<Int>(positionHistory.prefix(currentPosition + 1))
        forcePaths.append(ForcePath(point: currentPoint, force: touch.force / touch.maximumPossibleForce))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)

        forcePaths.append(ForcePath(point: currentPoint, force: touch.force / touch.maximumPossibleForce))
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)

        forcePaths.append(ForcePath(point: currentPoint, force: touch.force / touch.maximumPossibleForce))
        positionHistory.append(forcePaths.count)
        currentPosition = positionHistory.count - 1
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
}

// MARK: - Plot Function

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

