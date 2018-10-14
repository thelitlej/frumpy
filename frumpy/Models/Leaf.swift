//
//  Leaf.swift
//  frumpy
//
//  Created by Viktor Åhliund on 2018-10-03.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Leaf: SKSpriteNode {
  var visited: Bool
  
  init(position: CGPoint, imageNamed: String) {
    self.visited = false
    let texture = SKTexture(imageNamed: imageNamed)
    let size = CGSize(width: texture.size().width/4, height: texture.size().height/4)
    super.init(texture: texture, color: UIColor.clear, size: size)
    
    self.position = position
    self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width/1.5, height: self.size.height/12))
    self.physicsBody?.isDynamic = false
    self.physicsBody!.categoryBitMask = 10
    self.physicsBody!.contactTestBitMask = 10
    self.physicsBody!.collisionBitMask = 10
    self.physicsBody!.friction = 5
    self.name = "leaf"
    self.zPosition = 2
  }
  
  func setVisited() {
    self.visited = true
  }
  func isVisited() -> Bool {
    return self.visited
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

