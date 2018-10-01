//
//  GameScene.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-01.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  var startX: CGFloat = 0;
  var startY: CGFloat = 0;
  override func didMove(to view: SKView) {
    let panner = UIPanGestureRecognizer(target: self, action: #selector(GameScene.jumpSwipe(sender:)))
    view.addGestureRecognizer(panner)
  }
  @objc func jumpSwipe(sender: UIPanGestureRecognizer) {
    if(sender.state.rawValue == 1) {
      startX = sender.location(in: view).x
      startY = sender.location(in: view).y
      print("START")
      print("")
    } else if (sender.state.rawValue == 3) {
      print("END")
      print("Swipe Angle: ", calculateAngle(sender: sender))
      print("Frog Heading:", calculateFrogHeading(swipeAngle: calculateAngle(sender: sender)))
      print("Distance: ", calculateDistance(sender: sender))
      print("")
      //TODO: Implement frog jump
    }
    else {
      print("CHANGE")
      print("Swipe Angle: ", calculateAngle(sender: sender))
      print("Frog Heading:", calculateFrogHeading(swipeAngle: calculateAngle(sender: sender)))
      print("Distance: ", calculateDistance(sender: sender))
      print("")
      //TODO: Implement heading dots
    }
  }
  
  @objc func calculateDistance(sender: UIPanGestureRecognizer) -> CGFloat {
    let x = sender.location(in: view).x
    let y = sender.location(in: view).y
    var distance = sqrt(pow((x - startX) , 2) + pow((y - startY), 2))
    if(distance > 150) {
      distance = 150;
    }
    return distance
  }
  
  @objc func calculateAngle(sender: UIPanGestureRecognizer) -> CGFloat {
    let x = sender.location(in: view).x
    let y = sender.location(in: view).y
    return atan2((y - startY), (x - startX))
  }
  
  @objc func calculateFrogHeading(swipeAngle: CGFloat) -> CGFloat {
    if(swipeAngle < 0) {
      return swipeAngle + CGFloat.pi
    }
    return swipeAngle - CGFloat.pi
  }
}
