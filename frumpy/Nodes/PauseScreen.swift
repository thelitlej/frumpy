//
//  PauseScreen.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-22.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PauseScreen: SKSpriteNode {
  init(size: CGSize) {
    let size = size
    super.init(texture: nil, color: UIColor.clear, size: size)
    self.isUserInteractionEnabled = true
    self.name = "pausescreen"
    self.zPosition = 13
    addBackground()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //this is how to unpause
    if let parent = self.parent as? Navigation {
      parent.removePauseOptions()
      parent.renderInGameOptions()
      parent.resumeWorld()
    }
  }
  
  private func createPauseScene() {
    //Implement pause UI
  }
  
  private func addBackground() {
    let background = SKSpriteNode(color: UIColor.black, size: self.size)
    background.alpha = 0
    background.run(SKAction.fadeAlpha(by: 0.7, duration: 0.2))
    addChild(background)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
