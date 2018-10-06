//
//  StartScene.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/10/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import SpriteKit
import GameplayKit

class ShopScene: SKScene {
    let defaults = UserDefaults.standard
    /*
     let swipeRightRec = UISwipeGestureRecognizer()
     let swipeLeftRec = UISwipeGestureRecognizer()
     let swipeUpRec = UISwipeGestureRecognizer()
     let swipeDownRec = UISwipeGestureRecognizer()*/
    var fullScreen : ScrollingSprite?
    var toolbar : SKSpriteNode?
    var backLabel = SKLabelNode(fontNamed:"Helvetica")
    var coinsLabel = SKLabelNode(fontNamed:"Helvetica")
    
    
    
    override func didMove(to view: SKView) {
        if view.gestureRecognizers != nil {
            for gesture in view.gestureRecognizers! {
                if let recognizer = gesture as? UISwipeGestureRecognizer {
                    view.removeGestureRecognizer(recognizer)
                }
            }
        }
        toolbar = SKSpriteNode(color: UIColor(red:0.40, green:0.47, blue:0.64, alpha:0.95), size: CGSize(width: size.width, height: 120))
        toolbar?.position = CGPoint (x: 0, y: frame.maxY - (toolbar?.size.height)!/2)
        toolbar?.zPosition = 2
        addChild(toolbar!)
        
        
        fullScreen = ScrollingSprite(withTexture: nil, withColor: UIColor(red:1, green:0.47, blue:0.64, alpha:0.95), withSize: CGSize(width: size.width, height: size.height*2), withFrame: self)
        fullScreen?.position = CGPoint(x:0, y: self.frame.maxY - (fullScreen?.size.height)! / 2)
        fullScreen?.zPosition = 0
        addChild(fullScreen!)
        
        
        backLabel.text = "back"
        backLabel.fontSize = 50
        backLabel.position = CGPoint(x: -500, y: -10)
        toolbar?.addChild(backLabel)
        
        coinsLabel.text = "Coins: " + String(format: "%.1f", defaults.double(forKey: "Coins"))
        coinsLabel.fontSize = 70
        coinsLabel.zPosition = 2
        coinsLabel.position = CGPoint(x: 0, y: 550)
        
        
        fullScreen!.addChild(coinsLabel)
        
        let rink = SKSpriteNode(imageNamed: "foregroundtrans")
        
        rink.name = "Rink"
        rink.size = CGSize (width: 1400, height: 1500)
        rink.anchorPoint = CGPoint(x: 0.5, y:0.5)
        rink.position = CGPoint(x: 0, y: -200)
        rink.zPosition = 1
        addChild(rink)
        
        let sky = SKSpriteNode(imageNamed: "background11")
        
        sky.name = "Sky"
        sky.size = CGSize (width: 1400, height: 1500)
        sky.anchorPoint = CGPoint(x: 0.5, y:0.5)
        sky.position = CGPoint(x: 0, y: 0)
        sky.zPosition = 0
        addChild(sky)
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let toolconvert = convert(pos, to: toolbar!)
        if backLabel.contains(toolconvert) {
            let prevScene = SKScene(fileNamed: "StartScene")
            prevScene?.scaleMode = SKSceneScaleMode.aspectFill
            
            scene?.view?.presentScene(prevScene!)
            
        }
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
        let touch = touches.first
        let currPos = touch?.location(in: self)
        let prevPos = touch?.previousLocation(in: self)
        fullScreen?.scroll(initial: prevPos!, final: currPos!)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}

