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
  let frogController = FrogController()
  let kLeafCategory: UInt32 = 0x1 << 0
  let nrOfAimDots = 7
  let cam = SKCameraNode()
  var frog: SKSpriteNode = SKSpriteNode()
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
    addBackground()
    self.physicsWorld.contactDelegate = self
    self.view!.showsFPS = true
    self.camera = cam
    self.view!.showsNodeCount = true
    self.backgroundColor = .white
    createWalls()
    frog = frogController.addFrog()
    frog.name = "frog"
    maxX = frame.width
    maxY = frame.height
    backgroundColor = .black
    scoreLabel = SKLabelNode( text: "\(score)")
    scoreLabel?.zPosition = 3
    scoreLabel!.fontSize = 100
    scoreLabel?.position = CGPoint(x: 0,y: 250)
    //scoreLabel!.position = CGPoint(x: self.size.width-20, y: self.size.height-40)
    cam.addChild(scoreLabel!)
    addCamera()
    addChild(frog)
    addChild(leafController.addFirstLeaf())
    addChild(leafController.addSecondLeaf())

    dots = frogController.createAimDots(nrOfDots: nrOfAimDots)
    for dot in dots {
      insertChild(dot, at: 3)
    }
    view.addGestureRecognizer(frogController.initPanner())
    self.view!.showsFPS = true
    self.camera = cam
    self.view!.showsNodeCount = true
  }
  
  override func update(_ currentTime: CFTimeInterval) {
    frogController.updateFrogAngle()
    cam.position.y = frog.position.y
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    if(contact.collisionImpulse > 16 && contact.contactNormal.dy < 0) {
      if(contact.bodyA.node?.name == "frog" && contact.bodyB.node?.name == "leaf") {
        frogController.setFrogAnimation(animation: 1)
        addRandomLeaf()
        score += 1
        print(score)

      }
    }
  
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
  
  func addBackground() {
    
    for i in 0..<4
    {
      let background = Tree(imageNr: 1, size: frame.size)
      self.addChild(background.addTreeSprite(imageNr: i + 1, position: CGPoint(x:self.frame.width / 2, y:CGFloat(i) * self.frame.height)))
      
    }
  }
  
  func addRandomLeaf(){
    /*This function add random leaf*/
    let currentLeaf = SKSpriteNode(imageNamed: "leaf_brown")
    currentLeaf.zPosition = 1
     currentLeaf.size = CGSize(width: (currentLeaf.size.width/4), height: (currentLeaf.size.height/4))
    currentLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: currentLeaf.size.width/1.5,
                                                              height: currentLeaf.size.height/12))
    currentLeaf.physicsBody?.isDynamic = false
    currentLeaf.physicsBody!.categoryBitMask = 10
    currentLeaf.physicsBody!.contactTestBitMask = 10
    currentLeaf.physicsBody!.collisionBitMask = 10
    currentLeaf.physicsBody!.friction = 5
    currentLeaf.name = "leaf"
  
    
      let xPos = CGFloat( Float(arc4random()) / Float(UINT32_MAX)) * maxX
      let yPos = CGFloat( Float(arc4random()) / Float(UINT32_MAX)) * maxY + frog.position.y
      
       currentLeaf.position = CGPoint(x: xPos, y: yPos )
      
      for sprite in spritesAdded{
        if (currentLeaf.intersects(sprite)){
          return
        }
      }
      addChild(currentLeaf)
      spritesAdded.append(currentLeaf)
    }
  
  func createWater(){
    /*Function to create water: NOT WORKING*/
    let water = SKSpriteNode(imageNamed: "water")
    water.name = "water"
    water.size = CGSize(width: (self.scene?.size.width)!, height: 300)
    water.anchorPoint = CGPoint(x: 300, y: 300)
    water.position = CGPoint(x: water.size.width, y: -(self.frame.size.height / 2))
    self.addChild(water)
    print(sprites)
  }
  
  func moveWater() {
    /*Function to move water in y: NOT WORKING*/
    //self.enumerateChildNodes("water", using: <#T##(SKNode, UnsafeMutablePointer<ObjCBool>) -> Void#>)
  }
}

