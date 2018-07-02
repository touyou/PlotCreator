//
//  CustomPathConvertible.swift
//  PlotCreator
//
//  Created by 藤井陽介 on 2018/07/02.
//  Copyright © 2018 touyou. All rights reserved.
//

import Foundation
import CoreGraphics

protocol CustomPathConvertible {
    var points: [CGPoint] { get }
    var _points: [CGPoint] { get }
}
