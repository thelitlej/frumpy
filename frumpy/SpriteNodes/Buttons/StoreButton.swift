//
//  StoreButton.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-20.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class StoreButton: SKSpriteNode {
  init(position: CGPoint) {
    let size = CGSize(width: 210, height: 60)
    let texture = SKTexture(imageNamed: "store")
    super.init(texture: texture, color: UIColor.clear, size: size)
    self.name = "startoption"
    self.position = position
    self.zPosition = 11
    self.isUserInteractionEnabled = true
    wiggle()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.run(SKAction.scale(to: 1.1, duration: 0.1))
  }
  
 
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if (abs(touch.location(in: self).x) > self.size.width/2 || abs(touch.location(in: self).y) > self.size.height/2) {
        self.run(SKAction.scale(to: 1, duration: 0.1))
      } else {
        let transition: SKTransition = SKTransition.push(with: SKTransitionDirection(rawValue: 2)!, duration: 0.5)
        let nextScene: SKScene = StoreScene(size: scene!.size)
        scene?.view?.presentScene(nextScene, transition: transition)
      }
    }
  }

  
  func wiggle() {
    let rotate1 = SKAction.rotate(byAngle: 0.1, duration: 0.1)
    let rotate2 = SKAction.rotate(byAngle: -0.2, duration: 0.1)
    let rotate3 = SKAction.rotate(byAngle: 0.2, duration: 0.1)
    let rotate4 = SKAction.rotate(byAngle: -0.1, duration: 0.1)
    let wait = SKAction.wait(forDuration: 2)
    let sequence = SKAction.sequence([rotate1, rotate2, rotate3, rotate4, wait])
    self.run(SKAction.repeatForever(sequence))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
