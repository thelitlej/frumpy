//
//  GameScene.swift
//  frumpy
//
//  Created by Jonas Gustafson on 2018-10-01.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  let leafController = LeafController()

  var frogController = FrogController()
  
  let kLeafCategory: UInt32 = 0x1 << 0
  let nrOfAimDots = 6
  let cam = SKCameraNode()
  var frog: SKSpriteNode = SKSpriteNode()
  var floor: SKSpriteNode = SKSpriteNode()
  var leftWall: SKSpriteNode = SKSpriteNode()
  var rightWall: SKSpriteNode = SKSpriteNode()

  var dots: [SKShapeNode] = []
  var startX: CGFloat = 0;
  var startY: CGFloat = 0;
  var landingSucsess = false;
  var frogPosition = CGPoint()
  var maxX : CGFloat = 0
  var maxY : CGFloat = 0
  var sprites = [SKSpriteNode]()
  var spritesAdded = [SKSpriteNode]()
  var scoreLabel: SKLabelNode?
  var score:Int = 0 { didSet { scoreLabel!.text = "\(score)" } }
  

  var water = SKSpriteNode(imageNamed: "water")

  override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.physicsBody?.density = 0
    self.view!.showsFPS = true
    self.camera = cam
    self.view!.showsNodeCount = true
    self.view!.showsFPS = true
    self.camera = cam
    self.view!.showsNodeCount = true
    self.backgroundColor = .white
    
    createSafeFloor()
    frogController = FrogController(size: frame.size)
    frog = frogController.addFrog()
    frog.name = "frog"
    floor = addFloor()
    leftWall = addLeftWall()
    rightWall = addRightWall()
    cam.addChild(floor)
    cam.addChild(leftWall)
    cam.addChild(rightWall)


    maxX = frame.width
    maxY = frame.height
    
    backgroundColor = .black
    scoreLabel = SKLabelNode( text: "\(score)")
    scoreLabel!.fontSize = 100
    scoreLabel?.position = CGPoint(x: 0,y: 250)

    cam.addChild(scoreLabel!)
    addCamera()

    addChild(frog)
    addLeaf(position: CGPoint(x: 100, y: 100))
    addLeaf(position: CGPoint(x: 300, y: 300))

    dots = frogController.createAimDots(nrOfDots: nrOfAimDots)
    for dot in dots {
      addChild(dot)
    }
    view.addGestureRecognizer(frogController.initPanner())
    
  }
  
  override func update(_ currentTime: CFTimeInterval) {
    frogController.updateFrogAngle()
    cam.position.y = frog.position.y
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    if(contact.bodyA.node?.name == "floor") {
      print(spritesAdded)
      contact.bodyB.node?.removeFromParent()
      print("YES")
    }
    if(contact.collisionImpulse > 16 && contact.contactNormal.dy < 0) {
      if(contact.bodyA.node?.name == "frog" && contact.bodyB.node?.name == "leaf") {
        frogController.setFrogAnimation(animation: 1)
        addLeaf(position: generateRandomPosition())
        score += 1
        print(score)

      }
    }
  
  }
   
  func addFloor () -> SKSpriteNode {
    let floor = SKSpriteNode(color: .init(white: 1, alpha: 0.1) , size: CGSize(width: frame.width, height: 30))
    
    floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
    floor.physicsBody?.collisionBitMask = 0
    floor.physicsBody?.isDynamic = true
    floor.physicsBody?.affectedByGravity = false
    floor.physicsBody?.allowsRotation = false
    floor.position = CGPoint(x: frame.width-frame.width, y: -frame.height/1.5)
    floor.physicsBody?.restitution = 0.2
    floor.physicsBody?.friction = 0.9
    floor.name = "floor"
    
    return floor
  }
  
  func addLeftWall () -> SKSpriteNode {
    let leftWall = SKSpriteNode(color: .white, size: CGSize(width: 3, height: frame.height))
    
    
    leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
    leftWall.physicsBody?.isDynamic = false
    leftWall.physicsBody?.restitution = 0.8
    leftWall.physicsBody?.friction = 0
    leftWall.physicsBody?.collisionBitMask = 10;
    leftWall.position = CGPoint(x: -frame.width/2, y: frame.height-frame.height)
    leftWall.name = "leftWall"
    
    return leftWall
  }
  
  func addRightWall () -> SKSpriteNode {
    let rightWall = SKSpriteNode(color: .white, size: CGSize(width: 3, height: frame.height))
    
    rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
    rightWall.physicsBody?.isDynamic = false
    rightWall.physicsBody?.collisionBitMask = 10;
    rightWall.physicsBody?.friction = 0
    rightWall.physicsBody?.restitution = 0.8
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
    floor.physicsBody?.friction = 0.9

    addChild(floor)
  }

  func addCamera() {
    cam.position.x = size.width / 2
    cam.position.y = size.height
    addChild(cam)
    
  }
  
  func generateRandomPosition() -> CGPoint {
    let xPos = CGFloat( Float(arc4random()) / Float(UINT32_MAX)) * maxX
    let yPos = CGFloat( Float(arc4random()) / Float(UINT32_MAX)) * maxY + frog.position.y
    return CGPoint(x: xPos, y: yPos)
  }

  func addLeaf(position: CGPoint){
    let currentLeaf = SKSpriteNode(imageNamed: "leaf_brown")
    
    currentLeaf.size = CGSize(width: (currentLeaf.size.width/4), height: (currentLeaf.size.height/4))
    currentLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: currentLeaf.size.width/1.5,
                                                                height: currentLeaf.size.height/12))
    currentLeaf.physicsBody?.isDynamic = false
    currentLeaf.physicsBody!.categoryBitMask = 10
    currentLeaf.physicsBody!.contactTestBitMask = 10
    currentLeaf.physicsBody!.collisionBitMask = 10
    currentLeaf.physicsBody!.friction = 5
    currentLeaf.name = "leaf"
    currentLeaf.position = position
    
    
    addChild(currentLeaf)
  }

  func createWater(){
    /*Function to create water: NOT WORKING*/
    let water = SKSpriteNode(imageNamed: "water")
    water.name = "water"
    water.size = CGSize(width: (self.scene?.size.width)!, height: 300)
    water.anchorPoint = CGPoint(x: 300, y: 300)
    water.position = CGPoint(x: water.size.width, y: -(self.frame.size.height / 2))
    self.addChild(water)
  }
  
  func moveWater() {
    /*Function to move water in y: NOT WORKING*/
    //self.enumerateChildNodes("water", using: <#T##(SKNode, UnsafeMutablePointer<ObjCBool>) -> Void#>)
  }
}

