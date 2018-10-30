//
//  WaterController.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-13.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import SpriteKit
import Foundation
import GameplayKit

class WaterController: UIViewController {
  private var frogZPosition: CGFloat = CGFloat()
  private var size: CGSize = CGSize()
  private var frogFellIn: Bool = Bool()
  private var waterFillSpeed: CGFloat = CGFloat()
  private var frameSize: CGSize = CGSize()
  
  convenience init(frogZPosition: CGFloat, frameSize: CGSize) {
    self.init()
    self.frameSize = frameSize
    self.frogZPosition = frogZPosition
    frogFellIn = false
    waterFillSpeed = 0
  }
  
  public func buildWater(size: CGSize) -> [WaterLayer] {
    self.size = size
    var waterLayers: [WaterLayer] = [WaterLayer]()
    for i in 0...3 {
      let imageNamed = "waves_\(i)"
      let z = getZPosition(index: i)
      var direction: String = String()
      var position: CGPoint = CGPoint()
      if (i == 1) {
        direction = getAnimationDirection(index: i)
        position = CGPoint(x: -frameSize.width*2, y: 0)
      } else if (i != 3) {
        direction = getAnimationDirection(index: i)
        position = CGPoint(x: 0, y: 0)
      } else {
        direction = "still"
        position = CGPoint(x: 0, y: -290)
      }
      let waterLayer = WaterLayer(imageNamed: imageNamed, zPosition: z, animationDirection: direction, size: size)
      waterLayer.position = position
      print(waterLayer.position)
      waterLayers.append(waterLayer)
    }
    animateWater(waterLayers: waterLayers)
    return waterLayers
  }
  
  private func animateWater(waterLayers: [WaterLayer]) {
    for waterLayer in waterLayers {
      let sequence: SKAction
      let originPosition = waterLayer.position
      let resetPosition = SKAction.moveTo(x: originPosition.x, duration: 0)
      if (waterLayer.getAnimationDirection() == "left") {
        let b = SKAction.moveBy(x: -30, y: 5, duration: 0.5)
        b.timingMode = SKActionTimingMode(rawValue: 3)!
        let s = SKAction.moveBy(x: 30, y: -5, duration: 0.5)
        s.timingMode = SKActionTimingMode(rawValue: 3)!
        let scale = SKAction.sequence([b, s, b, s, b, s, b, s, b, s, b, s, b, s, b, s, b, s, b, s])
        let moveHorrizontal = SKAction.moveTo(x: -waterLayer.size.width + waterLayer.size.width/2, duration: 10)
        let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
        let moveGroup = SKAction.group([moveHorrizontal, moveVertical, scale])
        let moveArray = [moveGroup, resetPosition]
        sequence = SKAction.sequence(moveArray)
      } else if (waterLayer.getAnimationDirection() == "right") {
        let b = SKAction.moveBy(x: 30, y: 5, duration: 0.5)
        b.timingMode = SKActionTimingMode(rawValue: 3)!
        let s = SKAction.moveBy(x: -30, y: -5, duration: 0.5)
        s.timingMode = SKActionTimingMode(rawValue: 3)!
        let scale = SKAction.sequence([b, s, b, s, b, s, b, s, b, s, b, s, b, s, b, s, b, s, b, s])
        let moveHorrizontal = SKAction.moveTo(x: 0, duration: 10)
        let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
        let moveGroup = SKAction.group([moveHorrizontal, moveVertical, scale])
        let moveArray = [moveGroup, resetPosition]
        sequence = SKAction.sequence(moveArray)
      } else {
        waterLayer.name = "water"
        waterLayer.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: waterLayer.size.width, height: waterLayer.size.height))
        waterLayer.physicsBody?.affectedByGravity = false
        waterLayer.physicsBody?.collisionBitMask = 0
        waterLayer.physicsBody?.isDynamic = false
        sequence = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
      }
      waterLayer.run(SKAction.repeatForever(sequence), withKey: "water")
     
    }
  }
  
  public func increseWaterFillSpeed(waterLayers: [WaterLayer]) {
    waterFillSpeed = waterFillSpeed + 30
    speedWater(waterLayers: waterLayers)
  }
  
  private func speedWater(waterLayers: [WaterLayer]) {
    for waterLayer in waterLayers {
      let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
      waterLayer.run(SKAction.repeatForever(moveVertical))
    }
  }
  
  public func setPosition(waterLayers: [WaterLayer], camera: SKCameraNode) {
    for waterLayer in waterLayers {
      if (waterLayer.getAnimationDirection() == "left") {
        waterLayer.position = CGPoint(x: camera.frame.width, y: camera.position.y - 500)
      } else if (waterLayer.getAnimationDirection() == "right"){
        waterLayer.position = CGPoint(x: -camera.frame.width, y: camera.position.y - 500)
      } else {
        waterLayer.run(SKAction.move(to: CGPoint(x: camera.frame.width, y: camera.position.y - 790), duration: 0))
      }
    }
  }

  public func frogDidFallIn() -> Bool{
    return frogFellIn
  }
  
  public func frogFellInWater(did: Bool) {
    frogFellIn = did
  }
  
  private func getZPosition(index: Int) -> CGFloat {
    if (index == 0) {
      return frogZPosition - 1
    } else {
      return frogZPosition + CGFloat(index)
    }
  }
  
  private func getAnimationDirection(index: Int) -> String {
    if (index % 2 == 0) {
      return "left"
    } else {
      return "right"
    }
  }
  
}
