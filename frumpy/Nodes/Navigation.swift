//
//  StartScreenOptionsNode.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-19.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Navigation: SKSpriteNode {
  init() {
    super.init(texture: nil, color: UIColor.clear, size: CGSize(width: 0, height: 0))
    
  }
  
  init(size: CGSize) {
    super.init(texture: nil, color: UIColor.clear, size: size)
    self.zPosition = 10
  }

  func renderStartOptions() {
    addChild(StoreButton(position: CGPoint(x: self.size.width/2 - 115, y: -self.size.height/2 + 190)))
    addChild(AshivementsButton(position: CGPoint(x: self.size.width/2 - 170, y: -self.size.height/2 + 100)))
    addChild(CustomizeButton(position: CGPoint(x: self.size.width/2 - 60, y: -self.size.height/2 + 100)))
    addChild(SettingsButton(position: CGPoint(x: -self.size.width/2 + 25, y: self.size.height/2)))
    addChild(LeaderboardButton(position: CGPoint(x: -self.size.width/2 + 75, y: self.size.height/2)))
  }
  
  func renderInGameOptions() {
    addChild(PauseButton(position: CGPoint(x: -self.size.width/2 + 25, y: self.size.height/2)))
  }
  
  func renderPauseOptions() {
    let pauseScreen = PauseScreen(size: self.size)
    pauseWorld()
    addChild(pauseScreen)
  }
  
  func removeStartOptions() {
    removeOptionsBy(name: "startoption")
  }
  
  func removeInGameOptions() {
    removeOptionsBy(name: "ingameoption")
  }
  
  func removePauseOptions() {
    removeOptionsBy(name: "pausescreen")
  }
  
  func removeOptionsBy(name: String) {
    for i in children {
      if(i.name == name) {
        let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.2)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeAction, removeAction])
        i.run(sequence)
      }
    }
  }
  
  func pauseWorld() {
    setWorldSpeed(to: 0)
  }
  
  func resumeWorld() {
    setWorldSpeed(to: 1)
  }
  
  func setWorldSpeed(to: CGFloat) {
    if let camera = self.parent as? SKCameraNode {
      for i in camera.children {
        if(i.name == "particle") {
          i.speed = to
        }
      }
      if let scene = camera.parent as? GameScene {
        scene.physicsWorld.speed = to
        for child in scene.children {
          child.action(forKey: "water")?.speed = to
        }
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

