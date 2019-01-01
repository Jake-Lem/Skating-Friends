//
//  StartScene.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/10/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import SpriteKit
import GameplayKit

class RecordScene: SKScene {
    let defaults = UserDefaults.standard
/*
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()*/
    var fullScreen : ScrollingSprite?
    var toolbar : SKSpriteNode?
    var backLabel = SKLabelNode(fontNamed:"Helvetica")
    var highScoreLabel = SKLabelNode(fontNamed:"HelveticaNeue-CondensedBold")
    var hsNumberLabel = SKLabelNode(fontNamed:"Helvetica")
    var levelLabel = SKLabelNode(fontNamed:"Helvetica")
    var cat1 = SKSpriteNode(imageNamed: "Catoko - Skating_0")
    var cat2 = SKSpriteNode(imageNamed: "Catoko - Skating_0")
    var cat3 = SKSpriteNode(imageNamed: "Catoko - Skating_0")
    var catArray : [SKSpriteNode]! = []
    
    
    override func didMove(to view: SKView) {
        if view.gestureRecognizers != nil {
            for gesture in view.gestureRecognizers! {
                if let recognizer = gesture as? UISwipeGestureRecognizer {
                    view.removeGestureRecognizer(recognizer)
                }
            }
        }
        toolbar = SKSpriteNode(color: UIColor(red:0, green:0.45, blue:0.5, alpha:0), size: CGSize(width: size.width, height: 120))
        toolbar?.position = CGPoint (x: 0, y: frame.maxY - (toolbar?.size.height)!/2)
        toolbar?.zPosition = 2
        addChild(toolbar!)
        
        
        fullScreen = ScrollingSprite(withTexture: nil, withColor: UIColor(red:0.76, green:0.88, blue:1, alpha:1), withSize: CGSize(width: size.width, height: size.height*2), withFrame: self)
        fullScreen?.position = CGPoint(x:0, y: self.frame.maxY - (fullScreen?.size.height)! / 2)
        fullScreen?.zPosition = 0
        addChild(fullScreen!)
        
        
        let rink = SKSpriteNode(imageNamed: "foregroundtrans")
        
        rink.name = "Rink"
        rink.size = CGSize (width: 1400, height: 1500)
        rink.anchorPoint = CGPoint(x: 0.5, y:0.5)
        rink.position = CGPoint(x: 0, y: 0)
        rink.zPosition = 1
        addChild(rink)
        
        let sky = SKSpriteNode(imageNamed: "sky1")
        
        sky.name = "Sky"
        sky.size = CGSize (width: 1400, height: 1500)
        sky.anchorPoint = CGPoint(x: 0.5, y:0.5)
        sky.position = CGPoint(x: 0, y: 0)
        sky.zPosition = 0
        addChild(sky)
        
        backLabel.text = "back"
        backLabel.fontSize = 50
        backLabel.position = CGPoint(x: -500, y: -10)
        toolbar?.addChild(backLabel)
        
        highScoreLabel.text = "High Score: " + String(format: "%.1f", defaults.double(forKey: "High Score"))
        
        highScoreLabel.fontSize = 70
        highScoreLabel.zPosition = 2
        //highScoreLabel.fontName = "Helvetica Neue"
        highScoreLabel.position = CGPoint(x: 0, y: 300)
        highScoreLabel.fontColor = UIColor(red:1, green:1, blue:1, alpha:1)
        fullScreen!.addChild(highScoreLabel)

        
        for _ in 0...8 {
            let cat = SKSpriteNode(imageNamed: "Catoko - Skating_0")
            cat.size = CGSize(width:  270, height: 270)
            cat.zPosition = 2
            catArray.append(cat)
        }

        
        
        catArray[0].run(SKAction.repeatForever(SKAction(named:"CatokoLayback1", duration: 0.3)!))
        catArray[1].run(SKAction.repeatForever(SKAction(named:"MeowCamel", duration: 0.3)!))
        catArray[2].run(SKAction.repeatForever(SKAction(named:"MewnaSpin4", duration: 0.3)!))


        
        for i  in 0 ... 2 {
            catArray[i].position = CGPoint(x: -200 + 200 * i, y: -200)
            addChild(catArray[i])
        }


        let PlayerLevel = defaults.integer(forKey: "PlayerLevel")
        levelLabel.text = String(PlayerLevel)
        levelLabel.zPosition = 2
        levelLabel.position = CGPoint(x: 0, y: 600)
        fullScreen?.addChild(levelLabel)

        
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

