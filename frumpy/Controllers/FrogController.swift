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
  private let maxSwipeLength:     CGFloat                 = 170
  private let minSwipeLength:     CGFloat                 = 60
  private let g:                  CGFloat                 = 9.8
  private let beginJumpTime:      Double                  = 0.3
  private let originTime:         Double                  = 1
  
  private let frogAnimations                              = FrogAnimations()
  
  private var size:               CGSize                  = CGSize()
  private var panner:             UIPanGestureRecognizer  = UIPanGestureRecognizer()
  private var dots:               [SKShapeNode]           = []
  
  private var frog:               SKSpriteNode            = SKSpriteNode()
  
  private var frogIdle:           SKAction                = SKAction()
  private var frogBeginJump:      SKAction                = SKAction()
  private var frogJump:           SKAction                = SKAction()
  
  private var swipeStartPosition: CGPoint                 = CGPoint()
  private var frogLastPosition:   CGPoint                 = CGPoint()
  
  private var frogLastAngle:      CGFloat                 = CGFloat()
  
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
    frogLastPosition = frog.position
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
    let const: CGFloat = 375
    let mass = frog.physicsBody!.mass
    let pos = sender.location(in: view)
    let length = calculateSwipeLength(sender: sender)
    let vector = getSwipeVector(swipeLength: length, currentPosition: pos, lastPosition: swipeStartPosition)
    let dx = -vector.dx * mass * const
    let dy = vector.dy * mass * const
    frog.physicsBody?.applyForce(CGVector(dx: dx, dy: dy))
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
    let dy = frog.position.y - frogLastPosition.y
    let dx = frog.position.x - frogLastPosition.x
    let vector = CGVector(dx: dx, dy: dy)
    if (vector.speed() > CGFloat(4)) {
      if (vector.angle() > CGFloat.pi/2 || vector.angle() < -CGFloat.pi/2) {
        frog.xScale = -1
      } else if (vector.angle() < CGFloat.pi/2 || vector.angle() > -CGFloat.pi/2) {
        frog.xScale = 1
      }
    }
    frogLastPosition = frog.position
  }
  
  /*
   */
  func calculateSwipeAngle(sender: UIPanGestureRecognizer) -> CGFloat {
    let dy = sender.location(in: view).y - swipeStartPosition.y
    let dx = sender.location(in: view).x - swipeStartPosition.x
    return atan2(dy, dx)
  }
  
  func getSwipeVector(swipeLength: CGFloat, currentPosition: CGPoint, lastPosition: CGPoint) -> CGVector{
    if (swipeLength == maxSwipeLength) {
      let alpha = asin((currentPosition.x - swipeStartPosition.x)/maxSwipeLength)
      return CGVector(dx: maxSwipeLength * sin(alpha), dy: maxSwipeLength * cos(alpha))
    } else {
      return CGVector(dx: currentPosition.x - swipeStartPosition.x, dy: currentPosition.y - swipeStartPosition.y)
    }
  }
  
  /*
   */
  @objc func swipe(sender: UIPanGestureRecognizer) {
    if (sender.state.rawValue == 1) {
      swipeStartPosition = sender.location(in: view)
      setFrogAnimation(animation: 2)
    }
    let distance = calculateSwipeLength(sender: sender)
    if (distance > 50) {
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
    var swipeLength = sqrt(pow((x - swipeStartPosition.x) , 2) + pow((y - swipeStartPosition.y), 2))
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
  
  func getTrajectoryPoint(swipeLength: CGFloat, sinAngle: CGFloat, cosAngle: CGFloat, time: CGFloat) -> CGPoint{
    let x = swipeLength/2 * time * cosAngle
    var y = swipeLength/2 * time * sinAngle
    y = y - 0.5 * g * pow(time, 2)
    y = y + frog.position.y
    return CGPoint(x: x, y: y)
  }
  
  /*
   */
  func moveAimDots(sender: UIPanGestureRecognizer, swipeLength: CGFloat) {
    let vector = getSwipeVector(swipeLength: swipeLength, currentPosition: sender.location(in: view), lastPosition: swipeStartPosition)
    let alpha = -cos(acos(vector.dx/swipeLength))
    let beta = sin(asin(vector.dy/swipeLength))
    var i: CGFloat = 0.5
    for dot in dots {
      setDotAlpha(dot: dot, swipeLength: swipeLength)
      let trejPoint = getTrajectoryPoint(swipeLength: swipeLength, sinAngle: beta, cosAngle: alpha, time: i)
      if (trejPoint.x + frog.position.x < 0) {
        let x = -trejPoint.x - frog.position.x
        dot.position = CGPoint(x: x, y: trejPoint.y)
      } else if (trejPoint.x + frog.position.x > size.width) {
        let x = (size.width) - (trejPoint.x + frog.position.x - size.width)
        dot.position = CGPoint(x: x, y: trejPoint.y)
      } else {
        let x = trejPoint.x + frog.position.x
        dot.position = CGPoint(x: x, y: trejPoint.y)
      }
      i += 0.7
    }
  }
  
  func setDotAlpha(dot: SKShapeNode, swipeLength: CGFloat) {
    dot.alpha = ((swipeLength-70)*2)/maxSwipeLength
    if(dot.alpha > 0.6) {
      dot.alpha = 0.6
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
