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
    let leafFirstSprite = SKSpriteNode(imageNamed: "leaf")
    leafFirstSprite.size = CGSize(width: 100, height: 40)
    
    // position new sprite at a specific position on the screen
    let sizeRect = UIScreen.main.bounds;
    leafFirstSprite.position = CGPoint(x: (sizeRect.size.width)-100, y: (sizeRect.size.height)-350)
    
    return leafFirstSprite
  }
  
  func addLeaf () -> SKSpriteNode {
    // create a new leaf sprite
    let leafSprite = SKSpriteNode(imageNamed: "leaf")
    leafSprite.size = CGSize(width: 100, height: 40)

    // position new sprite at a random position on the screen
    let sizeRect = UIScreen.main.bounds;
    let posX = arc4random_uniform(UInt32(sizeRect.size.width))
    let posY = arc4random_uniform(UInt32(sizeRect.size.height))
    leafSprite.position = CGPoint(x: CGFloat(posX), y: CGFloat(posY))
    
    return leafSprite
  }
}


