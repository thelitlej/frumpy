//
//  HighScoreButton.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-19.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class LeaderboardButton: SKSpriteNode {
  init(position: CGPoint) {
    let size = CGSize(width: 37, height: 27)
    let texture = SKTexture(imageNamed: "leaderboard")
    super.init(texture: texture, color: UIColor.clear, size: size)
    self.name = "startoption"
    self.position.y = position.y - self.size.height/2 - 11
    self.position.x = position.x
    self.zPosition = 11
    self.alpha = 0.7
    self.isUserInteractionEnabled = true
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if (abs(touch.location(in: self).x) > self.size.width/2 || abs(touch.location(in: self).y) > self.size.height/2) {
        self.run(SKAction.scale(to: 1, duration: 0.1))
      } else {
        let transition: SKTransition = SKTransition.push(with: SKTransitionDirection(rawValue: 2)!, duration: 0.5)
        let nextScene: SKScene = LeaderboardScene(size: scene!.size)
        scene?.view?.presentScene(nextScene, transition: transition)
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
