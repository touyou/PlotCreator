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
