//
//  LeaderboardScene.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-19.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import SpriteKit
import GameplayKit

class LeaderboardScene: SKScene {
  override func didMove(to view: SKView) {
    addChild(BackButton(position: CGPoint(x: 0 + 9.5 + 10, y: size.height - 15 - 10)))
    backgroundColor = Utilities.UIColorFromHex(hexValue: 0x702D2D)
    addHeroImage()
  }
  
  private func addHeroImage() {
    let texture = SKTexture(imageNamed: "highscorehero")
    let spriteHero = SKSpriteNode(texture: texture)
    spriteHero.size = CGSize(width: size.width - 25, height: 180)
    spriteHero.position = CGPoint(x: size.width/2, y: size.height - spriteHero.size.height/2 - 50)
    addChild(spriteHero)
  }
}
