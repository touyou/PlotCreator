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
//    /// copy bezier movement
//    let elements: PathElement
//    /// 0.0: normal, 1.0: force
//    let force: CGFloat
//    /// points
//    var points = [CGPoint]()
//    /// path point num
//    var num: Int = 0
//    init(elements: PathElement, force: CGFloat) {
//        self.elements = elements
//        self.force = force
//    }
    let point: CGPoint
    let force: CGFloat

    private(set) var points: [CGPoint] = []

    init(point: CGPoint, force: CGFloat) {
        self.point = point
        self.force = force

        let pointCount = Int(5 * force) + 1
        for _ in 0 ..< pointCount {
            points.append(point.random(20.0 * (force + 0.1)))
        }
    }
}
