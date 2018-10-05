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
  
  let startLeaf = SKSpriteNode(imageNamed: "leaf")
  let secondLeaf = SKSpriteNode(imageNamed: "leaf")
  let nextLeaf = SKSpriteNode(imageNamed: "leaf")
  
  func addFirstLeaf () -> SKSpriteNode {
    // create a new leaf sprite

   // let leafFirstSprite = SKSpriteNode(imageNamed: "leaf")
    startLeaf.size = CGSize(width: (startLeaf.size.width/4), height: (startLeaf.size.height/4))
    startLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: startLeaf.size.width/1.5,
                                                              height: startLeaf.size.height/12))
    startLeaf.physicsBody?.isDynamic = false
    startLeaf.physicsBody!.categoryBitMask = 10
    startLeaf.physicsBody!.contactTestBitMask = 10
    startLeaf.physicsBody!.collisionBitMask = 10
    startLeaf.physicsBody!.friction = 5

    // position new sprite at a specific position on the screen
    //let sizeRect = UIScreen.main.bounds;
    startLeaf.position = CGPoint(x: 100, y: 200)
    //startLeaf.position = CGPoint(x: (sizeRect.size.width)-100, y: (sizeRect.size.height)-350)
    
    return startLeaf
  }
  
  func addLeaf () -> SKSpriteNode {
    // create a new leaf sprite

   // let leafSprite = SKSpriteNode(imageNamed: "leaf")
    secondLeaf.size = CGSize(width: (secondLeaf.size.width/4), height: (secondLeaf.size.height/4))
    // nextLeaf.size = CGSize(width: 120, height: 40)
    secondLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: secondLeaf.size.width/1.5,
                                                              height: secondLeaf.size.height/12))
    secondLeaf.physicsBody?.isDynamic = false
    secondLeaf.physicsBody!.friction = 5
    secondLeaf.physicsBody!.categoryBitMask = 10
    secondLeaf.physicsBody!.contactTestBitMask = 10
    secondLeaf.physicsBody!.collisionBitMask = 10

    secondLeaf.position = CGPoint(x: 300, y: 400)
    // position new sprite at a random position on the screen
    /*let sizeRect = nextLeaf.frame;
    let posX = arc4random_uniform(UInt32(sizeRect.size.width))
    let posY = arc4random_uniform(UInt32(sizeRect.size.height))
    nextLeaf.position = CGPoint(x: CGFloat(posX), y: CGFloat(posY))*/
    
    return secondLeaf
  }
  /*func leafStandingPoint(){
    startLeaf.size = CGSize(width: (startLeaf.size.width/4), height: (startLeaf.size.height/4))
  }*/
  func nextRandomLeaf() -> SKSpriteNode {
    nextLeaf.size = CGSize(width: (nextLeaf.size.width/4), height: (nextLeaf.size.height/4))
    nextLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: nextLeaf.size.width/1.5,
                                                             height: nextLeaf.size.height/12))
    nextLeaf.physicsBody!.isDynamic = false
    nextLeaf.physicsBody!.categoryBitMask = 10
    nextLeaf.physicsBody!.contactTestBitMask = 10
    nextLeaf.physicsBody!.collisionBitMask = 10
    let sizeRect = nextLeaf.frame;
     let posX = arc4random_uniform(UInt32(sizeRect.size.width))
     let posY = arc4random_uniform(UInt32(sizeRect.size.height))
     nextLeaf.position = CGPoint(x: CGFloat(posX), y: CGFloat(posY))
    
    return nextLeaf
    //insertChild(nextLeaf, at: 0)
  }
  
}


