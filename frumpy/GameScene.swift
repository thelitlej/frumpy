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
  var waterController = WaterController()
  var frogController = FrogController()
  
  let kLeafCategory: UInt32 = 0x1 << 0
  let nrOfAimDots = 8
  let cam = SKCameraNode()
  var frog: SKSpriteNode = SKSpriteNode()
  
  let image = SKSpriteNode()
  
  var treeCounter = 2;
  var treePositionHeight = 1;

  var startX: CGFloat = 0;
  var startY: CGFloat = 0;
  var landingSucsess = false;
  var frogPosition = CGPoint()
  var spritesAdded = [SKSpriteNode]()
  var scoreLabel: SKLabelNode?
  private var waves = SKSpriteNode()
  private var waveFrames: [SKTexture] = []
  
  private var waterLayers: [WaterLayer] = [WaterLayer]()
  private var spareWater: SKShapeNode = SKShapeNode()
  
  private var windActionForLeaf:SKAction = SKAction()
  private var thisLeaf: SKSpriteNode = SKSpriteNode()

  var score:Int = 0
  var highScore:Int = 0
  
  override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.physicsBody?.density = 0
    self.view!.showsFPS = true
    self.camera = cam
    self.view!.showsNodeCount = true
    frogController = FrogController(size: frame.size)
    addFrog()
    
    waterController = WaterController(frogZPosition: frog.zPosition)
    addCamera()
    addWalls()
    addFloor()
    addFirstTrees()
    addBush()
    addWater()
    addAimDots()
    addStartLeaves()
    pauseButton.name = "pausebtn"
    cam.addChild(pauseButton)
    cam.addChild(scoreText)
    createParticles()
    view.addGestureRecognizer(frogController.initPanner())
  }
  
  override func update(_ currentTime: CFTimeInterval) {
    frogController.updateFrogAngle()
    cam.position.y = frog.position.y
    
  }
  
  func createParticles() {
    let path = Bundle.main.path(forResource: "Rain", ofType: "sks")
    let path2 = Bundle.main.path(forResource: "ForegroundRain", ofType: "sks")
    let cloudPath = Bundle.main.path(forResource: "BackgroundCloud1", ofType: "sks")
    let cloudPath2 = Bundle.main.path(forResource: "BackgroundCloud2", ofType: "sks")
    let leafPath = Bundle.main.path(forResource: "BackgroundLeaf", ofType: "sks")
    let leafPath2 = Bundle.main.path(forResource: "BackgroundLeaf2", ofType: "sks")
    let leafPath3 = Bundle.main.path(forResource: "BackgroundLeaf3", ofType: "sks")
    let backgroundRain = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
    let foregroundRain = NSKeyedUnarchiver.unarchiveObject(withFile: path2!) as! SKEmitterNode
    let backgroundLeaf1 = NSKeyedUnarchiver.unarchiveObject(withFile: leafPath!) as! SKEmitterNode
    let backgroundLeaf2 = NSKeyedUnarchiver.unarchiveObject(withFile: leafPath2!) as! SKEmitterNode
    let backgroundLeaf3 = NSKeyedUnarchiver.unarchiveObject(withFile: leafPath3!) as! SKEmitterNode
    let backgroundCloud1 = NSKeyedUnarchiver.unarchiveObject(withFile: cloudPath!) as! SKEmitterNode
    let backgroundCloud2 = NSKeyedUnarchiver.unarchiveObject(withFile: cloudPath2!) as! SKEmitterNode
    
    
    backgroundCloud1.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundCloud1.name = "backgroundCloud1"
    backgroundCloud1.targetNode = self.scene
    backgroundCloud1.particleZPosition = 1
    
    backgroundCloud2.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundCloud2.name = "backgroundCloud2"
    backgroundCloud2.targetNode = self.scene
    backgroundCloud2.particleZPosition = 2
    
    backgroundLeaf1.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundLeaf1.name = "backgroundLeaf1"
    backgroundLeaf1.targetNode = self.scene
    backgroundLeaf1.particleZPosition = 3
    
    backgroundLeaf2.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundLeaf2.name = "backgroundLeaf2"
    backgroundLeaf2.targetNode = self.scene
    backgroundLeaf2.particleZPosition = 2
    
    backgroundLeaf3.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundLeaf3.name = "backgroundLeaf3"
    backgroundLeaf3.targetNode = self.scene
    backgroundLeaf3.particleZPosition = 0
    
    backgroundRain.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundRain.name = "backgroundRain"
    backgroundRain.targetNode = self.scene
    backgroundRain.particleZPosition = 1
    
    foregroundRain.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    foregroundRain.name = "foregroundRain"
    foregroundRain.targetNode = self.scene
    foregroundRain.particleZPosition = 5
    
    cam.addChild(backgroundCloud1)
    cam.addChild(backgroundCloud2)
    cam.addChild(backgroundRain)
    cam.addChild(foregroundRain)
    cam.addChild(backgroundLeaf1)
    cam.addChild(backgroundLeaf2)
    cam.addChild(backgroundLeaf3)
  }
  
  func createWindForLeaves() {
    let action1 = SKAction.moveBy(x: 100, y: -20, duration: 1)
    let action2 = SKAction.moveBy(x: -100, y: 10, duration: 1)
    let action3 = SKAction.sequence([action1, action2])
    windActionForLeaf = SKAction.repeatForever(action3)
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
          print("touched pause button")
        }
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Loop over all the touches in this event
    for touch: AnyObject in touches {
      // Get the location of the touch in this scene
      let location = touch.location(in: self)
      // Check if the location of the touch is within the button's bounds
      if pauseButton.contains(location) {
        print("worked")
        pause()
      }
    }
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    if(contact.bodyA.node?.name == "floor") {
      contact.bodyB.node?.removeFromParent()
      treeCounter = treeCounter + 1;
      treePositionHeight = treePositionHeight + 1;
      addTree()
    }
    if(contact.bodyA.node?.name == "frog" && contact.bodyB.node?.name == "leaf") {
      frog.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
      if(contact.collisionImpulse > 5 && contact.contactNormal.dy < 0) {
      frogController.setFrogAnimation(animation: 1)
      let leafBody: SKPhysicsBody = contact.bodyB
      let leaf = (leafBody.node as? Leaf)!
        if(!leaf.isVisited()) {
          addLeaf(position: generateRandomPosition(leafPosition: leaf.position), isVisited: false)
          score += 1
          scoreText.text = "\(score)"
          leaf.setVisited( )
          if(score % 5 == 0) {
            waterController.increseWaterFillSpeed(spareWater: spareWater, waterLayers: waterLayers)
          }
        }
      }
    }
    if(contact.bodyA.node?.name == "frog" && contact.bodyB.node?.name == "water") {
      if(!waterController.frogDidFallIn()) {
        //Implement game over, pause game and implement start over- and watch add button
        waterController.frogFellInWater(did: true)
        isGameOver()
        //setHighscore()
        frog.removeFromParent() //add new frog on the leaf it just fell from if add is watched
      }
    }
  }
   
  func addFloor () {
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
    cam.addChild(floor)
  }
  
  func addWalls () {
    let leftWall = SKSpriteNode(color: .clear, size: CGSize(width: 3, height: frame.height))
    leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
    leftWall.physicsBody?.isDynamic = false
    leftWall.physicsBody?.restitution = 0.8
    leftWall.physicsBody?.friction = 0
    leftWall.physicsBody?.linearDamping = 0
    leftWall.physicsBody?.angularDamping = 0
    leftWall.physicsBody?.collisionBitMask = 10;
    leftWall.position = CGPoint(x: -frame.width/2, y: frame.height-frame.height)
    leftWall.name = "leftWall"
    cam.addChild(leftWall)
    
    let rightWall = SKSpriteNode(color: .clear, size: CGSize(width: 3, height: frame.height))
    rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
    rightWall.physicsBody?.isDynamic = false
    rightWall.physicsBody?.collisionBitMask = 10;
    rightWall.physicsBody?.friction = 0
    rightWall.physicsBody?.linearDamping = 0
    rightWall.physicsBody?.angularDamping = 0
    rightWall.physicsBody?.restitution = 0.8
    rightWall.position = CGPoint(x: frame.width/2, y: frame.height-frame.height)
    rightWall.name = "rightWall"
    cam.addChild(rightWall)
  }

  func addCamera() {
    cam.position.x = size.width / 2
    cam.position.y = size.height
    addChild(cam)
  }
  
  func addFirstTrees() {
    for i in 0..<2
    {
      let image = SKSpriteNode(imageNamed: "BackgroundImage")
      image.size = CGSize(width: frame.width, height: frame.height)
      image.position = CGPoint(x: self.size.width / 2, y: CGFloat(i) * self.size.height)
      if(i == 0) {
        image.zRotation = .pi
        image.xScale = image.xScale * -1
      }
    let tree = Tree(imageNr: 1, size: frame.size)
    addChild(image)
    addChild(tree.addTreeSprite(imageNr: i + 1, position: CGPoint(x:self.frame.width / 2, y:CGFloat(i) * self.frame.height)))
    }
  }
  
  func addTree() {
    let image = SKSpriteNode(imageNamed: "BackgroundImage")
    image.size = CGSize(width: frame.width, height: frame.height)
    image.position = CGPoint(x: self.size.width / 2, y: CGFloat(treePositionHeight) * self.size.height)
    
    let tree = Tree(imageNr: 1, size: frame.size)
    
    if(treeCounter == 5) {
      treeCounter = 1;
      
    }
    if(treeCounter % 2 == 1) {
      image.zRotation = .pi
      image.xScale = image.xScale * -1
    }
      addChild(image)
      addChild(tree.addTreeSprite(imageNr: treeCounter, position: CGPoint(x:self.frame.width / 2, y:CGFloat(treePositionHeight) * self.frame.height)))
    
    let sprites = self.spritesAdded
    for sprite in sprites {
      if(sprite.name == "tree"){
        if(frog.position.y - frame.height * 2 > sprite.position.y){
         // addChild(tree.addTreeSprite(imageNr: treeCounter, position: CGPoint(x:self.frame.width / 2, y:CGFloat(treePositionHeight) * self.frame.height)))
          print ("hej")
        }
        if(frog.position.y - frame.height * 2 > sprite.position.y){
          sprite.removeFromParent()
          print ("då")
        }
      }
    }
  }
  
  func addBush() {
    let bush = SKSpriteNode(imageNamed: "grass")
    bush.size = CGSize(width: frame.width, height: bush.size.height)
    bush.position = CGPoint(x: frame.width / 2, y: 100)
    bush.zPosition = 2
    addChild(bush)
  }
  
  func addWater() {
    waterLayers = waterController.buildWater(size: frame.size)
    for waterLayer in waterLayers {
      addChild(waterLayer)
    }
    spareWater = waterController.buildSpareWater(color: UIColorFromRGB(rgbValue: 0x64BDF4))
    addChild(spareWater)
  }
  
  func addAimDots() {
    let dots = frogController.createAimDots(nrOfDots: nrOfAimDots)
    for dot in dots {
      addChild(dot)
    }
  }
  
  func addFrog() {
    frog = frogController.addFrog()
    frog.name = "frog"
    addChild(frog)
  }
  
  func addStartLeaves() {
    addLeaf(position: CGPoint(x: 100, y: 100), isVisited: true)
    addLeaf(position: CGPoint(x: 300, y: 300), isVisited: false)
  }
  

  func generateRandomPosition(leafPosition: CGPoint) -> CGPoint {

    let yPos = CGFloat( Float(arc4random_uniform(UInt32(self.frame.height / 4)))) + (frog.position.y + 100)
    var xPos = CGFloat()
    
    if (leafPosition.x < (self.frame.width / 2)) {
      xPos = CGFloat( Float(arc4random_uniform(UInt32(self.frame.width / 4)))) + ((self.frame.width / 2) + ((self.frame.width / 4) / 2))
    } else {
      xPos = CGFloat( Float(arc4random_uniform(UInt32(self.frame.width / 4)))) + ((self.frame.width / 4) / 2)
    }
    
    return CGPoint(x: xPos, y: yPos)
  }


  func addLeaf(position: CGPoint, isVisited: Bool){
    let currentLeaf = Leaf(position: position, imageNamed: "leaf\(arc4random_uniform(5) + 1)", visited: isVisited)
    
    if (position.x < (self.frame.width) / 2) {
      currentLeaf.xScale = -1.0;
    }
    
    addChild(currentLeaf)

  }
  
  func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  func setHighscore() -> Int{
    if(score > highScore){
      highScore = score
    }
    return highScore
    //print(highScore)
  }
  func isGameOver(){
    let reveal = SKTransition.fade(withDuration: 0.5)
    let endGameScene = GameScene(size: self.size)
    self.view!.presentScene(endGameScene, transition: reveal)

  }

// ----------- FOLLOW THIS FOR ANIMATIONS -----------
//  func buildWaves() {
//    let waveAnimationAtlas = SKTextureAtlas(named: "water")
//    var frames: [SKTexture] = []
//
//    let numImages = waveAnimationAtlas.textureNames.count
//    for i in 0...(numImages-1) {
//      let waveTextureName = "water_\(i)"
//      frames.append(waveAnimationAtlas.textureNamed(waveTextureName))
//    }
//    waveFrames = frames
//    let firstFrameTexture = waveFrames[0]
//    waves = SKSpriteNode(texture: firstFrameTexture)
//    waves.position = CGPoint(x: frame.midX, y: frame.midY)
//    waves.size.width = frame.width
//    waves.size.height = frame.height/4
//    waves.position = CGPoint(x: frame.width/2, y: -10)
//    waves.zPosition = 7
//    addChild(waves)
//
//    let underWater = SKShapeNode(rectOf: CGSize(width: frame.size.width, height: frame.size.height/4))
//    underWater.fillColor = UIColorFromRGB(rgbValue: 0x5097FF)
//    underWater.strokeColor = UIColor.clear
//    underWater.position = CGPoint(x: frame.width/2, y: -120)
//    underWater.zPosition = 7
//
//    addChild(underWater)
//  }
//
//  func animateWaves() {
//    waves.run(SKAction.repeatForever(
//      SKAction.animate(with: waveFrames, timePerFrame: 0.02, resize: false, restore: true)), withKey:"waves")
//  }
//
  
  
}

