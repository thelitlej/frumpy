//
//  Pause.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-19.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PauseButton: SKSpriteNode {
  init(position: CGPoint) {
    let size = CGSize(width: 28, height: 30)
    let texture = SKTexture(imageNamed: "pause")
    super.init(texture: texture, color: UIColor.clear, size: size)
    self.name = "ingameoption"
    self.position.y = position.y - self.size.height/2 - 10
    self.position.x = position.x
    self.zPosition = 11
    self.alpha = 0
    self.isUserInteractionEnabled = true
    fadeIn()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if (abs(touch.location(in: self).x) > self.size.width/2 || abs(touch.location(in: self).y) > self.size.height/2) {
        if let myParent = self.parent as? Navigation {
          myParent.renderPauseOptions()
          myParent.removeOptionsBy(name: "ingameoption")
        }
      } else {
        let transition: SKTransition = SKTransition.push(with: SKTransitionDirection(rawValue: 2)!, duration: 0.5)
        let nextScene: SKScene = LeaderboardScene(size: scene!.size)
        scene?.view?.presentScene(nextScene, transition: transition)
      }
    }
  }
  
  func fadeIn() {
    let fadeInAction = SKAction.fadeAlpha(to: 0.7, duration: 0.3)
    self.run(fadeInAction)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
