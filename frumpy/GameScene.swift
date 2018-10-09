//
//  GameScene.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-01.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import SpriteKit
import GameplayKit
import Lottie


class GameScene: SKScene, SKPhysicsContactDelegate {
  
  let leafController = LeafController()
  let frogController = FrogController()
  
  let kLeafCategory: UInt32 = 0x1 << 0
  let nrOfAimDots = 7
  
  var frog: SKSpriteNode = SKSpriteNode()
  let cam = SKCameraNode()
  var dots: [SKShapeNode] = []
  var startX: CGFloat = 0;
  var startY: CGFloat = 0;
  var landingSucsess = false;

  var water = SKSpriteNode(imageNamed: "water")

  override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.view!.showsFPS = true
    self.camera = cam
    self.view!.showsNodeCount = true
    
    addCamera()
    
    createWalls()
    
    frog = frogController.addFrog()
    frog.name = "frog"
    addChild(frog)
    
    insertChild(leafController.addFirstLeaf(), at: 0)
    insertChild(leafController.addSecondLeaf(), at: 0)
    
    dots = frogController.createAimDots(nrOfDots: nrOfAimDots)
    for dot in dots {
      addChild(dot)
    }
  
    view.addGestureRecognizer(frogController.initPanner())
  }
  
  override func update(_ currentTime: CFTimeInterval) {
    frogController.updateFrogAngle()
    cam.position.y = frog.position.y / 1.5
  }
  
  func createWalls() {
    let leftWall = SKSpriteNode(color: .white, size: CGSize(width: 3, height: frame.height))
    let rightWall = SKSpriteNode(color: .white, size: CGSize(width: 3, height: frame.height))
    let floor = SKSpriteNode(color: .white, size: CGSize(width: frame.width, height: 3))
    
    leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
    leftWall.physicsBody?.isDynamic = false
    leftWall.physicsBody?.restitution = 1
    leftWall.physicsBody?.collisionBitMask = 10;
    leftWall.position = CGPoint(x: 0, y: frame.height / 2)
    leftWall.name = "leftWall"
    
    rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
    rightWall.physicsBody?.isDynamic = false
    rightWall.physicsBody?.restitution = 1
    rightWall.physicsBody?.collisionBitMask = 10;
    rightWall.position = CGPoint(x: frame.width, y: frame.height / 2)
    rightWall.name = "rightWall"
    
    floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
    floor.physicsBody?.isDynamic = false
    floor.position = CGPoint(x: frame.width / 2, y: 0)
    floor.physicsBody?.collisionBitMask = 10;
    floor.physicsBody?.restitution = 0.2
    floor.physicsBody?.friction = 0.9

    addChild(leftWall)
    addChild(rightWall)
    addChild(floor)
  }

  func addCamera() {
    cam.position.x = size.width / 2
    cam.position.y = size.height
    addChild(cam)
  }
  
  func createWater(){
    let water = SKSpriteNode(imageNamed: "water")
    water.name = "water"
    water.size = CGSize(width: (self.scene?.size.width)!, height: 300)
    water.anchorPoint = CGPoint(x: 300, y: 300)
    water.position = CGPoint(x: water.size.width, y: -(self.frame.size.height / 2))
    self.addChild(water)
    
  }
  func moveWater() {
    //self.enumerateChildNodes("water", using: <#T##(SKNode, UnsafeMutablePointer<ObjCBool>) -> Void#>)
  }

}
