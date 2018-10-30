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
  
  var navigation = Navigation()
  let leafController = LeafController()
  var waterController = WaterController()
  var frogController = FrogController()
  var musicController = MusicController()
  var rainController = MusicController()
  var gameMusicController = MusicController()
  
  let kLeafCategory: UInt32 = 0x1 << 0
  let nrOfAimDots = 8
  let cam = SKCameraNode()
  var frog: SKSpriteNode = SKSpriteNode()
  var drag: SKSpriteNode = SKSpriteNode()
  var logo: SKSpriteNode = SKSpriteNode()
  
  let minSwipe: CGFloat = 50
  let maxSwipe: CGFloat = 170
  
  var optionsAreHidden: Bool = false
  var toManyTouches: Bool = false
  
  var treeCounter: Int = 2;
  var treePositionHeight: Int = 1;
  
  var swipeStartPoint: CGPoint = CGPoint()
  
  var spritesAdded: [SKSpriteNode] = [SKSpriteNode]()
  var scoreLabel: SKLabelNode?
  
  private var waterLayers: [WaterLayer] = [WaterLayer]()
  
  let defaults = UserDefaults.standard
  var score: Int = 0
  var highScore: Int = 0
  
  override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    rainController.playRainSounds()
    musicController.playBackgroundMusic()
    self.physicsBody?.density = 0
    self.view!.showsFPS = true
    self.view!.showsNodeCount = true
    self.view!.isMultipleTouchEnabled = false
    self.camera = cam
    
    navigation = Navigation(size: self.frame.size)
    navigation.renderStartOptions()
    cam.addChild(navigation)
    
    createStartOptions()
    frogController = FrogController(size: frame.size)
    addFrog()
    
    waterController = WaterController(frogZPosition: frog.zPosition, frameSize: frame.size)
    addCamera()
    addWalls()
    addFloor()
    addFirstTrees()
    addBush()
    addWater()
    addAimDots()
    addStartLeaves()
    cam.addChild(scoreText)
    createParticles()
  }
  
  override func update(_ currentTime: CFTimeInterval) {
    frogController.updateFrogAngle()
    cam.position.y = frog.position.y + 75
    
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
    backgroundCloud1.name = "particle"
    backgroundCloud1.targetNode = self.scene
    backgroundCloud1.particleZPosition = 1
    
    backgroundCloud2.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundCloud2.name = "particle"
    backgroundCloud2.targetNode = self.scene
    backgroundCloud2.particleZPosition = 2
    
    backgroundLeaf1.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundLeaf1.name = "particle"
    backgroundLeaf1.targetNode = self.scene
    backgroundLeaf1.particleZPosition = 3
    
    backgroundLeaf2.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundLeaf2.name = "particle"
    backgroundLeaf2.targetNode = self.scene
    backgroundLeaf2.particleZPosition = 2
    
    backgroundLeaf3.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundLeaf3.name = "particle"
    backgroundLeaf3.targetNode = self.scene
    backgroundLeaf3.particleZPosition = 0
    
    backgroundRain.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundRain.name = "particle"
    backgroundRain.targetNode = self.scene
    backgroundRain.particleZPosition = 1
    
    foregroundRain.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    foregroundRain.name = "particle"
    foregroundRain.targetNode = self.scene
    foregroundRain.particleZPosition = 5
    defaults.set(0, forKey: "scoreKey")
    
    
    //cam.addChild(backgroundCloud1)
    //cam.addChild(backgroundCloud2)
    cam.addChild(backgroundRain)
    cam.addChild(foregroundRain)
    cam.addChild(backgroundLeaf1)
    cam.addChild(backgroundLeaf2)
    cam.addChild(backgroundLeaf3)
  }
  
  lazy var scoreText: SKLabelNode  = {
    var scoreLabel = SKLabelNode()
    scoreLabel.zPosition = 6
    scoreLabel.fontSize = 45
    scoreLabel.position = CGPoint(x: (frame.size.width / 2) - (self.size.width / 2), y: (self.frame.height / 2) - 70)
    scoreLabel.text = "0"
    return scoreLabel
  }()

  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (touches.count < 2 && frogController.jumpIsEnabled()) {
      musicController.stopBackgroundMusic()
      for touch in touches {
        swipeStartPoint = touch.location(in: self.view)
        frogController.setFrogAnimation(animation: 2)
        if (!optionsAreHidden) {
          gameMusicController.playGameMusic()
          hideStartOptions()
        }
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (touches.count < 2 && frogController.jumpIsEnabled()) {
      for touch in touches {
        let currentPoint = touch.location(in: self.view)
        let swipeLength = Utilities.betweenPointDistance(point1: currentPoint, point2: swipeStartPoint)
        if (swipeLength > minSwipe) {
          let swipeAngle  = Utilities.betweenPointAngle(point1: currentPoint, point2: swipeStartPoint)
          let swipeVector = Utilities.betweenPointVector(distance: swipeLength, maxDistance: maxSwipe, point2: currentPoint, point1: swipeStartPoint)
          frogController.showAimDots()
          frogController.checkAngle(angle: swipeAngle)
          frogController.moveAimDots(vector: swipeVector, swipeLength: swipeLength)
        }
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (touches.count < 2 && frogController.jumpIsEnabled()) {
      for touch in touches {
        let currentPoint = touch.location(in: self.view)
        let swipeLength = Utilities.betweenPointDistance(point1: currentPoint, point2: swipeStartPoint)
        frogController.hideAimDots()
        if (swipeLength > minSwipe) {
          let swipeVector = Utilities.betweenPointVector(distance: swipeLength, maxDistance: maxSwipe, point2: currentPoint, point1: swipeStartPoint)
          frogController.setFrogAnimation(animation: 3)
          frogController.makeJump(vector: swipeVector)
          frogController.disableJump()
        } else {
          frogController.setFrogAnimation(animation: 1)
        }
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
      if((contact.bodyB.node?.position.y)! - waterLayers.first!.position.y > 400) {
         waterController.setPosition(waterLayers: waterLayers, camera: cam)
      }
      frog.physicsBody?.velocity = CGVector(dx: 0, dy: 0)

      if(contact.collisionImpulse > 5 && contact.contactNormal.dy < 0) {
        frog.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        frogController.setFrogAnimation(animation: 1)
        let leafBody: SKPhysicsBody = contact.bodyB
        let leaf = (leafBody.node as? Leaf)!
        if(!leaf.isVisited()) {
          addLeaf(position: generateRandomPosition(leafPosition: leaf.position), isVisited: false)
          leaf.setVisited( )
          score += 1
          defaults.set(score, forKey: "scoreKey")
          defaults.synchronize()
          scoreText.text = "\(score)"
          if score > UserDefaults().integer(forKey: "HIGHSCORE") {
            saveHighScore()
          }
          if(score % 5 == 0) {
            waterController.increseWaterFillSpeed(waterLayers: waterLayers)
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
        }
        if(frog.position.y - frame.height * 2 > sprite.position.y){
          sprite.removeFromParent()
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
    addLeaf(position: CGPoint(x: 70, y: 100), isVisited: true)
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
  func saveHighScore() {
    UserDefaults.standard.set(score, forKey: "HIGHSCORE")
  }
  
  /*func setHighscore() -> Int{
    if(score > highScore){
      highScore = score
    }
    return highScore
  }*/
  
  func isGameOver(){
    //let reveal = SKTransition.fade(withDuration: 0.5)
    let gameOverScene = GameOverScene(size: self.size)
    view?.presentScene(gameOverScene, transition: SKTransition.fade(withDuration: 0.5))
    //self.view!.presentScene(endGameScene, transition: reveal)
  }
  
  func createStartOptions() {
    createDragTutorial()
    createLogo()
  }
  
  func hideStartOptions() {
    optionsAreHidden = true
    let fade = SKAction.fadeAlpha(to: 0, duration: 0.4)
    let remove = SKAction.removeFromParent()
    drag.run(SKAction.sequence([fade, remove]))
    logo.run(SKAction.sequence([fade, remove]))
    navigation.removeStartOptions()
    navigation.renderInGameOptions()
  }
  
  func createDragTutorial() {
    let dragAnimationAtlas = SKTextureAtlas(named: "drag_tutorial")
    var frames: [SKTexture] = []
    let numImages = dragAnimationAtlas.textureNames.count
    for i in 0...(numImages - 1){
      let dragTextureName = "drag_\(i)"
      frames.append(dragAnimationAtlas.textureNamed(dragTextureName))
    }
    let firstFrameTexture = frames[0]
    drag = SKSpriteNode(texture: firstFrameTexture)
    drag.position = CGPoint(x: 60, y: -10)
    drag.alpha = 0.7
    drag.size = CGSize(width: firstFrameTexture.size().width/1.6, height: firstFrameTexture.size().height/1.6)
    drag.zPosition = 10
    let action = SKAction.animate(with: frames, timePerFrame: 0.015, resize: false, restore: true)
    drag.run(SKAction.repeatForever(action))
    addChild(drag)
    
  }
  
  func createLogo() {
    let logoAtlas = SKTextureAtlas(named: "frumpylogo")
    var frames: [SKTexture] = []
    let numImages = logoAtlas.textureNames.count
    for i in 0...(numImages - 1){
      let dragTextureName = "frumpylogo_\(i)"
      frames.append(logoAtlas.textureNamed(dragTextureName))
    }
    let firstFrameTexture = frames[0]
    logo = SKSpriteNode(texture: firstFrameTexture)
    logo.position = CGPoint(x: self.size.width/2, y: 400)
    logo.size = CGSize(width: firstFrameTexture.size().width/2.2, height: firstFrameTexture.size().height/1.7)
    logo.zPosition = 10
    let action = SKAction.animate(with: frames, timePerFrame: 0.02, resize: false, restore: true)
    logo.run(SKAction.repeatForever(action))
    addChild(logo)
  }
  
}

