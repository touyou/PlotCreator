//
//  CircledAreaPath.swift
//  PlotCreator
//
//  Created by 藤井陽介 on 2018/07/02.
//  Copyright © 2018 touyou. All rights reserved.
//

import Foundation
import CoreGraphics

struct CircledAreaPath: CustomPathConvertible {

    let basePath: CGPath

    private(set) var _points: [CGPoint] = []
    var points: [CGPoint] {

        return Array<CGPoint>(self._points.prefix(Int(ForcePath.limitation * Double(self._points.count))))
    }

    init(path: CGPath) {
        self.basePath = path

        _points.shuffle()
    }
}
