//
//  ForcePath.swift
//  PlotCreator
//
//  Created by 藤井陽介 on 2018/06/22.
//  Copyright © 2018 touyou. All rights reserved.
//

import Foundation
import CoreGraphics

struct ForcePath {
    static var density: CGFloat = 5.0
    static var limitation: Double = 1.0

    let point: CGPoint
    let force: CGFloat

    private(set) var _points: [CGPoint] = []
    var points: [CGPoint] {

        return Array<CGPoint>(self._points.prefix(Int(ForcePath.limitation * Double(self._points.count))))
    }

    init(point: CGPoint, force: CGFloat) {
        self.point = point
        self.force = force
        self._points = []

        let pointCount = Int(ForcePath.density * force) + 1
        let radius = 20.0 * (force + 0.1)
        for _ in 0 ..< pointCount {
            let newPoint = point.random(radius).circled(point, radius)
            _points.append(newPoint)
        }
        _points.shuffle()
    }
}
