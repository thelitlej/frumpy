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

extension CGVector {
  func speed() -> CGFloat {
    return sqrt(dx*dx+dy*dy)
  }
  func angle() -> CGFloat {
    return atan2(dy, dx)
  }
}

class FrogController: UIViewController {
  let maxSwipeLength:     CGFloat       = 170
  let minSwipeLength:     CGFloat       = 60
  let g:                  CGFloat       = 9.82
  let sheet                             = FrogAnimations()
  
  var dots:               [SKShapeNode] = []
  var frog:               SKSpriteNode  = SKSpriteNode()
  var frogIdle:           SKAction      = SKAction()
  var frogBeginJump:      SKAction      = SKAction()
  var frogJump:           SKAction      = SKAction()
  var frogAnimation:      SKAction      = SKAction()
  var frogSequence:       SKAction      = SKAction()
  var swipeStartX:        CGFloat       = CGFloat()
  var swipeStartY:        CGFloat       = CGFloat()
  var frogLastPositionX:  CGFloat       = CGFloat()
  var frogLastPositionY:  CGFloat       = CGFloat()
  var frogLastAngle:      CGFloat       = CGFloat()
  
  /*
   */
  func addFrog() -> SKSpriteNode {
    frog = SKSpriteNode(texture: sheet.origin_origin_00000());
    frogIdle = SKAction.animate(with: sheet.origin_origin_(), timePerFrame: 0.040)
    frogBeginJump = SKAction.animate(with: sheet.beginjump_beginjump_(), timePerFrame: 0.005)
    frogJump = SKAction.animate(with: sheet.jump_jump_(), timePerFrame: 0.005)
    initFrogPhysics()
    setFrogAnimation(animation: 1)
    print("EN GÅNG?")
    return frog
  }
  
  /*
   */
  func initFrogPhysics() {
    let frogSize = CGSize(width: (frog.size.width/3.5), height: (frog.size.height/3.5))
    let physicsBody = SKPhysicsBody(texture: sheet.origin_origin_00000(), size: frogSize)
    frog.physicsBody = physicsBody
    frog.size = frogSize
    frog.position = CGPoint(x: 100, y: 260)
    frog.physicsBody?.mass = 0.155
    frog.physicsBody?.allowsRotation = false
    frog.physicsBody?.collisionBitMask = 10;
    frog.physicsBody?.contactTestBitMask = 10;
    frog.zPosition = 1
    frogLastPositionY = frog.position.y
    frogLastPositionX = frog.position.x
  }

  /*
   */
  func frogJump(angle: CGFloat, distance: CGFloat) {
    let velocity = CGVector(dx: -cos(angle)*(distance), dy: sin(angle)*(distance))
    frog.physicsBody?.applyImpulse(velocity)
    frog.physicsBody?.affectedByGravity = true
  }
  
  /*
   */
  func updateFrogAngle() {
    let dy = frog.position.y - frogLastPositionY
    let dx = frog.position.x - frogLastPositionX
    let vector = CGVector(dx: dx, dy: dy)
    if (vector.speed() > CGFloat(4)) {
      if (vector.angle() > CGFloat.pi/2 || vector.angle() < -CGFloat.pi/2) {
        frog.xScale = -1
      } else if (vector.angle() < CGFloat.pi/2 || vector.angle() > -CGFloat.pi/2) {
        frog.xScale = 1
      }
    }
    frogLastPositionY = frog.position.y
    frogLastPositionX = frog.position.x
  }
  
  /*
   */
  func createAimDots(nrOfDots: Int) -> [SKShapeNode]{
    var size: CGFloat = 4;
    for _ in 0...nrOfDots {
      let dot = SKShapeNode(circleOfRadius: size)
      dot.fillColor = UIColor.white
      dot.isHidden = true
      dot.alpha = 0.5
      dots.append(dot)
      size -= 0.15
    }
    return dots
  }
  
  /*
   */
  func showDots() {
    for dot in dots {
      dot.isHidden = false
    }
  }
  
  /*
   */
  func hideDots() {
    for dot in dots {
      dot.isHidden = true
    }
  }
  
  /*
   */
  func moveDots(sender: UIPanGestureRecognizer, swipeLength: CGFloat) {
    let currentX = sender.location(in: view).x
    let currentY = sender.location(in: view).y
    let c = -cos(acos((currentX - swipeStartX)/swipeLength))
    let s = sin(asin((currentY - swipeStartY)/swipeLength))
    var i: CGFloat = 1
    for dot in dots {
      let x = swipeLength/2 * i * c
      let y1 = swipeLength/2 * i * s
      let y = y1 - 0.5 * g * pow(i, 2)
      i += 1
      dot.position = CGPoint(x: x + frog.position.x, y: y + frog.position.y)
    }
  }
  
  /*
   */
  func calculateSwipeLength(sender: UIPanGestureRecognizer) -> CGFloat {
    let x = sender.location(in: view).x
    let y = sender.location(in: view).y
    var swipeLength = sqrt(pow((x - swipeStartX) , 2) + pow((y - swipeStartY), 2))
    if(swipeLength > maxSwipeLength) {
      swipeLength = maxSwipeLength;
    }
    return swipeLength
  }
  
  /*
   */
  func calculateSwipeAngle(sender: UIPanGestureRecognizer) -> CGFloat {
    let dy = sender.location(in: view).y - swipeStartY
    let dx = sender.location(in: view).x - swipeStartX
    return atan2(dy, dx)
  }
  
  /*
   */
  func initPanner() -> UIPanGestureRecognizer {
    let panner = UIPanGestureRecognizer(target: self, action: #selector(FrogController.swipe(sender: )))
    return panner
  }
  
  /*
   */
  func checkAngle(angle: CGFloat) {
    if(angle > CGFloat.pi/2 || angle < -CGFloat.pi/2) {
      frog.xScale = 1
    } else if (angle < CGFloat.pi/2 || angle > -CGFloat.pi/2) {
      frog.xScale = -1
    }
  }
  
  /*
   */
  func setFrogAnimation(animation: Int) {
    switch(animation) {
      case 1:
        frogAnimation = SKAction.repeat(frogIdle, count: 1)
        print("ENTERED")
        break
      case 2:
        frogAnimation = SKAction.repeat(frogBeginJump, count: 1)
        break
      case 3:
        frogAnimation = SKAction.repeat(frogJump, count: 1)
        break
    default:
      frogAnimation = SKAction.repeat(frogIdle, count: 1)
    }
    frog.run(frogAnimation)
  }
  
  /*
   */
  @objc func swipe(sender: UIPanGestureRecognizer) {
    let angle = calculateSwipeAngle(sender: sender)
    let distance = calculateSwipeLength(sender: sender)
    if(distance > 70) {
      showDots()
      if (sender.state.rawValue == 1) {
        setFrogAnimation(animation: 2)
        swipeStartX = sender.location(in: view).x
        swipeStartY = sender.location(in: view).y
      } else if (sender.state.rawValue == 3) {
        hideDots()
        setFrogAnimation(animation: 3)
        frogJump(angle: angle, distance: distance)
      } else {
        moveDots(sender: sender, swipeLength: distance)
        checkAngle(angle: angle)
      }
    }
    else {
      hideDots()
    }
  }
}
