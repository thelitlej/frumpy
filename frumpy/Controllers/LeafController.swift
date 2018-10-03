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
  
  func addFirstLeaf () -> SKSpriteNode {
    // create a new leaf sprite
    let leafFirstSprite = SKSpriteNode(imageNamed: "Leaf")
    leafFirstSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leafFirstSprite.size.width/1.5,
                                                              height: leafFirstSprite.size.height/12))
    leafFirstSprite.size = CGSize(width: 100, height: 40)
    leafFirstSprite.physicsBody?.isDynamic = false
    leafFirstSprite.physicsBody!.categoryBitMask = 10
    leafFirstSprite.physicsBody!.contactTestBitMask = 10
    leafFirstSprite.physicsBody!.collisionBitMask = 10
    
//    // position new sprite at a specific position on the screen
//    let sizeRect = UIScreen.main.bounds;
//    leafFirstSprite.position = CGPoint(x: (sizeRect.size.width)-100, y: (sizeRect.size.height)-350)
    
    return leafFirstSprite
  }
  
  func addLeaf () -> SKSpriteNode {
    // create a new leaf sprite
    let leafSprite = SKSpriteNode(imageNamed: "Leaf")
    leafSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leafSprite.size.width/1.5,
                                                              height: leafSprite.size.height/12))
    leafSprite.physicsBody?.isDynamic = false
    leafSprite.size = CGSize(width: 100, height: 40)
    leafSprite.physicsBody!.categoryBitMask = 10
    leafSprite.physicsBody!.contactTestBitMask = 10
    leafSprite.physicsBody!.collisionBitMask = 10

    // position new sprite at a random position on the screen
    let sizeRect = leafSprite.frame;
    let posX = arc4random_uniform(UInt32(sizeRect.size.width))
    let posY = arc4random_uniform(UInt32(sizeRect.size.height))
    leafSprite.position = CGPoint(x: CGFloat(posX), y: CGFloat(posY))
    
    return leafSprite
  }
}


