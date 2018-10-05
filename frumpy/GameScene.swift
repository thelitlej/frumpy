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
  let g: CGFloat = 9.82
  let sheet = AnimatedFrog()
  var frog: SKSpriteNode = SKSpriteNode()
  let startLeaf = SKSpriteNode(imageNamed: "leaf")
  let nextLeaf = SKSpriteNode(imageNamed: "leaf")
  let nrOfAimDots = 7
  let leafController = LeafController()
  var dots: [SKShapeNode] = []
  var startX: CGFloat = 0;
  var startY: CGFloat = 0;
  let cam = SKCameraNode()

  override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    let panner = UIPanGestureRecognizer(target: self, action: #selector(GameScene.swipe(sender:)))
    view.addGestureRecognizer(panner)
    frog = SKSpriteNode(texture: sheet.breathe_frog_00000());
    
    addFrog()
    backgroundColor = .lightGray
    setupStartLeaf()
    nextRandomLeaf()
    addCamera()
    createAimDots(nrOfDots: nrOfAimDots)
    addChild(leafController.addFirstLeaf())
    addChild(leafController.addLeaf())
    createWall(left: true)
    createWall(left: false)
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
      flipFrog(direction: 1)
    }
    else if firstNode.name == "frog" && secondNode.name == "rightWall" {
      flipFrog(direction: -1)
    }
  }
  
  @objc func createAimDots(nrOfDots: Int) {
    var size: CGFloat = 4;
    for _ in 0...nrOfDots {
      let dot = SKShapeNode(circleOfRadius: size)
      dot.position = CGPoint(x: -100, y: -100)
      dot.fillColor = UIColor.white
      dot.isHidden = true
      dot.alpha = 0.5
      self.addChild(dot)
      dots.append(dot)
      
      size -= 0.15
    }
  }
 
  @objc func showDots() {
    for dot in dots {
      dot.isHidden = false
    }
  }
  @objc func setupStartLeaf() {
    startLeaf.size = CGSize(width: (startLeaf.size.width/4), height: (startLeaf.size.height/4))
    startLeaf.position = CGPoint(x: 100, y: 200)
    startLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: startLeaf.size.width/1.5,
                                                             height: startLeaf.size.height/12))
    startLeaf.physicsBody!.isDynamic = false
    startLeaf.physicsBody!.categoryBitMask = 10
    startLeaf.physicsBody!.contactTestBitMask = 10
    startLeaf.physicsBody!.collisionBitMask = 10
    insertChild(startLeaf, at: 0)
    //addChild(startLeaf)
  }
  @objc func leafStandingPoint(){
    startLeaf.size = CGSize(width: (startLeaf.size.width/4), height: (startLeaf.size.height/4))
  }
  @objc func nextRandomLeaf() {
    nextLeaf.size = CGSize(width: (nextLeaf.size.width/4), height: (nextLeaf.size.height/4))
    nextLeaf.position = CGPoint(x: 300, y: 570)
    nextLeaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: nextLeaf.size.width/1.5,
                                                             height: nextLeaf.size.height/12))
    nextLeaf.physicsBody!.isDynamic = false
    nextLeaf.physicsBody!.categoryBitMask = 10
    nextLeaf.physicsBody!.contactTestBitMask = 10
    nextLeaf.physicsBody!.collisionBitMask = 10
    insertChild(nextLeaf, at: 0)
  }
  
  @objc func hideDots() {
    for dot in dots {
      dot.isHidden = true
    }
  }
  
  func flipFrog(direction: CGFloat) {
    frog.xScale = direction
  }
  
  @objc func checkFlip(angle: CGFloat) {
    if(angle > CGFloat.pi/2 || angle < -CGFloat.pi/2) {
      flipFrog(direction: 1)
    } else {
      flipFrog(direction: -1)
    }
  }
  
  @objc func frogJump(angle: CGFloat, distance: CGFloat) {
    let velocity = CGVector(dx: -cos(angle)*(distance), dy: sin(angle)*(distance))
    frog.physicsBody?.applyImpulse(velocity)
    frog.physicsBody?.affectedByGravity = true
    let action = SKAction.rotate(byAngle: 1, duration: 1)
    frog.run(action)
  }
  
  @objc func moveDots(sender: UIPanGestureRecognizer, distance: CGFloat) {
    let currentX = sender.location(in: view).x
    let currentY = sender.location(in: view).y
    let c = -cos(acos((currentX - startX)/distance))
    let s = sin(asin((currentY - startY)/distance))
    var i: CGFloat = 1
    for dot in dots {
      let x = distance/2 * i * c
      let y1 = distance/2 * i * s
      let y = y1 - 0.5 * g * pow(i, 2)
      i += 1
      dot.position = CGPoint(x: x + frog.position.x, y: y + frog.position.y)
    }
  }
  
  @objc func swipe(sender: UIPanGestureRecognizer) {
    let angle = calculateAngle(sender: sender)
    let distance = calculateDistance(sender: sender)
    if(sender.state.rawValue == 1) {
      startX = sender.location(in: view).x
      startY = sender.location(in: view).y
      showDots()
    } else if (sender.state.rawValue == 3) {
      hideDots()
      frogJump(angle: angle, distance: distance)
      
    } else {
      checkFlip(angle: angle)
      moveDots(sender: sender, distance: distance)
    }
  }
 
  @objc func calculateDistance(sender: UIPanGestureRecognizer) -> CGFloat {
    let x = sender.location(in: view).x
    let y = sender.location(in: view).y
    var distance = sqrt(pow((x - startX) , 2) + pow((y - startY), 2))
    if(distance > 200) {
      distance = 200;
    }
    return distance
  }
  
  @objc func calculateAngle(sender: UIPanGestureRecognizer) -> CGFloat {
    return atan2((sender.location(in: view).y - startY), (sender.location(in: view).x - startX))
  }
  
  @objc func calculateFrogHeading(swipeAngle: CGFloat) -> CGFloat {
    if(swipeAngle < 0) { return swipeAngle + CGFloat.pi }
    return swipeAngle - CGFloat.pi
  }
  
  @objc func addFrog() {
    let breathe = SKAction.animate(with: sheet.breathe_frog_(), timePerFrame: 0.033)
    let breatheAnim = SKAction.repeat(breathe, count: 6)
    frog.name = "frog"
    frog.physicsBody = SKPhysicsBody(texture: sheet.breathe_frog_00000(), size: CGSize(width: (frog.size.width/3.5), height: (frog.size.height/3.5)))
    frog.size = CGSize(width: (frog.size.width/3.5), height: (frog.size.height/3.5))
    frog.position = CGPoint(x: 200, y: 200)
    frog.physicsBody?.mass = 0.155
    frog.physicsBody?.allowsRotation = true
    frog.physicsBody?.collisionBitMask = 10;
    frog.physicsBody?.contactTestBitMask = 10;

    addChild(frog)
    let sequence = SKAction.repeatForever(
      SKAction.sequence([breatheAnim])
    );
    frog.run(sequence)

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
