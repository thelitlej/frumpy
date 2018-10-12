//
//  LeafController.swift
//  frumpy
//
//  Created by Viktor Åhliund on 2018-10-03.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//
import SpriteKit
import Foundation
import GameplayKit

class LeafController: UIViewController {
  
  let startLeaf = SKSpriteNode(imageNamed: "leaf_brown")
  let secondLeaf = SKSpriteNode(imageNamed: "leaf_brown")
  let nextLeaf = SKSpriteNode(imageNamed: "leaf_brown")
  let brownLeaf = SKSpriteNode(imageNamed: "leaf_brown")
 
  
  func createLeaf(position: CGPoint) -> SKSpriteNode {
    brownLeaf.size = CGSize(width: (brownLeaf.size.width/4), height: (brownLeaf.size.height/4))
    brownLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: brownLeaf.size.width/1.5,
                                                              height: brownLeaf.size.height/12))
    brownLeaf.physicsBody?.isDynamic = false
    brownLeaf.physicsBody!.categoryBitMask = 10
    brownLeaf.physicsBody!.contactTestBitMask = 10
    brownLeaf.physicsBody!.collisionBitMask = 10
    brownLeaf.physicsBody!.friction = 5
    //brownLeaf.position = CGPoint(x: position.x, y: position.y)
    brownLeaf.name = "leaf"
    
    return brownLeaf
  }

}


