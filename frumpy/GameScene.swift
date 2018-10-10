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
  var floor: SKSpriteNode = SKSpriteNode()
  var leftWall: SKSpriteNode = SKSpriteNode()
  var rightWall: SKSpriteNode = SKSpriteNode()
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
    
    createSafeFloor()
    
    frog = frogController.addFrog()
    frog.name = "frog"
    backgroundColor = .lightGray
    //leafController.nextRandomLeaf()
    addCamera()
    floor = addFloor()
    leftWall = addLeftWall()
    rightWall = addRightWall()
    cam.addChild(floor)
    cam.addChild(leftWall)
    cam.addChild(rightWall)
    //frogController.createAimDots(nrOfDots: nrOfAimDots)
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
   
  func addFloor () -> SKSpriteNode {
     let floor = SKSpriteNode(color: .init(white: 1, alpha: 0.1) , size: CGSize(width: frame.width, height: 30))
    
    
    floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
    floor.physicsBody?.isDynamic = false
    floor.physicsBody?.affectedByGravity = false
    floor.physicsBody?.allowsRotation = false
    floor.position = CGPoint(x: frame.width-frame.width, y: -frame.height/4)
    //floor.physicsBody?.categoryBitMask = 10;
    floor.physicsBody?.collisionBitMask = 10;
    floor.physicsBody?.restitution = 0.2
    floor.physicsBody?.friction = 0.9
    //floor.physicsBody?.contactTestBitMask = 10;
    floor.name = "floor"
    
    return floor
  }
  
  func addLeftWall () -> SKSpriteNode {
    let leftWall = SKSpriteNode(color: .white, size: CGSize(width: 3, height: frame.height))
    
    
    leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
    leftWall.physicsBody?.isDynamic = false
    leftWall.physicsBody?.restitution = 1
    leftWall.physicsBody?.collisionBitMask = 10;
    leftWall.position = CGPoint(x: -frame.width/2, y: frame.height-frame.height)
    leftWall.name = "leftWall"
    
    return leftWall
  }
  
  func addRightWall () -> SKSpriteNode {
    let rightWall = SKSpriteNode(color: .white, size: CGSize(width: 3, height: frame.height))
    
    rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
    rightWall.physicsBody?.isDynamic = false
    rightWall.physicsBody?.restitution = 1
    rightWall.physicsBody?.collisionBitMask = 10;
    rightWall.position = CGPoint(x: frame.width/2, y: frame.height-frame.height)
    rightWall.name = "rightWall"
    
    return rightWall
  }
  
  func createSafeFloor()  {
    //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    let floor = SKSpriteNode(color: .white, size: CGSize(width: frame.width, height: 3))
    
    floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
    floor.physicsBody?.isDynamic = false
    floor.position = CGPoint(x: frame.width / 2, y: 0)
    floor.physicsBody?.collisionBitMask = 10;
    floor.physicsBody?.restitution = 0.2
    floor.physicsBody?.friction = 0.9

    addChild(floor)
  }

  func addCamera() {
    cam.position.x = size.width / 2
    cam.position.y = size.height
    addChild(cam)
    
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    if(contact.bodyA.node?.name == "floor" || contact.bodyB.node?.name == "floor") {
      print("collide")
    }
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
