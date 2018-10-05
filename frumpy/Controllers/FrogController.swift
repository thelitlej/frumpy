//
//  FrogController.swift
//  frumpy
//
//  Created by Viktor Åhliund on 2018-10-03.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FrogController: UIViewController {
  
  let sheet = AnimatedFrog2()
  var frog: SKSpriteNode = SKSpriteNode()
  var dots: [SKShapeNode] = []
  var startX: CGFloat = 0;
  var startY: CGFloat = 0;
  let g: CGFloat = 9.82
  
  func addFrog() -> SKSpriteNode {
    let passive = SKAction.animate(with: sheet.still_frog_(), timePerFrame: 0.040)
    let passiveAnimation = SKAction.repeat(passive, count: 6)
    
    let sequence = SKAction.repeatForever(
      SKAction.sequence([passiveAnimation])
    );
    frog = SKSpriteNode(texture: sheet.still_frog_00000());
    initFrogPhysics()
    frog.run(sequence)
    return frog
    
  }
  
  func initFrogPhysics() {
    frog.physicsBody = SKPhysicsBody(texture: sheet.still_frog_00000(), size: CGSize(width: (frog.size.width/3.5), height: (frog.size.height/3.5)))
    frog.size = CGSize(width: (frog.size.width/3.5), height: (frog.size.height/3.5))
    frog.position = CGPoint(x: 200, y: 200)
    frog.physicsBody?.mass = 0.155
    frog.physicsBody?.allowsRotation = false
    frog.physicsBody?.collisionBitMask = 10;
    frog.physicsBody?.contactTestBitMask = 10;
  }
  
  func frogJump(angle: CGFloat, distance: CGFloat) {
    let velocity = CGVector(dx: -cos(angle)*(distance), dy: sin(angle)*(distance))
    frog.physicsBody?.applyImpulse(velocity)
    frog.physicsBody?.affectedByGravity = true
    //let action = SKAction.rotate(byAngle: 1, duration: 1)
    //frog.run(action)
  }
  
  func createAimDots(nrOfDots: Int) -> [SKShapeNode]{
    var size: CGFloat = 4;
    for _ in 0...nrOfDots {
      let dot = SKShapeNode(circleOfRadius: size)
      dot.position = CGPoint(x: -100, y: -100)
      dot.fillColor = UIColor.white
      dot.isHidden = true
      dot.alpha = 0.5
      //self.addChild(dot)
      dots.append(dot)
      size -= 0.15
    }
    return dots
  }
  
  func showDots() {
    for dot in dots {
      dot.isHidden = false
    }
  }
  
  func hideDots() {
    for dot in dots {
      dot.isHidden = true
    }
  }
  
  func moveDots(sender: UIPanGestureRecognizer, distance: CGFloat) {
    let currentX = sender.location(in: view).x
    let currentY = sender.location(in: view).y
    
    let c = -cos(acos((currentX - startX)/distance))
    let s = sin(asin((currentY - startY)/distance))
    
//    let temp = (currentX - startX)/distance
//    if((calc < 0 && c < 0))
//    print("calc", temp)
//    print("SIN: ", s)
//    print("COS: ", c)
    var i: CGFloat = 1
    for dot in dots {
      let x = distance/2 * i * c
      let y1 = distance/2 * i * s
      let y = y1 - 0.5 * g * pow(i, 2)
      i += 1
      dot.position = CGPoint(x: x + frog.position.x, y: y + frog.position.y)
    }
  }
  
  func flipFrog(direction: CGFloat) {
    frog.xScale = direction
  }
  
  func checkFlip(angle: CGFloat) {
    if(angle > CGFloat.pi/2 || angle < -CGFloat.pi/2) {
      flipFrog(direction: 1)
    } else {
      flipFrog(direction: -1)
    }
  }
  
  func calculateDistance(sender: UIPanGestureRecognizer) -> CGFloat {
    let x = sender.location(in: view).x
    let y = sender.location(in: view).y
    var distance = sqrt(pow((x - startX) , 2) + pow((y - startY), 2))
    if(distance > 200) {
      distance = 200;
    }
    return distance
  }
  
  func calculateAngle(sender: UIPanGestureRecognizer) -> CGFloat {
    return atan2((sender.location(in: view).y - startY), (sender.location(in: view).x - startX))
  }
  
  func calculateFrogHeading(swipeAngle: CGFloat) -> CGFloat {
    if(swipeAngle < 0) {
      return swipeAngle + CGFloat.pi
    }
    return swipeAngle - CGFloat.pi
  }
  func initPanner() -> UIPanGestureRecognizer {
    let panner = UIPanGestureRecognizer(target: self, action: #selector(FrogController.swipe(sender: )))
    return panner
  }
  
  @objc func swipe(sender: UIPanGestureRecognizer) {
    let angle = calculateAngle(sender: sender)
    let distance = calculateDistance(sender: sender)
    if(distance > 70) {
      showDots()
      if(sender.state.rawValue == 1) {
          startX = sender.location(in: view).x
          startY = sender.location(in: view).y
      } else if (sender.state.rawValue == 3) {
        hideDots()
        frogJump(angle: angle, distance: distance)
        
      } else {
        checkFlip(angle: angle)
        moveDots(sender: sender, distance: distance)
      }
    }
    else {
      hideDots()
    }
  }
//  func didBegin(_ contact: SKPhysicsContact) {
//    let firstNode = contact.bodyA.node as! SKSpriteNode
//    let secondNode = contact.bodyB.node as! SKSpriteNode
//    
//    if firstNode.name == "frog" && secondNode.name == "leftWall" {
//      flipFrog(direction: 1)
//    }
//    else if firstNode.name == "frog" && secondNode.name == "rightWall" {
//      flipFrog(direction: -1)
//    }
//  }
  
}
