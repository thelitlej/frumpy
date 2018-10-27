//
//  ChallengesButton.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-19.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class AshivementsButton: SKSpriteNode {
  var touchMovedOutside: Bool = false
  
  init(position: CGPoint) {
    let size = CGSize(width: 100, height: 100)
    let texture = SKTexture(imageNamed: "ashivements")
    super.init(texture: texture, color: UIColor.clear, size: size)
    self.name = "startoption"
    self.position = position
    self.zPosition = 11
    self.isUserInteractionEnabled = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchMovedOutside = false
    self.run(SKAction.scale(to: 1.1, duration: 0.1))
  }
  
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if (abs(touch.location(in: self).x) > self.size.width/2 || abs(touch.location(in: self).y) > self.size.height/2) {
        self.run(SKAction.scale(to: 1, duration: 0.1))
      } else {
        let transition: SKTransition = SKTransition.push(with: SKTransitionDirection(rawValue: 2)!, duration: 0.5)
        let nextScene: SKScene = AshivementScene(size: scene!.size)
        scene?.view?.presentScene(nextScene, transition: transition)
      }
    }
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
