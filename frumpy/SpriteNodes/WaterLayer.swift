//
//  Water.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-13.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class WaterLayer: SKSpriteNode{
  private let animationDirection: String
  init(imageNamed: String, zPosition: CGFloat, animationDirection: String, size: CGSize) {
    self.animationDirection = animationDirection
    if (animationDirection == "still") {
      let size = CGSize(width: size.width * 4, height: 400)
      super.init(texture: nil, color: Utilities.UIColorFromHex(hexValue: 0x64BDF4), size: size)
    } else {
      let texture = SKTexture(imageNamed: imageNamed)
      let size = CGSize(width: size.width * 4, height: texture.size().height)
      super.init(texture: texture, color: UIColor.clear, size: size)
    }
    self.zPosition = zPosition
    self.anchorPoint = CGPoint(x: 0, y: 0.5)
    self.position = getPosition()
  }
  
  private func getPosition() -> CGPoint{
    if (animationDirection == "left") {
      return CGPoint(x: 0, y: 0)
    } else if (animationDirection == "right"){
      return CGPoint(x: -size.width/2, y: 0)
    } else {
      return CGPoint(x: size.width/2, y: -200)
    }
  }
  public func getAnimationDirection() -> String{
    return animationDirection
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
