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
  var spritesAdded = [SKSpriteNode]()
  var scoreLabel: SKLabelNode?
  var score:Int = 0

  var water = SKSpriteNode(imageNamed: "water")

  override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.physicsBody?.density = 0
    self.view!.showsFPS = true
    self.camera = cam
    self.view!.showsNodeCount = true
    self.backgroundColor = .white
    insertTree()
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
    insertStartBush()
    
    backgroundColor = .black

    cam.addChild(scoreText)

    pauseButton.name = "pausebtn"
    cam.addChild(pauseButton)
    
    addCamera()
    
    addChild(frog)
    addLeaf(position: CGPoint(x: 100, y: 100), isVisited: true)
    addLeaf(position: CGPoint(x: 300, y: 300), isVisited: false)

    dots = frogController.createAimDots(nrOfDots: nrOfAimDots)
    for dot in dots {
      insertChild(dot, at: 3)
    }
    view.addGestureRecognizer(frogController.initPanner())
  }
  lazy var scoreText: SKLabelNode  = {
    var scoreLabel = SKLabelNode()
    scoreLabel.zPosition = 6
    scoreLabel.fontSize = 45
    //scoreLabel.fontName = "AlNile"
    scoreLabel.position = CGPoint(x: (frame.size.width / 2) - (self.size.width / 2), y: (self.frame.height / 2) - 70)
    scoreLabel.text = "0"
    return scoreLabel
  }()
  
  lazy var pauseButton: SKSpriteNode = {
    var pause = SKSpriteNode(imageNamed: "Pause")
    //pause.target(forAction: #selector(GameScene.pause), withSender: UITapGestureRecognizer())
    pause.alpha = 0.8
    pause.name = "pausebtn"
    pause.size = CGSize(width: pause.size.width, height: pause.size.height)
    pause.isUserInteractionEnabled = true
    pause.position = CGPoint(x: (frame.size.width / 2) - (pause.size.width + 10), y: (frame.size.height / 2) - (pause.size.height + 10) )
    pause.zPosition = 6
    return pause
  }()
  
  @objc func pause() {
    print("TIPPETY TAP")
    //Open pause popup in this func
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let location = touch.location(in: self)
      let nodesarray = nodes(at: location)
      
      for node in nodesarray {
        if node.name == "pausebtn" {
          print("OH YES")
        }
      }
    }
  }
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    if let touch = touches.first {
//    let location = touch.location(in: self)
//      let _node:SKNode = self.atPoint(location)
//
//    if(_node.name == "pausebtn"){
//
//     pause()
//    }
//    }
//
//  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Loop over all the touches in this event
    for touch: AnyObject in touches {
      // Get the location of the touch in this scene
      let location = touch.location(in: self)
      // Check if the location of the touch is within the button's bounds
      if pauseButton.contains(location) {
        print("HAYYYY")
        pause()
      }
    }
  }

  
  override func update(_ currentTime: CFTimeInterval) {
    frogController.updateFrogAngle()
    cam.position.y = frog.position.y
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    if(contact.bodyA.node?.name == "floor") {
      contact.bodyB.node?.removeFromParent()
    }
    if(contact.collisionImpulse > 16 && contact.contactNormal.dy < 0) {
      if(contact.bodyA.node?.name == "frog" && contact.bodyB.node?.name == "leaf") {
      frogController.setFrogAnimation(animation: 1)
      let leafBody: SKPhysicsBody = contact.bodyB
      let leaf = (leafBody.node as? Leaf)!
        if(!leaf.isVisited()) {
          addLeaf(position: generateRandomPosition(), isVisited: false)
          score += 1
          scoreText.text = "\(score)"
          leaf.setVisited()
        }
      }
    }
  }
   
  func addFloor () -> SKSpriteNode {
    let floor = SKSpriteNode(color: .init(white: 1, alpha: 0.3) , size: CGSize(width: frame.width, height: 30))
    
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
    let leftWall = SKSpriteNode(color: .clear, size: CGSize(width: 3, height: frame.height))
    
    
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
    let rightWall = SKSpriteNode(color: .clear, size: CGSize(width: 3, height: frame.height))
    
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
    let floor = SKSpriteNode(color: .clear, size: CGSize(width: frame.width, height: 3))
    
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
  
  func insertTree() {
    
    for i in 0..<4
    {
      let tree = Tree(imageNr: 1, size: frame.size)
      self.addChild(tree.addTreeSprite(imageNr: i + 1, position: CGPoint(x:self.frame.width / 2, y:CGFloat(i) * self.frame.height)))
      
    }
  }
  
  func insertStartBush() {
    let bush = SKSpriteNode(imageNamed: "grass")
    bush.size = CGSize(width: self.frame.width, height: bush.size.height)
    bush.position = CGPoint(x: self.frame.width / 2, y: 100)
    bush.zPosition = 2
    addChild(bush)
  }
  
  func generateRandomPosition() -> CGPoint {
    let xPos = CGFloat( Float(arc4random_uniform(UInt32(self.frame.width))))
    let yPos = CGFloat( Float(arc4random_uniform(UInt32(self.frame.height/4)))) + (frog.position.y + 100)
    return CGPoint(x: xPos, y: yPos)
  }

  func addLeaf(position: CGPoint, isVisited: Bool){
    let currentLeaf = Leaf(position: position, imageNamed: "leaf\(arc4random_uniform(5) + 1)", visited: isVisited)
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

