//
//  CommercialButton.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-19.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class CommercialButton: SKSpriteNode {
  init(position: CGPoint, imageNamed: String) {
    let size = CGSize(width: 100, height: 100)
    let texture = SKTexture(imageNamed: "BackgroundCloud2")
    super.init(texture: texture, color: UIColor.clear, size: size)
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
