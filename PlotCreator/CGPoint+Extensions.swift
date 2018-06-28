//
//  CGPoint+Extensions.swift
//  PlotCreator
//
//  Created by 藤井陽介 on 2018/06/19.
//  Copyright © 2018 touyou. All rights reserved.
//

import Foundation
import CoreGraphics

infix operator •
infix operator ×

// MARK: - CGPoint + Vector

public extension CGPoint {

    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    static func •(lhs: CGPoint, rhs: CGPoint) -> CGFloat {
        return lhs.x * rhs.x + lhs.y * rhs.y
    }

    static func ×(lhs: CGPoint, rhs: CGPoint) -> CGFloat {
        return lhs.x * rhs.y - lhs.y * rhs.x
    }

    var length2: CGFloat {
        return (x * x) + (y * y)
    }

    var length: CGFloat {
        return sqrt(self.length2)
    }

    var normalized: CGPoint {
        let length = self.length
        return CGPoint(x: x / length, y: y / length)
    }

    func random(_ h: CGFloat = 20.0) -> CGPoint {
        let randX = CGFloat.random(in: x - h ..< x + h)
        let randY = CGFloat.random(in: y - h ..< y + h)
        return CGPoint(x: randX, y: randY)
    }

    func circled(_ center: CGPoint, _ radius: CGFloat) -> CGPoint {
        let dist = (self - center).length
        if dist <= radius {
            return self
        } else {
            return center + (self - center) / dist * radius
        }
    }
}
