//
//  Tree.swift
//  frumpy
//
//  Created by Viktor Åhliund on 2018-10-03.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
class Tree {
  var imageNr: Int
  let width: CGFloat
  let height: CGFloat
  init(imageNr: Int, size: CGSize) {
    self.imageNr = imageNr
    self.width = size.width
    self.height = size.height
  }
  func addTreeSprite(imageNr: Int, position: CGPoint) -> SKSpriteNode {
    self.imageNr = imageNr
    let tree: SKSpriteNode
    switch imageNr {
    case 1:
      tree = SKSpriteNode(imageNamed: "Tree1")
    case 2:
      tree = SKSpriteNode(imageNamed: "Tree2")
    case 3:
      tree = SKSpriteNode(imageNamed: "Tree3")
    case 4:
      tree = SKSpriteNode(imageNamed: "Tree4")
    default:
      tree = SKSpriteNode(imageNamed: "Tree1")
    }
    tree.size.height = height
    tree.position = position
    tree.zPosition = 0.1
    return tree
  }
}
