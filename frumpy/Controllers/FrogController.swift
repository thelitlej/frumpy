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
  
  private var jumpEnabled:        Bool                    = true
  
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
    let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frogSize.width/1.9, height: frogSize.height/2), center: CGPoint(x: frog.position.x, y: frog.position.y - 17))
    frog.physicsBody = physicsBody
    frog.size = frogSize
    frog.position = CGPoint(x: 70 + frog.size.width/10, y: 160)
    frog.physicsBody?.restitution = 0.2
    frog.physicsBody?.angularDamping = 0
    frog.physicsBody?.linearDamping = 0
    frog.physicsBody?.collisionBitMask = 10
    frog.physicsBody?.contactTestBitMask = 10
    frog.physicsBody?.allowsRotation = false
    frog.physicsBody?.usesPreciseCollisionDetection = true
    frogLastPosition = frog.position
  }
  

  func makeJump(vector: CGVector) {
    let const: CGFloat = 375
    let mass = frog.physicsBody!.mass
    let dx = -vector.dx * mass * const
    let dy = vector.dy * mass * const
    frog.physicsBody?.applyForce(CGVector(dx: dx, dy: dy))
  }
  

  func enableJump() {
    jumpEnabled = true
  }
  
  func disableJump() {
    jumpEnabled = false
  }
  
  func jumpIsEnabled() -> Bool {
    return jumpEnabled
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
  func checkAngle(angle: CGFloat) {
    if(angle > CGFloat.pi/2 || angle < -CGFloat.pi/2) {
      frog.xScale = -1
    } else if (angle < CGFloat.pi/2 || angle > -CGFloat.pi/2) {
      frog.xScale = 1
    }
  }
  
  /*
   */
  func setFrogAnimation(animation: Int) {
    frog.removeAllActions()
    if (animation == 1) {
      frog.run(frogIdle)
      enableJump()
    } else if (animation == 2) {
      frog.run(frogBeginJump)
    } else if (animation == 3){
      frog.run(frogJump)
      disableJump()
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
  
  func moveAimDots(vector: CGVector, swipeLength: CGFloat) {
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
