//
//  AshivementScene.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-20.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import SpriteKit
import GameplayKit

class AshivementScene: SKScene {
  override func didMove(to view: SKView) {
    addChild(BackButton(position: CGPoint(x: 0 + 9.5 + 10, y: size.height - 15 - 10)))
  }
}
