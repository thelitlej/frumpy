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
    brownLeaf.position = CGPoint(x: position.x, y: position.y)
    
    return brownLeaf
  }
  
  func nextRandomLeaf() -> SKSpriteNode {
    // create next random leaf sprite
    nextLeaf.size = CGSize(width: (nextLeaf.size.width/4), height: (nextLeaf.size.height/4))
    nextLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: nextLeaf.size.width/1.5, height: nextLeaf.size.height/12))
    nextLeaf.physicsBody?.isDynamic = false
    nextLeaf.physicsBody?.affectedByGravity = false
    nextLeaf.physicsBody?.contactTestBitMask = 1
    
    let randomPositionX = CGFloat.random(min: 0, max: 400)
    let randomPositionY = CGFloat.random(min: 300, max: 1000)
    nextLeaf.position.x = nextLeaf.position.x + randomPositionX
    nextLeaf.position.y = nextLeaf.position.y + randomPositionY
    nextLeaf.position = CGPoint(x: CGFloat(nextLeaf.position.x), y: CGFloat(nextLeaf.position.y))
    
   /*let sizeRect = nextLeaf.frame;
     let posX = arc4random_uniform(UInt32(sizeRect.size.width))
     let posY = arc4random_uniform(UInt32(sizeRect.size.height))
     nextLeaf.position = CGPoint(x: CGFloat(posX), y: CGFloat(posY))*/
    
    return nextLeaf
    //insertChild(nextLeaf, at: 0)
  }
}


