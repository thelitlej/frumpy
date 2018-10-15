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
  
  convenience init(frogZPosition: CGFloat) {
    self.init()
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
        let moveHorrizontal = SKAction.moveTo(x: -waterLayer.size.width + waterLayer.size.width/2, duration: 10)
        let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
        let moveGroup = SKAction.group([moveHorrizontal, moveVertical])
        let moveArray = [moveGroup, resetPosition]
        sequence = SKAction.sequence(moveArray)
      } else {
        let moveHorrizontal = SKAction.moveTo(x: waterLayer.size.width - waterLayer.size.width, duration: 10)
        let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
        let moveGroup = SKAction.group([moveHorrizontal, moveVertical])
        let moveArray = [moveGroup, resetPosition]
        sequence = SKAction.sequence(moveArray)
      }
      waterLayer.run(SKAction.repeatForever(sequence))
    }
  }
  
  public func buildSpareWater(color: UIColor) -> SKShapeNode {
    let spareWater = SKShapeNode(rectOf: CGSize(width: 750, height: 750))
    spareWater.fillColor = color
    spareWater.strokeColor = UIColor.clear
    spareWater.position = CGPoint(x: 750/2, y: -450)
    spareWater.zPosition = frogZPosition + 2
    animateSpareWater(spareWater: spareWater)
    return spareWater
  }
  
  private func animateSpareWater(spareWater: SKShapeNode) {
    let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
    spareWater.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 750, height: 750))
    spareWater.physicsBody?.affectedByGravity = false
    spareWater.physicsBody?.collisionBitMask = 0
    spareWater.physicsBody?.isDynamic = false
    spareWater.name = "water"
    spareWater.run(SKAction.repeatForever(moveVertical))
  }
  
  public func increseWaterFillSpeed(spareWater: SKShapeNode, waterLayers: [WaterLayer]) {
    waterFillSpeed = waterFillSpeed + 50
    speedSpareWater(spareWater: spareWater)
    speedWater(waterLayers: waterLayers)
  }
  
  private func speedWater(waterLayers: [WaterLayer]) {
    for waterLayer in waterLayers {
      let moveVertical = SKAction.move(by: CGVector(dx: 0, dy: waterFillSpeed), duration: 10)
      waterLayer.run(SKAction.repeatForever(moveVertical))
    }
  }
  
  private func speedSpareWater(spareWater: SKShapeNode) {
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
