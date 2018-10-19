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
    let texture = SKTexture(imageNamed: imageNamed)
    let size = CGSize(width: size.width * 4, height: texture.size().height)
    super.init(texture: texture, color: UIColor.clear, size: size)
    self.zPosition = zPosition
    self.anchorPoint = CGPoint(x: 0, y: 0.5)
    self.position = getPosition(direction: animationDirection)
  }
  
  private func getPosition(direction: String) -> CGPoint{
    if(direction == "left") {
      return CGPoint(x: 0, y: 0)
    } else {
      return CGPoint(x: -size.width/2, y: 0)
    }
  }
  
  public func getAnimationDirection() -> String{
    return animationDirection
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
