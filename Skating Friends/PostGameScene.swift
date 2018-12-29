//
//  StartScene.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/10/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import SpriteKit
import GameplayKit

class PostGameScene: SKScene {
    let defaults = UserDefaults.standard

    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    
    var artistry : Double!
    var skatingSkills : Double = 0
    var transitions : Double = 0
    var composition : Double = 0
    var performance : Double = 0
    var interpretation : Double = 0
    var totalPCS : Double = 0
    var coins = 0
    var ssLabel = SKLabelNode(fontNamed: "Helvetica")
    var transitionsLabel = SKLabelNode(fontNamed: "Helvetica")
    var compLabel = SKLabelNode(fontNamed: "Helvetica")
    var performanceLabel = SKLabelNode(fontNamed: "Helvetica")
    var interpLabel = SKLabelNode(fontNamed: "Helvetica")
    var pcsLabel = SKLabelNode(fontNamed: "Helvetica")
    
    
    var coinsLabel = SKLabelNode(fontNamed: "Helvetica")

    var techLabel = SKLabelNode(fontNamed: "Helvetica")
    var totalLabel = SKLabelNode(fontNamed: "Helvetica")
    var highScoreLabel = SKLabelNode(fontNamed: "Helvetica")



    var total : Double = 0
    var scoresheet : [Element]!
    var techScore : Double!

    var thePlayer : Skater!

    override func didMove(to view: SKView) {
        let currentSkater = defaults.integer(forKey: "Current Skater")
        switch currentSkater {
        case 0:
            thePlayer = Catoko()
            
        case 1:
            thePlayer = MeowAsada()
            print(thePlayer.rotate.duration)
        case 2:
            thePlayer = Mewna()

        default:
            thePlayer = Catoko()
        }

        artistry = thePlayer.artistry
        
        thePlayer.sprite.physicsBody?.pinned = true
        
        
        scoresheet = userData?.value(forKey: "scoresheet") as? [Element]
        techScore = userData?.value(forKey: "score") as? Double
        coins = userData?.value(forKey: "coins") as! Int
        
        let numCoins = defaults.integer(forKey: "Coins")
        let newCoins = coins + numCoins
        defaults.set(newCoins, forKey: "Coins")

        
        calcComponents ()
        total = techScore + totalPCS + Double(coins)
        
        swipeRightRec.addTarget(self, action: #selector(StartScene.swipedRight))
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
        
        swipeLeftRec.addTarget(self, action: #selector(StartScene.swipedLeft))
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
        
        swipeDownRec.addTarget(self, action: #selector(StartScene.swipedDown))
        swipeDownRec.direction = .down
        self.view!.addGestureRecognizer(swipeDownRec)
        
        swipeUpRec.addTarget(self, action: #selector(StartScene.swipedUp))
        swipeUpRec.direction = .up
        self.view!.addGestureRecognizer(swipeUpRec)
        
        thePlayer.sprite.position = CGPoint(x: 0.5, y:-40)
        thePlayer.sprite.zPosition = -1

        self.addChild(thePlayer.sprite)

        thePlayer.sprite.run(thePlayer.bow)
        
        
        
        coinsLabel.text = "Coins Collected: " + String(coins)
        coinsLabel.position = CGPoint(x: 0.5, y:300)
        coinsLabel.fontSize = 30
        coinsLabel.fontColor = UIColor(red:0.40, green:0.47, blue:0.64, alpha: 1)
        
        
        ssLabel.text = "Skating Skills: " + String(format:"%.1f", skatingSkills)
        ssLabel.position = CGPoint(x: 0.5, y:250)
        ssLabel.fontSize = 30
        ssLabel.fontColor = UIColor(red:0.40, green:0.47, blue:0.64, alpha: 1)
        
        transitionsLabel.text = "Transitions: " + String(format:"%.1f", transitions)
        transitionsLabel.position = CGPoint(x: 0.5, y:200)
        transitionsLabel.fontSize = 30
        transitionsLabel.fontColor = UIColor(red:0.40, green:0.47, blue:0.64, alpha: 1)

        
        compLabel.text = "Composition: " +  String(format:"%.1f", composition)
        compLabel.position = CGPoint(x: 0.5, y:150)
        compLabel.fontSize = 30
        compLabel.fontColor = UIColor(red:0.40, green:0.47, blue:0.64, alpha: 1)

        
        performanceLabel.text = "Performance: " + String(format:"%.1f", performance)
        performanceLabel.position = CGPoint(x: 0.5, y:100)
        performanceLabel.fontSize = 30
        performanceLabel.fontColor = UIColor(red:0.40, green:0.47, blue:0.64, alpha: 1)

        
        interpLabel.text = "Interpretation: " + String(format:"%.1f", interpretation)
        interpLabel.position = CGPoint(x: 0.5, y:50)
        interpLabel.fontSize = 30
        interpLabel.fontColor = UIColor(red:0.40, green:0.47, blue:0.64, alpha: 1)

        pcsLabel.text = "Total Program Components: " + String(format:"%.1f", totalPCS)
        pcsLabel.position = CGPoint(x: 0.5, y:0)
        pcsLabel.fontSize = 30
        pcsLabel.fontColor = UIColor(red:0.40, green:0.47, blue:0.64, alpha: 1)
        
        techLabel.text = "Technical Score: " + String(format:"%.1f", techScore)
        techLabel.position = CGPoint(x: 0.5, y:-50)
        techLabel.fontSize = 30
        techLabel.fontColor = UIColor(red:0.40, green:0.47, blue:0.64, alpha: 1)

        
        totalLabel.text = "FINAL SCORE: " + String(format:"%.1f", total)
        totalLabel.position = CGPoint(x: 0.5, y:-200)
        totalLabel.fontSize = 60
        totalLabel.fontColor = UIColor(red:0.40, green:0.47, blue:0.64, alpha: 1)
        
        highScoreLabel.text = "New High Score!"
        highScoreLabel.position = CGPoint(x: 0.5, y:-150)
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = UIColor(red:1, green:0.47, blue:0.64, alpha: 1)

        let prevHighScore = defaults.double(forKey: "High Score")
        if(self.total > prevHighScore) {
        let newHighScore = self.total
        defaults.set(newHighScore, forKey: "High Score")
            self.addChild(highScoreLabel)

        }
        
        


        self.addChild(coinsLabel)

        self.addChild(ssLabel)
        self.addChild(transitionsLabel)
        self.addChild(compLabel)
        self.addChild(performanceLabel)
        self.addChild(interpLabel)
        self.addChild(pcsLabel)
        self.addChild(techLabel)
        self.addChild(totalLabel)


    }
    
    
    
    
    func swipedRight() {
        
        print("right")
        
    }
    
    func swipedLeft() {
        print("lft")
        
        
    }
    
    func swipedUp() {
        print("up")
        let gameScene = SKScene(fileNamed: "GameScene")
        gameScene?.scaleMode = SKSceneScaleMode.aspectFill
        
        
        self.scene?.view?.presentScene(gameScene!, transition: SKTransition.flipVertical(withDuration: 5))
        
        
        /*print("up")
         let gameScene = GameScene()
         gameScene.scaleMode = SKSceneScaleMode.aspectFill
         gameScene.thePlayer = Catoko()
         self.scene?.view?.presentScene(gameScene, transition: SKTransition.flipVertical(withDuration: 5))
         */
    }
    
    func swipedDown() {
        print("down")
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        print("down")
        let startScene = SKScene(fileNamed: "StartScene")
        startScene?.scaleMode = SKSceneScaleMode.aspectFill
        
        self.scene?.view?.presentScene(startScene!, transition: SKTransition.flipHorizontal(withDuration: 1))

        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    func calcComponents () {
        var typeArr : [Tech] = []
        var falls : Double = 0
        var numSteps : Double = 0
        
        for move in scoresheet {
            if move.fall {
                falls += 1
            }
            
            if move.type == Tech.Steps {
                numSteps += 1
            }
            typeArr.append (move.type)
            
        }
        
        let setCounter = NSSet (array: typeArr)
        let elementCount = Double(setCounter.count)
        let compFactor = elementCount / 10
        composition = 0.6 * artistry + 3 * compFactor
        skatingSkills = artistry - falls * 0.5 + numSteps / 20
        transitions = 0.6 * artistry + numSteps / 6
        performance = artistry - falls * 0.5
        interpretation = artistry

        composition = cap(ceiling : 10, forDouble: composition)
        skatingSkills = cap(ceiling : 10, forDouble: skatingSkills)
        transitions = cap (ceiling : 10, forDouble: transitions)
        performance = cap (ceiling : 10, forDouble: performance)
        interpretation = cap (ceiling : 10, forDouble: interpretation)
        totalPCS = composition + skatingSkills + transitions + performance + interpretation
    }
    
    func cap(ceiling: Double , forDouble : Double) -> Double {
        var capped : Double = forDouble
        if (forDouble > ceiling) {
            capped = ceiling
        }
        return capped
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}

