//
//  MusicController.swift
//  frumpy
//
//  Created by Viktor Åhliund on 2018-10-19.
//  Copyright © 2018 Jonas Gustafson. All rights reserved.
//

import Foundation
import AVFoundation

import AVFoundation

class MusicController {
  var audioPlayer: AVAudioPlayer?
  var rainPlayer: AVAudioPlayer?
  var gameMusic: AVAudioPlayer?
  
  func playBackgroundMusic() {
    let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "frumpyintro", ofType: "mp3")!)
    do {
      //audioPlayer?.setVolume(0, fadeDuration: 0)
      audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
      audioPlayer?.volume = 0
      audioPlayer!.numberOfLoops = -1
      audioPlayer!.prepareToPlay()
      audioPlayer!.play()
      audioPlayer!.setVolume(0.5, fadeDuration: 2)
    } catch {
      print("Cannot play the file")
    }
  }
  
  func playGameMusic() {
    let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "frumpyplaying", ofType: "mp3")!)
    do {
      gameMusic = try AVAudioPlayer(contentsOf:aSound as URL)
      gameMusic?.volume = 0
      gameMusic!.numberOfLoops = -1
      gameMusic!.prepareToPlay()
      gameMusic!.play()
      gameMusic?.setVolume(0.5, fadeDuration: 4)
    } catch {
      print("Cannot play the file")
    }
  }
  
  func stopBackgroundMusic() {
    if (audioPlayer?.isPlaying)! {
      audioPlayer?.volume = 0
      audioPlayer?.stop()
      audioPlayer?.setVolume(0, fadeDuration: 2)
    }
  }
  
  func stopPlayingMusic() {
    if (gameMusic?.isPlaying)! {
      gameMusic?.stop()
    }
  }
  
  func playRainSounds() {
    let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "rain", ofType: "mp3")!)
    do {
      rainPlayer = try AVAudioPlayer(contentsOf:sound as URL)
      rainPlayer?.volume = 0
      rainPlayer!.numberOfLoops = -1
      rainPlayer!.prepareToPlay()
      rainPlayer!.play()
      rainPlayer!.setVolume(0.7, fadeDuration: 2)
    } catch {
      print("Cannot play the file")
    }
  }
  
  func stopRainSounds() {
    if (rainPlayer?.isPlaying)! {
      rainPlayer?.setVolume(0, fadeDuration: 2)
      rainPlayer?.stop()
    }
  }
}
