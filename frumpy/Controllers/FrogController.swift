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
    frog.position = CGPoint(x: 100, y: 260)
    frog.physicsBody?.mass = 0.155
    frog.physicsBody?.allowsRotation = false
    frog.physicsBody?.collisionBitMask = 10;
    frog.physicsBody?.contactTestBitMask = 10;
    frog.zPosition = 1
  }

  func frogJump(angle: CGFloat, distance: CGFloat) {
    let velocity = CGVector(dx: -cos(angle)*(distance), dy: sin(angle)*(distance))
    frog.physicsBody?.applyImpulse(velocity)
    frog.physicsBody?.affectedByGravity = true
    //let action = SKAction.rotate(byAngle: 1, duration: 1)
    //frog.run(action)
  }
  
  func updateFrogAngle() {
    let velocity = frog.physicsBody?.velocity
    let speed = velocity?.speed()
    let angle = velocity?.angle()
    print(angle as Any)
    if(angle ?? 0 > CGFloat.pi/2) {
      frog.xScale = -1;
      } else {
      frog.xScale = 1;
    }
//    if(speed ?? 0 > minSpeed ?? 200) {
//      frog.zRotation = (angle ?? 0)/2
//    } else {
//      frog.zRotation = 0;
//    }
  }
  
  func createAimDots(nrOfDots: Int) -> [SKShapeNode]{
    var size: CGFloat = 4;
    for _ in 0...nrOfDots {
      let dot = SKShapeNode(circleOfRadius: size)
      dot.position = CGPoint(x: -100, y: -100)
      dot.fillColor = UIColor.white
      dot.isHidden = true
      dot.alpha = 0.5
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
    var i: CGFloat = 1
    for dot in dots {
      let x = distance/2 * i * c
      let y1 = distance/2 * i * s
      let y = y1 - 0.5 * g * pow(i, 2)
      i += 1
      dot.position = CGPoint(x: x + frog.position.x, y: y + frog.position.y)
    }
  }
  
  func calculateSwipeLength(sender: UIPanGestureRecognizer) -> CGFloat {
    let x = sender.location(in: view).x
    let y = sender.location(in: view).y
    var distance = sqrt(pow((x - startX) , 2) + pow((y - startY), 2))
    if(distance > 200) {
      distance = 200;
    }
    return distance
  }
  
  func calculateSwipeAngle(sender: UIPanGestureRecognizer) -> CGFloat {
    let dy = sender.location(in: view).y - startY
    let dx = sender.location(in: view).x - startX
    return atan2(dy, dx)
  }
  
  
  func initPanner() -> UIPanGestureRecognizer {
    let panner = UIPanGestureRecognizer(target: self, action: #selector(FrogController.swipe(sender: )))
    return panner
  }
  
  @objc func swipe(sender: UIPanGestureRecognizer) {
    let angle = calculateSwipeAngle(sender: sender)
    let distance = calculateSwipeLength(sender: sender)
    if(distance > 70) {
      showDots()
      if(sender.state.rawValue == 1) {
          startX = sender.location(in: view).x
          startY = sender.location(in: view).y
      } else if (sender.state.rawValue == 3) {
        hideDots()
        frogJump(angle: angle, distance: distance)
        
      } else {
        moveDots(sender: sender, distance: distance)
      }
    }
    else {
      hideDots()
    }
  }
}
