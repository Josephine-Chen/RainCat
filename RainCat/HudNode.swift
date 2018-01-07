//
//  HudNode.swift
//  RainCat
//
//  Created by Josephine Chen on 1/7/18.
//  Copyright © 2018 Thirteen23. All rights reserved.
//

import SpriteKit

class HudNode : SKNode {
    var quitButtonAction : (() -> ())?
    private let scoreKey = "RAINCAT_HIGHSCORE"
    private let scoreNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private(set) var score : Int = 0
    private var highScore : Int = 0
    private var showingHighScore = false
    private(set) var quitButtonPressed = false
    
    //Set up HUD here
    public func setup(size: CGSize) {
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: scoreKey)
        
        scoreNode.text = "\(score)"
        scoreNode.fontSize = 70
        scoreNode.position = CGPoint(x: size.width / 2, y: size.height - 100)
        scoreNode.zPosition = 1
        
        addChild(scoreNode)
        
        //quit button
        quitButton = SKSpriteNode(texture: quitButtonTexture)
        let margin : CGFloat = 15
        quitButton.position = CGPoint(x: size.width - quitButton.size.width - margin, y: size.height - quitButton.size.height - margin)
        quitButton.zPosition = 1000
        
        addChild(quitButton)
    }
    
    //Add point
    /*
     -Increment score
     -Saves user defaults
     -If high score achieved, enlarge scoreNode and update the color
     */
    public func addPoint() {
        score += 1
        
        updateScoreboard()
        
        if score > highScore {
            let defaults = UserDefaults.standard
            defaults.set(score, forKey: scoreKey)
            
            if !showingHighScore {
                showingHighScore = true
                
                scoreNode.run(SKAction.scale(to: 1.5, duration: 0.25))
                scoreNode.fontColor = SKColor(red: 0.99, green: 0.92, blue: 0.55, alpha: 1.0)
            }
        }
    }
    
    //Reset points
    /*
     -Sets score to zero
     -Updates score label
     -Resets color and size to default values
     */
    public func resetPoints() {
        score = 0
        
        updateScoreboard()
        
        if showingHighScore {
            showingHighScore = false
            
            scoreNode.run(SKAction.scale(to: 1.0, duration: 0.25))
            scoreNode.fontColor = SKColor.white
        }
    }
    
    // Updates the score label to show current score
    private func updateScoreboard() {
        scoreNode.text = "\(score)"
    }
    
    //Quit
    private var quitButton : SKSpriteNode!
    private let quitButtonTexture = SKTexture(imageNamed: "quit_button")
    private let quitButtonPressedTexture = SKTexture(imageNamed: "quit_button_pressed")
    
    func touchBeganAtPoint(point : CGPoint) {
        let containsPoint = quitButton.contains(point)
        
        if quitButtonPressed && !containsPoint {
            //Cancel the last click
            quitButtonPressed = false
            quitButton.texture = quitButtonTexture
        } else if containsPoint {
            quitButton.texture = quitButtonPressedTexture
            quitButtonPressed = true
        }
    }
    
    func touchMovedToPoint(point : CGPoint ) {
        if quitButtonPressed {
            if quitButton.contains(point) {
                quitButton.texture = quitButtonPressedTexture
            } else {
                quitButton.texture = quitButtonTexture
            }
        }
    }
    
    func touchEndedAtPoint(point : CGPoint) {
        if quitButton.contains(point) {
            if quitButton.contains(point) && quitButtonAction != nil {
                quitButtonAction!()
            }
        }
        
        quitButton.texture = quitButtonTexture
    }
}
