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
  let maxSwipeLength:     CGFloat                 = 170
  let minSwipeLength:     CGFloat                 = 60
  let g:                  CGFloat                 = 9.8
  let beginJumpTime:      Double                  = 0.3
  let originTime:         Double                  = 1
  let frogAnimations                              = FrogAnimations()
  
  var size:               CGSize                  = CGSize()
  var panner:             UIPanGestureRecognizer  = UIPanGestureRecognizer()
  var dots:               [SKShapeNode]           = []
  var frog:               SKSpriteNode            = SKSpriteNode()
  var frogIdle:           SKAction                = SKAction()
  var frogBeginJump:      SKAction                = SKAction()
  var frogJump:           SKAction                = SKAction()
  var swipeStartX:        CGFloat                 = CGFloat()
  var swipeStartY:        CGFloat                 = CGFloat()
  var frogLastPositionX:  CGFloat                 = CGFloat()
  var frogLastPositionY:  CGFloat                 = CGFloat()
  var frogLastAngle:      CGFloat                 = CGFloat()
  
  convenience init(size: CGSize) {
    self.init()
    self.size = size
  }
  /*
   */
  func addFrog() -> SKSpriteNode {
    let beginJumpTimePerFrame = beginJumpTime/Double(frogAnimations.beginjump_beginjump_().count)
    frog = SKSpriteNode(texture: frogAnimations.origin_origin_00000());
    frogIdle = SKAction.animate(with: frogAnimations.origin_origin_(), timePerFrame: 0.04)
    frogBeginJump = SKAction.animate(with: frogAnimations.beginjump_beginjump_(), timePerFrame: beginJumpTimePerFrame)
    frogJump = SKAction.animate(with: frogAnimations.jump_jump_(), timePerFrame: 0.005)
    frog.zPosition = 5
    initFrogPhysics()
    setFrogAnimation(animation: 1)
    
    return frog
  }
  
  /*
   */
  func initFrogPhysics() {
    let frogSize = CGSize(width: (frog.size.width/4), height: (frog.size.height/4))
    let physicsBody = SKPhysicsBody(texture: frogAnimations.origin_origin_00000(), size: frogSize)
    frog.physicsBody = physicsBody
    frog.size = frogSize
    frog.position = CGPoint(x: 100+frog.size.width/10, y: 260)
    frog.physicsBody?.restitution = 0.2
    frog.physicsBody?.angularDamping = 0
    frog.physicsBody?.linearDamping = 0
    frog.physicsBody?.collisionBitMask = 10
    frog.physicsBody?.contactTestBitMask = 10
    frog.physicsBody?.allowsRotation = false
    frog.physicsBody?.usesPreciseCollisionDetection = true
    frogLastPositionY = frog.position.y
    frogLastPositionX = frog.position.x
  }
  
  /*
   */
  func initPanner() -> UIPanGestureRecognizer {
    panner = UIPanGestureRecognizer(target: self, action: #selector(FrogController.swipe(sender: )))
    return panner
  }

  /*
   */
  func frogJump(sender: UIPanGestureRecognizer) {
    var dx = sender.location(in: view).x - swipeStartX
    var dy = sender.location(in: view).y - swipeStartY
    let swipeLength = sqrt(dx*dx + dy*dy)
    if (swipeLength > maxSwipeLength) {
      let angle = asin(dx/swipeLength)
      dx = maxSwipeLength * sin(angle) + 10
      dy = maxSwipeLength * cos(angle) + 10
    }
    frog.physicsBody?.applyForce(CGVector(dx: -dx * (frog.physicsBody!.mass * 375), dy: dy * (frog.physicsBody!.mass * 375)))
  }
  
  
  /*
   */
  func enableFrogJump() {
    panner.isEnabled = true
  }
  
  /*
   */
  func disableFrogJump() {
    panner.isEnabled = false
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
  func calculateSwipeAngle(sender: UIPanGestureRecognizer) -> CGFloat {
    let dy = sender.location(in: view).y - swipeStartY
    let dx = sender.location(in: view).x - swipeStartX
    return atan2(dy, dx)
  }
  
  /*
   */
  @objc func swipe(sender: UIPanGestureRecognizer) {
    if (sender.state.rawValue == 1) {
      swipeStartX = sender.location(in: view).x
      swipeStartY = sender.location(in: view).y
      setFrogAnimation(animation: 2)
    }
    let distance = calculateSwipeLength(sender: sender)
    if(distance > 70) {
      let angle = calculateSwipeAngle(sender: sender)
      checkAngle(angle: angle)
      showAimDots()
      if (sender.state.rawValue == 3) {
        hideAimDots()
        setFrogAnimation(animation: 3)
        frogJump(sender: sender)
        disableFrogJump()
      } else {
        moveAimDots(sender: sender, swipeLength: distance)
      }
    }
    else {
      if (sender.state.rawValue == 3) {
        setFrogAnimation(animation: 1)
      }
      hideAimDots()
    }
  }
  
  /*
   */
  func calculateSwipeLength(sender: UIPanGestureRecognizer) -> CGFloat {
    let x = sender.location(in: view).x
    let y = sender.location(in: view).y
    var swipeLength = sqrt(pow((x - swipeStartX) , 2) + pow((y - swipeStartY), 2))
    if (swipeLength > maxSwipeLength) {
      swipeLength = maxSwipeLength;
    }
    return swipeLength
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
    frog.removeAllActions()
    if (animation == 1) {
      frog.run(frogIdle)
      enableFrogJump()
    } else if (animation == 2) {
      frog.run(frogBeginJump)
    } else if (animation == 3){
      frog.run(frogJump)
      disableFrogJump()
    }
  }
  
  /*
   */
  func createAimDots(nrOfDots: Int) -> [SKShapeNode]{
    var size: CGFloat = 4;
    for _ in 0...nrOfDots {
      let dot = SKShapeNode(circleOfRadius: size)
      dot.fillColor = UIColor.white
      dot.isHidden = true
      dot.zPosition = 10
      dot.alpha = 0.5
      dots.append(dot)
      size -= 0.15
    }
    return dots
  }
  
  /*
   */
  func moveAimDots(sender: UIPanGestureRecognizer, swipeLength: CGFloat) {
    let currentX = sender.location(in: view).x
    let currentY = sender.location(in: view).y
    let c = -cos(acos((currentX - swipeStartX)/swipeLength))
    let s = sin(asin((currentY - swipeStartY)/swipeLength))
    var i: CGFloat = 0.5
    for dot in dots {
      var x = swipeLength/2 * i * c
      let y1 = swipeLength/2 * i * s
      let y = y1 - 0.5 * g * pow(i, 2)
      i += 1
      if (x + frog.position.x < 0) {
        x = -x - frog.position.x
        dot.position = CGPoint(x: x, y: y + frog.position.y)
      } else if (x + frog.position.x > size.width) {
        x = (size.width) - (x + frog.position.x - size.width)
        dot.position = CGPoint(x: x, y: y + frog.position.y)
      } else {
        x = x + frog.position.x
        dot.position = CGPoint(x: x, y: y + frog.position.y)
      }
    }
  }
  
  /*
   */
  func showAimDots() {
    for dot in dots {
      dot.isHidden = false
    }
  }
  
  /*
   */
  func hideAimDots() {
    for dot in dots {
      dot.isHidden = true
    }
  }
}
