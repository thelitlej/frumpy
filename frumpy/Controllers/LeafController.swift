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
  
  func addFirstLeaf () -> SKSpriteNode {
    // create first leaf sprite

    startLeaf.size = CGSize(width: (startLeaf.size.width/4), height: (startLeaf.size.height/4))
    startLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: startLeaf.size.width/1.5,
                                                              height: startLeaf.size.height/12))
    startLeaf.name = "leaf"
    startLeaf.zPosition = 1
    startLeaf.physicsBody?.isDynamic = false
    startLeaf.physicsBody?.categoryBitMask = 10
    startLeaf.physicsBody?.contactTestBitMask = 10
    startLeaf.physicsBody?.restitution = 0
    startLeaf.physicsBody?.collisionBitMask = 10
    startLeaf.physicsBody?.friction = 5
    startLeaf.position = CGPoint(x: 100, y: 200)
  
    return startLeaf
  }
  
  func addSecondLeaf () -> SKSpriteNode {
    // create second leaf sprite

    secondLeaf.size = CGSize(width: (secondLeaf.size.width/4), height: (secondLeaf.size.height/4))
    secondLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: secondLeaf.size.width/1.5,
                                                            height: secondLeaf.size.height/12))
    secondLeaf.name = "leaf"
    secondLeaf.zPosition = 1
    secondLeaf.physicsBody?.isDynamic = false
    secondLeaf.physicsBody?.friction = 5
    secondLeaf.physicsBody?.categoryBitMask = 10
    secondLeaf.physicsBody?.contactTestBitMask = 10
    secondLeaf.physicsBody?.collisionBitMask = 10
    secondLeaf.position = CGPoint(x: 300, y: 300)
    
    return secondLeaf
  }
  func nextRandomLeaf() -> SKSpriteNode {
    // create next random leaf sprite
    nextLeaf.size = CGSize(width: (nextLeaf.size.width/4), height: (nextLeaf.size.height/4))
    nextLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: nextLeaf.size.width/1.5,
                                                             height: nextLeaf.size.height/12))
    nextLeaf.physicsBody!.isDynamic = false
    nextLeaf.physicsBody!.categoryBitMask = 10
    nextLeaf.physicsBody!.contactTestBitMask = 10
    nextLeaf.physicsBody!.collisionBitMask = 10
    nextLeaf.physicsBody!.affectedByGravity = false
    
    var randomPositionX = CGFloat.random(min: 0, max: 400)
    var randomPositionY = CGFloat.random(min: 300, max: 1000)
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


