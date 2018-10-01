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
  var endX: CGFloat = 0;
  var endY: CGFloat = 0;
  var distance: CGFloat = 0;
  override func didMove(to view: SKView) {
    let panner = UIPanGestureRecognizer(target: self, action: #selector(GameScene.jumpSwipe(sender:)))

    view.addGestureRecognizer(panner)
  }
  @objc func jumpSwipe(sender: UIPanGestureRecognizer) {
    if(sender.state.rawValue == 1) {
      startX = sender.location(in: view).x
      startY = sender.location(in: view).y
    } else if (sender.state.rawValue == 3) {
      endX = sender.location(in: view).x
      endY = sender.location(in: view).y
      distance = sqrt(pow((startX - endX), 2) + pow((startY - endY), 2))
      if(distance > 100) {
        distance = 100;
      }
      print("distance: ", distance)
    }
    
   
  }
}
