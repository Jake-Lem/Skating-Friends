//
//  StartScene.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/10/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    var play : SKLabelNode?
    var seeRecords : SKLabelNode?
    var shop : SKLabelNode?

    
    override func didMove(to view: SKView) {
        
        if let label : SKLabelNode = self.childNode(withName: "Play") as? SKLabelNode {
            play = label
        }
        
        if let label : SKLabelNode = self.childNode(withName: "High Score") as? SKLabelNode {
            seeRecords = label
        }
        
        if let label : SKLabelNode = self.childNode(withName: "Shop") as? SKLabelNode {
            shop = label
        }
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
        
    }
    
    
    
    
    @objc func swipedRight() {
     
        //print("right")

    }
    
    @objc func swipedLeft() {
        //print("lft")

        
    }
    
    @objc func swipedUp() {
    //print("up")
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
    
    @objc func swipedDown() {
       // print("down")

    }
    
    deinit {
        print("deinit startscene")
    }
 
    func touchDown(atPoint pos : CGPoint) {
        //print("down")

        
        if play!.contains(pos) {
            let charScene = SKScene(fileNamed: "CharacterScene")
            charScene?.scaleMode = SKSceneScaleMode.aspectFill
            
            self.scene?.view?.presentScene(charScene!)
        }
        
        if seeRecords!.contains(pos) {
            let recordScene = SKScene(fileNamed: "RecordScene")
            recordScene?.scaleMode = SKSceneScaleMode.aspectFill
            
            self.scene?.view?.presentScene(recordScene!)
        }
        
        if shop!.contains(pos) {
            let recordScene = SKScene(fileNamed: "ShopScene")
            recordScene?.scaleMode = SKSceneScaleMode.aspectFill
            
            self.scene?.view?.presentScene(recordScene!)
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
    
}

