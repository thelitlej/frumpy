//
//  Utilities.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-22.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class Utilities {
  static func betweenPointDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
    let dy = point2.y - point1.y
    let dx = point2.x - point1.x
    return sqrt(dx*dx + dy*dy)
  }
  
  static func betweenPointAngle(point1: CGPoint, point2: CGPoint) -> CGFloat {
    let dy = point2.y - point1.y
    let dx = point2.x - point1.x
    return atan2(dy, dx)
  }
  
  static func betweenPointVector(distance: CGFloat, maxDistance: CGFloat, point2: CGPoint, point1: CGPoint) -> CGVector{
    if (distance >= maxDistance) {
      let alpha = asin((point2.x - point1.x)/maxDistance)
      return CGVector(dx: maxDistance * sin(alpha), dy: maxDistance * cos(alpha))
    } else {
      return CGVector(dx: point2.x - point1.x, dy: point2.y - point1.y)
    }
  }
  
  static func UIColorFromHex(hexValue: UInt) -> UIColor {
    return UIColor(
      red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(hexValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
}

