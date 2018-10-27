//
//  GameOverScene.swift
//  frumpy
//
//  Created by Martin Willman on 2018-10-17.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameOverScene: SKScene {
  let rerunButtonTexture = SKTexture(imageNamed: "rerunbutton")
  let rerunButtonPressedTexture = SKTexture(imageNamed: "rerunbuttonpressed")
  
  let buttonLeaderBoardTexture = SKTexture(imageNamed: "buttonleaderboard")
  let buttonLeaderBoardPressedTexture = SKTexture(imageNamed: "buttonleaderboardpressed")
  
  let buttonSettingTexture = SKTexture(imageNamed: "buttonsetting")
  let buttonSettingPressedTexture = SKTexture(imageNamed: "buttonsettingpressed")
  
  var rerunButton : SKSpriteNode! = nil
  var leaderBoardButton : SKSpriteNode! = nil
  var settingButton : SKSpriteNode! = nil
  
  var selectedButton : SKSpriteNode?
  let gameOverLabel = SKLabelNode(fontNamed: "Roboto")
  let gameOverScore = SKLabelNode(fontNamed: "Roboto")
  var highScoreLabel = SKLabelNode(fontNamed: "Roboto")
  var highScoreLabelText = SKLabelNode(fontNamed: "MarkerFelt-Wide")
  var highScore = UserDefaults().integer(forKey: "HIGHSCORE")
  
  
  override func sceneDidLoad() {
    let image = SKSpriteNode(imageNamed: "BackgroundImage")
    image.size = CGSize(width: frame.width, height: frame.height)
    image.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    image.zPosition = 0
    addChild(image)
    
    let path = Bundle.main.path(forResource: "Rain", ofType: "sks")
    let backgroundRain = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
    backgroundRain.position = CGPoint(x: self.size.width / 2, y: self.size.height)
    backgroundRain.zPosition = 0.5
    addChild(backgroundRain)
    
    highScoreLabelText.text = "BEST SCORE"
    highScoreLabelText.position = CGPoint(x: self.size.width/2, y: self.size.height - 70)
    highScoreLabelText.fontColor = UIColor.orange
    highScoreLabelText.zPosition = 1
    addChild(highScoreLabelText)
    
    highScoreLabel.text = "\(UserDefaults().integer(forKey: "HIGHSCORE"))"
    highScoreLabel.fontColor = UIColor.orange
    highScoreLabel.position = CGPoint(x: self.size.width/2, y: highScoreLabelText.frame.origin.y - 40)
    highScoreLabel.zPosition = 1
    addChild(highScoreLabel)
    
    rerunButton = SKSpriteNode(texture: rerunButtonTexture)
    rerunButton.size = CGSize(width: rerunButton.size.width / 3, height: rerunButton.size.height / 3)
    rerunButton.position = CGPoint(x: self.size.width/2, y: 3.0 / 6.0 * self.size.height);
    rerunButton.zPosition = 1
    addChild(rerunButton)
    
    leaderBoardButton = SKSpriteNode(texture: buttonLeaderBoardTexture)
    leaderBoardButton.size = CGSize(width: leaderBoardButton.size.width / 4, height: leaderBoardButton.size.height / 4)
    leaderBoardButton.position = CGPoint(x: self.size.width/2, y: rerunButton.frame.origin.y - 60);
    leaderBoardButton.zPosition = 1
    addChild(leaderBoardButton)
    
    settingButton = SKSpriteNode(texture: buttonSettingTexture)
    settingButton.size = CGSize(width: settingButton.size.width / 4, height: settingButton.size.height / 4)
    settingButton.position = CGPoint(x: self.size.width/2, y: leaderBoardButton.frame.origin.y - 40);
    settingButton.zPosition = 1
    addChild(settingButton)
    
    
    let defaults = UserDefaults.standard
    let score = defaults.integer(forKey: "scoreKey")
    gameOverScore.fontSize = 100
    gameOverScore.fontColor = UIColor.white
    //gameOverScore.fontColor = SKColor.white
    gameOverScore.text = "\(score)" // Score = \(UserDefaults().integer(forKey: "SCORE"))"    //String(format: "%d",GameScene.getScore(score))
    gameOverScore.position = CGPoint(x: self.size.width/2, y: 4.0 / 6.0 * self.size.height);
    gameOverScore.zPosition = 1
    self.addChild(gameOverScore)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      if selectedButton != nil {
        handleRerunButtonHover(isHovering: false)
      }
      
      // Check which button was clicked (if any)
      if rerunButton.contains(touch.location(in: self)) {
        selectedButton = rerunButton
        handleRerunButtonHover(isHovering: true)
      }else if leaderBoardButton.contains(touch.location(in: self)) {
        selectedButton = leaderBoardButton
        handleLeaderBoardButtonHover(isHovering: true)
      }else if settingButton.contains(touch.location(in: self)) {
        selectedButton = settingButton
        handleSettingButtonHover(isHovering: true)
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      // Check which button was clicked (if any)
      if selectedButton == rerunButton {
        handleRerunButtonHover(isHovering: (rerunButton.contains(touch.location(in: self))))
      }else if selectedButton == leaderBoardButton {
        handleLeaderBoardButtonHover(isHovering: (leaderBoardButton.contains(touch.location(in: self))))
      }else if selectedButton == settingButton {
        handleSettingButtonHover(isHovering: (settingButton.contains(touch.location(in: self))))
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      
      if selectedButton == rerunButton {
        // Start button clicked
        handleRerunButtonHover(isHovering: false)

        if (rerunButton.contains(touch.location(in: self))) {
          handleRerunButtonClick()
        }
      }else if selectedButton == leaderBoardButton {
        // Start button clicked
        handleLeaderBoardButtonHover(isHovering: false)
        
        if (leaderBoardButton.contains(touch.location(in: self))) {
          handleLeaderBoardButtonClick()
        }
      } else if selectedButton == settingButton {
        // Start button clicked
        handleSettingButtonHover(isHovering: false)
        
        if (settingButton.contains(touch.location(in: self))) {
          handleSettingButtonClick()
        }
      }
    }
    
    selectedButton = nil
  }
  
  /// Handles rerun button hover behavior
  func handleRerunButtonHover(isHovering : Bool) {
    if isHovering {
      rerunButton.texture = rerunButtonPressedTexture
    } else {
      rerunButton.texture = rerunButtonTexture
    }
  }
  /// Handles leaderboard button hover behavior
  func handleLeaderBoardButtonHover(isHovering : Bool) {
    if isHovering {
      leaderBoardButton.texture = buttonLeaderBoardPressedTexture
    } else {
      leaderBoardButton.texture = buttonLeaderBoardTexture
    }
  }
  /// Handles setting button hover behavior
  func handleSettingButtonHover(isHovering : Bool) {
    if isHovering {
      settingButton.texture = buttonSettingPressedTexture
    } else {
      settingButton.texture = buttonSettingTexture
    }
  }
  /// Stubbed out start button on click method
  func handleRerunButtonClick() {
    print("rerun clicked")
    
    let transition = SKTransition.fade(withDuration: 0.4)
    let gameScene = GameScene(size: size)
    gameScene.scaleMode = scaleMode
    view?.presentScene(gameScene, transition: transition)
  }
  func handleLeaderBoardButtonClick() {
    print("leaderboard clicked")
    
    let transition = SKTransition.fade(withDuration: 0.4)
    let leaderBoardScene = LeaderboardScene(size: size)
    leaderBoardScene.scaleMode = scaleMode
    view?.presentScene(leaderBoardScene, transition: transition)
  }
  func handleSettingButtonClick() {
    print("setting clicked")
    
    let transition = SKTransition.fade(withDuration: 0.4)
    let settingScene = SettingsScene(size: size)
    settingScene.scaleMode = scaleMode
    view?.presentScene(settingScene, transition: transition)
  }
}
































/*class GameOverScene: SKScene {
 
 // Private GameScene Properties
 var contentCreated = false
 var selectedButton : SKSpriteNode?
 // black space color
 // Object Lifecycle Management
 
 // Scene Setup and Content Creation
 
 override func didMove(to view: SKView) {
 
 let gameOverLabel = SKLabelNode(fontNamed: "Courier")
 gameOverLabel.fontSize = 50
 gameOverLabel.fontColor = SKColor.white
 gameOverLabel.text = "Game Over!"
 gameOverLabel.position = CGPoint(x: self.size.width/2, y: 2.0 / 3.0 * self.size.height);
 
 addChild(gameOverLabel)
 
 let gameOverScore = SKLabelNode(fontNamed: "Courier")
 gameOverScore.fontSize = 50
 gameOverScore.fontColor = SKColor.white
 gameOverScore.text = "HALLIHALLÅ"//String(format: "%d", GameState.sharedInstance.score)
 gameOverLabel.position = CGPoint(x: self.size.width/2, y: 2.0 / 3.0 * self.size.height);
 self.addChild(gameOverScore)
 
 // let tapLabel = SKLabelNode(fontNamed: "Courier")
 let rerunButtonTexture = SKTexture(imageNamed: "rerun")
 let rerunButton = SKSpriteNode(texture: rerunButtonTexture)
 let rerunButtonPressedTexture = SKTexture(imageNamed: "rerunpressed")
 let rerunButtonPressed = SKSpriteNode(texture: rerunButtonPressedTexture)
 rerunButton.size = CGSize(width: rerunButton.size.width / 2, height: rerunButton.size.height / 2)
 //tapLabel.fontColor = SKColor.white
 //tapLabel.text = "(Tap to Play Again)"
 rerunButton.position = CGPoint(x: self.size.width/2, y: gameOverLabel.frame.origin.y - gameOverLabel.frame.size.height - 40);
 
 addChild(rerunButton)
 
 backgroundColor = SKColor.black
 if (!self.contentCreated) {
 self.createContent()
 self.contentCreated = true
 }
 }
 
 func createContent() {
 
 let gameOverLabel = SKLabelNode(fontNamed: "Courier")
 gameOverLabel.fontSize = 50
 gameOverLabel.fontColor = SKColor.white
 gameOverLabel.text = "Game Over!"
 gameOverLabel.position = CGPoint(x: self.size.width/2, y: 2.0 / 3.0 * self.size.height);
 
 self.addChild(gameOverLabel)
 
 let gameOverScore = SKLabelNode(fontNamed: "Courier")
 gameOverScore.fontSize = 50
 gameOverScore.fontColor = SKColor.white
 gameOverScore.text = "HALLIHALLÅ"//String(format: "%d", GameState.sharedInstance.score)
 gameOverLabel.position = CGPoint(x: self.size.width/2, y: 2.0 / 3.0 * self.size.height);
 self.addChild(gameOverScore)
 
 // let tapLabel = SKLabelNode(fontNamed: "Courier")
 let rerunButtonTexture = SKTexture(imageNamed: "rerun")
 let rerunButton = SKSpriteNode(texture: rerunButtonTexture)
 let rerunButtonPressedTexture = SKTexture(imageNamed: "rerunPressed")
 let rerunButtonPressed = SKSpriteNode(texture: rerunButtonPressedTexture)
 rerunButton.size = CGSize(width: rerunButton.size.width / 2, height: rerunButton.size.height / 2)
 //tapLabel.fontColor = SKColor.white
 //tapLabel.text = "(Tap to Play Again)"
 rerunButton.position = CGPoint(x: self.size.width/2, y: gameOverLabel.frame.origin.y - gameOverLabel.frame.size.height - 40);
 
 self.addChild(rerunButton)
 
 // black space color
 self.backgroundColor = SKColor.black
 
 
 
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 if let touch = touches.first {
 if selectedButton != nil {
 handleRerunButtonHover(isHovering: false)
 //handleSoundButtonHover(isHovering: false)
 }
 // Check which button was clicked (if any)
 if rerunButton.contains(touch.location(in: self)) {
 rerunButton = rerunButton
 handleRerunButtonHover(isHovering: true)
 
 }
 
 }
 }
 /// Handles start button hover behavior
 func handleRerunButtonHover(isHovering : Bool) {
 if isHovering {
 rerunButton.texture = rerunButtonPressed
 } else {
 rerunButton.texture = rerunButton
 }
 }
 
 override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)  {
 
 }
 
 override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
 
 }
 
 override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
 
 let gameScene = GameScene(size: self.size)
 gameScene.scaleMode = .aspectFill
 
 self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
 
 }
 }
 
 /*override func touchesBegan(_ touches: Set, with event: UIEvent?) {
 if let touch = touches.first {
 if selectedButton != nil {
 handleStartButtonHover(isHovering: false)
 handleSoundButtonHover(isHovering: false)
 }
 
 // Check which button was clicked (if any)
 if startButton.contains(touch.location(in: self)) {
 selectedButton = startButton
 handleStartButtonHover(isHovering: true)
 } else if soundButton.contains(touch.location(in: self)) {
 selectedButton = soundButton
 handleSoundButtonHover(isHovering: true)
 }
 }
 }
 
 override func touchesMoved(_ touches: Set, with event: UIEvent?) {
 if let touch = touches.first {
 
 // Check which button was clicked (if any)
 if selectedButton == startButton {
 handleStartButtonHover(isHovering: (startButton.contains(touch.location(in: self))))
 } else if selectedButton == soundButton {
 handleSoundButtonHover(isHovering: (soundButton.contains(touch.location(in: self))))
 }
 }
 }
 
 override func touchesEnded(_ touches: Set, with event: UIEvent?) {
 if let touch = touches.first {
 
 if selectedButton == startButton {
 // Start button clicked
 handleStartButtonHover(isHovering: false)
 
 if (startButton.contains(touch.location(in: self))) {
 handleStartButtonClick()
 }
 
 } else if selectedButton == soundButton {
 // Sound button clicked
 handleSoundButtonHover(isHovering: false)
 
 if (soundButton.contains(touch.location(in: self))) {
 handleSoundButtonClick()
 }
 }
 }
 
 selectedButton = nil
 }
 
 /// Handles start button hover behavior
 func handleStartButtonHover(isHovering : Bool) {
 if isHovering {
 startButton.texture = startButtonPressedTexture
 } else {
 startButton.texture = startButtonTexture
 }
 }
 
 /// Handles sound button hover behavior
 func handleSoundButtonHover(isHovering : Bool) {
 if isHovering {
 soundButton.alpha = 0.5
 } else {
 soundButton.alpha = 1.0
 }
 }
 
 /// Stubbed out start button on click method
 func handleStartButtonClick() {
 print("start clicked")
 }
 
 /// Stubbed out sound button on click method
 func handleSoundButtonClick() {
 print("sound clicked")
 }
 */*/
