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
    for i in 0...2 {
      let imageNamed = "waves_\(i)"
      let z = getZPosition(index: i)
      let direction = getAnimationDirection(index: i)
      let waterLayer = WaterLayer(imageNamed: imageNamed, zPosition: z, animationDirection: direction, size: size)
      waterLayer.position = CGPoint(x: 0, y: 0)
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
      } else {
        let b = SKAction.moveBy(x: 30, y: 5, duration: 0.5)
        b.timingMode = SKActionTimingMode(rawValue: 3)!
        let s = SKAction.moveBy(x: -30, y: -5, duration: 0.5)
        s.timingMode = SKActionTimingMode(rawValue: 3)!
        let scale = SKAction.sequence([b, s, b, s, b, s, b, s, b, s, b, s, b, s, b, s, b, s, b, s])
        let moveHorrizontal = SKAction.moveTo(x: waterLayer.size.width - waterLayer.size.width, duration: 10)
        let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
        let moveGroup = SKAction.group([moveHorrizontal, moveVertical, scale])
        let moveArray = [moveGroup, resetPosition]
        sequence = SKAction.sequence(moveArray)
      }
      waterLayer.run(SKAction.repeatForever(sequence), withKey: "water")
     
    }
  }
  
  public func buildSpareWater(color: UIColor, size: CGSize) -> SKSpriteNode {
    self.size = size
    let spareWater = SKSpriteNode(texture: nil, color: color, size: size)
    spareWater.position = CGPoint(x: size.width / 2, y: -size.height + 300)
    spareWater.zPosition = frogZPosition + 2
    animateSpareWater(spareWater: spareWater)
    return spareWater
  }
  
  private func animateSpareWater(spareWater: SKSpriteNode) {
    let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
    spareWater.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 750, height: 750))
    spareWater.physicsBody?.affectedByGravity = false
    spareWater.physicsBody?.collisionBitMask = 0
    spareWater.physicsBody?.isDynamic = false
    spareWater.name = "water"
    spareWater.run(SKAction.repeatForever(moveVertical), withKey: "water")
  }
  
  public func increseWaterFillSpeed(spareWater: SKSpriteNode, waterLayers: [WaterLayer]) {
    waterFillSpeed = waterFillSpeed + 30
    speedSpareWater(spareWater: spareWater)
    speedWater(waterLayers: waterLayers)
  }
  
  private func speedWater(waterLayers: [WaterLayer]) {
    for waterLayer in waterLayers {
      let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
      waterLayer.run(SKAction.repeatForever(moveVertical))
    }
  }
  
  public func setPosition(waterLayers: [WaterLayer], frame: SKCameraNode, spareWater: SKSpriteNode) {
    for waterLayer in waterLayers {
       waterLayer.position = CGPoint(x: frame.frame.width, y: frame.position.y - 500)
    }
    print("SPARE WATER POSITION 1: ", spareWater.position)
    spareWater.position = CGPoint(x: frame.frame.width, y: frame.position.y - 500)
    print("SPARE WATER POSITION 2: ", spareWater.position)
  }
  
  private func speedSpareWater(spareWater: SKSpriteNode) {
    let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
    spareWater.run(SKAction.repeatForever(moveVertical))
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
