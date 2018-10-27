//
//  BackButton.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-22.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class BackButton: SKSpriteNode {
  init(position: CGPoint) {
    let size = CGSize(width: 19, height: 30)
    let texture = SKTexture(imageNamed: "back")
    super.init(texture: texture, color: UIColor.clear, size: size)
    self.name = "backbutton"
    self.position = position
    self.zPosition = 11
    self.isUserInteractionEnabled = true
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if (abs(touch.location(in: self).x) > self.size.width/2 || abs(touch.location(in: self).y) > self.size.height/2) {
        self.run(SKAction.scale(to: 1, duration: 0.1))
      } else {
        let transition: SKTransition = SKTransition.push(with: SKTransitionDirection(rawValue: 3)!, duration: 1)
        let nextScene: SKScene = GameScene(size: scene!.size)
        scene?.view?.presentScene(nextScene, transition: transition)
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
