//
//  SettingsButton.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-19.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SettingsButton: SKSpriteNode {
  init(position: CGPoint) {
    let size = CGSize(width: 30, height: 30)
    let texture = SKTexture(imageNamed: "settings")
    super.init(texture: texture, color: UIColor.clear, size: size)
    self.name = "startoption"
    self.position.y = position.y - self.size.height/2 - 10
    self.position.x = position.x
    self.zPosition = 11
    self.alpha = 0.7
    self.isUserInteractionEnabled = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let transition: SKTransition = SKTransition.push(with: SKTransitionDirection(rawValue: 2)!, duration: 0.5)
    let nextScene: SKScene = SettingsScene(size: scene!.size)
    scene?.view?.presentScene(nextScene, transition: transition)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
