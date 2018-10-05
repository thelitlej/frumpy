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

  let kLeafCategory: UInt32 = 0x1 << 0
  let nrOfAimDots = 7
  let leafController = LeafController()
  let frogController = FrogController()
  var frog: SKSpriteNode = SKSpriteNode()
  let cam = SKCameraNode()
  var dots: [SKShapeNode] = []
  var startX: CGFloat = 0;
  var startY: CGFloat = 0;

  override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    frog = frogController.addFrog()
    frog.name = "frog"
    backgroundColor = .lightGray
    leafController.nextRandomLeaf()
    addCamera()
    //frogController.createAimDots(nrOfDots: nrOfAimDots)
    insertChild(leafController.addFirstLeaf(), at: 0)
    insertChild(leafController.addLeaf(), at: 0)
    addChild(frog)
    dots = frogController.createAimDots(nrOfDots: nrOfAimDots)
    for dot in dots {
      addChild(dot)
    }
    createWall(left: true)
    createWall(left: false)
    view.addGestureRecognizer(frogController.initPanner())
  }
  
  func createWall(left: Bool) {
    //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

    let wall = SKSpriteNode(color: .white, size: CGSize(width: 3, height: frame.height))
    wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
    wall.physicsBody?.isDynamic = false
    wall.physicsBody?.restitution = 1
    //wall.physicsBody?.categoryBitMask = 10;
    wall.physicsBody?.collisionBitMask = 10;
    //wall.physicsBody?.contactTestBitMask = 10;
    let floor = SKSpriteNode(color: .white, size: CGSize(width: frame.width, height: 3))
    floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
    floor.physicsBody?.isDynamic = false
    floor.position = CGPoint(x: frame.width / 2, y: 0)
    //floor.physicsBody?.categoryBitMask = 10;
    floor.physicsBody?.collisionBitMask = 10;
    floor.physicsBody?.restitution = 0.2
    floor.physicsBody?.friction = 0.9
    //floor.physicsBody?.contactTestBitMask = 10;

    switch left {
    case true:
      wall.position = CGPoint(x: 0, y: frame.height / 2)
      wall.name = "leftWall"
    default:
      wall.position = CGPoint(x: frame.width, y: frame.height / 2)
      wall.name = "rightWall"
    }
    addChild(wall)
    addChild(floor)
    self.view!.showsFPS = true
    self.camera = cam
    self.view!.showsNodeCount = true
  }
  func didBegin(_ contact: SKPhysicsContact) {
    let firstNode = contact.bodyA.node as! SKSpriteNode
    let secondNode = contact.bodyB.node as! SKSpriteNode

    if firstNode.name == "frog" && secondNode.name == "leftWall" {
      frogController.flipFrog(direction: 1)
    }
    else if firstNode.name == "frog" && secondNode.name == "rightWall" {
      frogController.flipFrog(direction: -1)
    }
  }
  @objc func addCamera() {
    cam.position.x = size.width / 2
    cam.position.y = size.height
    addChild(cam)
  }
  override func update(_ currentTime: CFTimeInterval) {
    cam.position.y = frog.position.y / 1.5
  }
}
