//
//  RandomFunction.swift
//  frumpy
//
//  Created by Martin Willman on 2018-10-05.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
  
  public static func random() -> CGFloat{
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }
  
  public static func random(min : CGFloat, max : CGFloat) -> CGFloat{
    return CGFloat.random() * (max - min) + min
  }
}
