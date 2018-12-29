//
//  StartScene.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/10/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import SpriteKit
import GameplayKit

class CharacterScene: SKScene {
    let defaults = UserDefaults.standard

    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    
    var catoko = Catoko()
    var meow = MeowAsada()
    var mewna = Mewna()
    
    var catokoButton : Button?
    var meowButton : Button?
    var mewnaButton : Button?

    var toolbar : SKSpriteNode?
    var backLabel = SKLabelNode(fontNamed:"Avenir-Black")
    var chooseLabel = SKLabelNode(fontNamed:"Avenir-Black")

    var highScoreLabel = SKLabelNode(fontNamed:"Helvetica")
    var statsSprite = SKSpriteNode(color: UIColor(red:0.40, green:0.47, blue:0.64, alpha:0), size: CGSize(width: 350, height: 250))
    var artLabel = SKLabelNode(fontNamed:"Avenir-Black")
    var repLabel = SKLabelNode(fontNamed:"Avenir-Black")
    var heightLabel = SKLabelNode(fontNamed:"Avenir-Black")
    var controlLabel = SKLabelNode(fontNamed:"Avenir-Black")
    var skaterName = SKLabelNode(fontNamed:"Avenir-Black")

    
    var goLabel = SKLabelNode(fontNamed:"Avenir-Black")

    var goSprite = SKSpriteNode(color: UIColor(red:1.0, green:0.47, blue:0.64, alpha:0.95), size: CGSize(width: 200, height: 40))

    
    override func didMove(to view: SKView) {
        toolbar = SKSpriteNode(color: UIColor(red:0.73, green:0.9, blue:1.0, alpha:0.95),size: CGSize(width: self.size.width, height: 120))
        toolbar?.position = CGPoint (x: 0, y: self.frame.maxY - (toolbar?.size.height)!/2)
        self.addChild(toolbar!)
        
        backLabel.text = "back"
        backLabel.fontSize = 50
        backLabel.position = CGPoint(x: -500, y: -10)
        toolbar?.addChild(backLabel)
        
        
        chooseLabel.text = "CHOOSE YOUR CHARACTER"
        chooseLabel.fontSize = 50
        chooseLabel.position = CGPoint(x: 0, y: -10)
        toolbar?.addChild(chooseLabel)
        
        
        let sky = SKSpriteNode(imageNamed: "sky1")
        
        sky.name = "Sky"
        sky.size = CGSize (width: 1400, height: 1500)
        sky.anchorPoint = CGPoint(x: 0.5, y:0.5)
        sky.position = CGPoint(x: 0, y: 0)
        sky.zPosition = -1
        addChild(sky)

        //catoko.setSize(withSize: 300)
        //meow.setSize(withSize: 400)
        //mewna.setSize(withSize: 400)

        catoko.sprite.run(catoko.skating)
        meow.sprite.run(meow.skating)
        mewna.sprite.run(mewna.skating)

        catoko.sprite.position = CGPoint (x: -500, y: 100)
        catoko.sprite.physicsBody!.pinned = true
        self.addChild(catoko.sprite)
        
        meow.sprite.position = CGPoint (x: -300, y: 100)
        meow.sprite.physicsBody!.pinned = true
        self.addChild(meow.sprite)
        
        
        mewna.sprite.position = CGPoint (x: -510, y: -100)
        mewna.sprite.physicsBody!.pinned = true
        self.addChild(mewna.sprite)

        let enlarge = SKAction.scale(by: 1.2, duration: 0.3)
        statsSprite.position = CGPoint(x: 200, y: 0)
        meowButton = Button(theSprite: meow.sprite, theAction: enlarge)
        catokoButton = Button(theSprite: catoko.sprite, theAction: enlarge)
        mewnaButton = Button(theSprite: mewna.sprite, theAction: enlarge)
        
        
        skaterName.text = ""
        skaterName.fontSize = 35
        skaterName.position = CGPoint(x: 0, y: 70)

        artLabel.text = ""
        artLabel.fontSize = 25
        artLabel.position = CGPoint(x: 0, y: 30)

        heightLabel.text = ""
        heightLabel.fontSize = 25
        heightLabel.position = CGPoint(x: 0, y: 0)
        
        repLabel.text = ""
        repLabel.fontSize = 25
        repLabel.position = CGPoint(x: 0, y: -30)
        
        controlLabel.text = ""
        controlLabel.fontSize = 25
        controlLabel.position = CGPoint(x: 0, y: -60)

        
        statsSprite.addChild(goSprite)
        goSprite.addChild(goLabel)
        statsSprite.addChild(skaterName)
        statsSprite.addChild(artLabel)
        statsSprite.addChild(heightLabel)
        statsSprite.addChild(repLabel)
        statsSprite.addChild(controlLabel)

        statsSprite.setScale(2)

        goSprite.position = CGPoint(x: 0, y: -90)
        goSprite.name = "Go Sprite"
        goLabel.position = CGPoint(x: 0, y: -(goLabel.fontSize / 2))
        goLabel.text = "GO!"

       

        swipeRightRec.addTarget(self, action: #selector(CharacterScene.swipedRight))
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
        
        swipeLeftRec.addTarget(self, action: #selector(CharacterScene.swipedLeft))
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
        
        swipeDownRec.addTarget(self, action: #selector(CharacterScene.swipedDown))
        swipeDownRec.direction = .down
        self.view!.addGestureRecognizer(swipeDownRec)
        
        swipeUpRec.addTarget(self, action: #selector(CharacterScene.swipedUp))
        swipeUpRec.direction = .up
        self.view!.addGestureRecognizer(swipeUpRec)
        
        
        highScoreLabel.text = "High Score: " + String(format: "%.1f", defaults.double(forKey: "High Score"))
        highScoreLabel.fontSize = 70
        highScoreLabel.zPosition = 10
        highScoreLabel.position = CGPoint(x: 0, y: -550)
        
        //self.addChild(highScoreLabel)
        
        
        
        
    }
    
    
    
    
    @objc func swipedRight() {
        
    }
    
    @objc func swipedLeft() {

        
    }
    
    @objc func swipedUp() {
    }
    
    @objc func swipedDown() {
 
    }
    
    func addStats (forChar : Skater) {
        statsSprite.removeFromParent()
        skaterName.text = forChar.skaterName
        artLabel.text = "Artistry: " + String(forChar.artistry)
        repLabel.text = "Reputation: " + String(forChar.reputation)
        heightLabel.text = "Jump Height: " + String(forChar.jumpHeight)
        controlLabel.text = "Control: " + String(forChar.control)
        self.addChild(statsSprite)

    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let statsconvert = convert(pos, to: statsSprite)
        let toolconvert = convert(pos, to: toolbar!)
        
        if catoko.sprite.contains(pos) {
            catokoButton?.click()
            mewnaButton?.unclick()

            meowButton?.unclick()
            addStats(forChar: catoko)
            defaults.set(0, forKey: "Current Skater")

        } else if meow.sprite.contains(pos) {
            catokoButton?.unclick()
            mewnaButton?.unclick()

            meowButton?.click()
            addStats(forChar: meow)
            defaults.set(1, forKey: "Current Skater")

        } else if mewna.sprite.contains(pos) {
            catokoButton?.unclick()
            meowButton?.unclick()
            mewnaButton?.click()
            addStats(forChar: mewna)
            defaults.set(2, forKey: "Current Skater")


        } else {
            catokoButton?.unclick()
            meowButton?.unclick()
            mewnaButton?.unclick()

            statsSprite.removeFromParent()
            
        }
        
        if goSprite.contains(statsconvert) {
            let gameScene = SKScene(fileNamed: "GameScene")
            gameScene?.scaleMode = SKSceneScaleMode.aspectFill
            self.scene?.view?.presentScene(gameScene!)
            
        }
        
        if backLabel.contains(toolconvert) {
            let prevScene = SKScene(fileNamed: "StartScene")
            prevScene?.scaleMode = SKSceneScaleMode.aspectFill
            self.scene?.view?.presentScene(prevScene!)

        }
        
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
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
    
    deinit {
        print("deinit character scene")
    }
    
    
}

