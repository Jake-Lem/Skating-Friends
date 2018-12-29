//
//  Element.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/12/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Formation {
    var form = SKSpriteNode(color: UIColor(red:1, green:1, blue:1, alpha:0), size: CGSize(width: 400, height: 250))
    var itemArray : [SKSpriteNode]!
    var model : SKSpriteNode!
    var physicsModel : SKPhysicsBody

    init (withArray: [SKSpriteNode], withModel: SKSpriteNode, withPhysics: SKPhysicsBody) {
        itemArray = withArray
        model = withModel
        physicsModel = withPhysics
        for item in itemArray {
            item.physicsBody = SKPhysicsBody(rectangleOf: model.size)
            item.physicsBody?.affectedByGravity = (physicsModel.affectedByGravity)
            item.physicsBody?.allowsRotation = (physicsModel.allowsRotation)
            item.physicsBody?.collisionBitMask = (physicsModel.collisionBitMask)
            item.physicsBody?.contactTestBitMask = (physicsModel.contactTestBitMask)
            item.physicsBody?.categoryBitMask = (physicsModel.categoryBitMask)

           
        }

    }
    
    
    static func quadFormMinus (a: Double, b: Double, c: Double) -> Double {
        return (-b - (b * b - 4 * a * c).squareRoot()) / (2 * a)
    }
    
    static func quadFormPlus (a: Double, b: Double, c: Double) -> Double {
        return (-b + (b * b - 4 * a * c).squareRoot()) / (2 * a)
    }
    
    func resetPhysics() {
         for item in itemArray {
            item.physicsBody = SKPhysicsBody(rectangleOf: model.size)
            item.physicsBody?.affectedByGravity = (physicsModel.affectedByGravity)
            item.physicsBody?.allowsRotation = (physicsModel.allowsRotation)
            item.physicsBody?.collisionBitMask = (physicsModel.collisionBitMask)
            item.physicsBody?.contactTestBitMask = (physicsModel.contactTestBitMask)
            item.physicsBody?.categoryBitMask = (physicsModel.categoryBitMask)
            item.physicsBody?.pinned = (physicsModel.pinned)
            item.physicsBody?.friction = physicsModel.friction


        }
    }
    func setFormation(withForm: Int) {
        resetPhysics()
        form.removeAllActions()
        for item in itemArray {
            item.removeFromParent()
        }
        

        
        
        switch withForm {


        case 1:

            for i in 1...5 {
                if itemArray.count <= i {
                    for item in itemArray {
                        form.addChild(item)
                    }
                    return
                }
                itemArray[i].position = CGPoint(x:  -(400 / 2) + (400 / 5) * Double(i), y: -125)
                
            }
            for i in 6...10 {
                if itemArray.count <= i {
                    for item in itemArray {
                        form.addChild(item)
                    }
                    return
                }
                itemArray[i].position = CGPoint(x: -(400 / 2) + (400 / 5) * Double(i - 5), y: 0)
                
            }
            for i in 11...15 {
                if itemArray.count <= i {
                    for item in itemArray {
                        form.addChild(item)
                    }
                    return
                }
                itemArray[i].position = CGPoint(x:  -(400 / 2) + (400 / 5) * Double(i - 10), y: 125)
                
            }
            
            for item in itemArray {
                form.addChild(item)
            }
            
        case 2:

            let vy : Double = 70
            let vx : Double = 40
            let totalTime = max(Formation.quadFormMinus(a: -4.9, b: vy, c: 0), Formation.quadFormPlus(a: -4.9, b: vy, c: 0))
            //print (totalTime)
            var count = 0
            for item in itemArray {
                if count == 0 {
                    count += 1
                    continue
                }
            

                
                let t = (totalTime / Double(itemArray.count - 1)) * Double(count)
                //print(t)
                item.position = CGPoint(x: vx * Double(count), y: -90 + vy * t - 4.9 * t * t)
                
                form.addChild(item)
                count += 1
                }
                
            
        case 3:
            for item in itemArray {
                let i = itemArray.index(of: item)
                if i != 0 {

                let wait = SKAction.wait(forDuration: 0.2 * Double(i!))
                item.physicsBody?.affectedByGravity = true
                item.position = CGPoint(x: 0, y: 100)
                
                let runBlock = SKAction.run {
                    [unowned self] in
                    item.removeFromParent()
                self.form.addChild(item)
                }
                
                
                let reset = SKAction.run {
                    [unowned self] in
                    item.physicsBody?.velocity.dy = 0

                    item.removeFromParent()
                    item.position = CGPoint(x: 0, y: 100)
                    self.form.addChild(item)
                }
                
                
                let waitRun = SKAction.sequence([wait, runBlock, reset])
                    form.run(SKAction.repeatForever(waitRun))
                }
            }
            
            
        case 4:
            let randx = 200 + arc4random_uniform(300)
            let randy = 0
            let randPlats = 4 + arc4random_uniform(6)
            let randInterval = itemArray.count - 3 + Int(arc4random_uniform(6))

            let vy : Double = Double(randy)
            let vx : Double = Double(randx)
            
            let totalTime = max(Formation.quadFormMinus(a: -4.9, b: vy, c: 0), Formation.quadFormPlus(a: -4.9, b: vy, c: 0))
            //print (totalTime)
            var count : Double = 0
            for item in itemArray {
                if count == 0 || count > Double(randPlats) {
                    count += 1
                    continue
                }
                let t = (totalTime / Double(randInterval) * Double(count - 1))
                //print(t)
                item.position = CGPoint(x: vx * Double(count), y: -90 + vy * t - 4.9 * t * t)
                
                form.addChild(item)
                count += 1
            }
            
        case 5:
            //let randy = Double(10 + arc4random_uniform(40))
            let randy = 0
            var count = 0
            for item in itemArray {
                if count == 0 {
                    count += 1
                    continue
                }
                item.position = CGPoint(x: item.size.width * CGFloat(count), y: CGFloat(randy))
                
                form.addChild(item)
                count += 1
            }
            
        case 6:
            let randy = 0
            let randMoving = Double(arc4random_uniform(UInt32(itemArray.count - 1))) + 1
            var count = 0
            for item in itemArray {
                if count == 0 {
                    count += 1
                    continue
                }
                item.position = CGPoint(x: item.size.width * CGFloat(count), y: CGFloat(randy))
                
                form.addChild(item)
                count += 1
            }
            
            
            for i in 1...Int(randMoving) {
                let randTime = 1.8 + Double(arc4random_uniform(10)/5)
                let randDy = Double(arc4random_uniform(300)) + 150

                itemArray[i].physicsBody?.pinned = false
                itemArray[i].physicsBody?.velocity.dy = CGFloat(randDy)
                let reset = SKAction.run {
                    [unowned self] in
                    self.itemArray[i].physicsBody?.velocity.dy *= -1
                }
                
                let wait = SKAction.wait(forDuration: randTime)
                
                form.run(SKAction.repeatForever(SKAction.sequence([wait, reset])))
            }
            
        case 7:
            let randy = Double(arc4random_uniform(10))
            let randMoving = Double(arc4random_uniform(UInt32(itemArray.count - 1))) + 1
            var count = 0
            for item in itemArray {
                if count == 0 {
                    count += 1
                    continue
                }
                item.position = CGPoint(x: item.size.width * CGFloat(count), y: CGFloat(randy))
                
                form.addChild(item)
                count += 1
            }
            
            
            for i in 0...Int(randMoving) {
                let randTime = 1.8 + Double(arc4random_uniform(10)/5)
                let randDy = Double(arc4random_uniform(300)) + 150
                
                itemArray[i].physicsBody?.pinned = false
                itemArray[i].physicsBody?.velocity.dy = CGFloat(randDy)
                let reset = SKAction.run {
                    [unowned self] in
                    self.itemArray[i].physicsBody?.velocity.dy *= -1
                }
                
                let wait = SKAction.wait(forDuration: randTime)
                
                let waitRepeat =  SKAction.repeatForever(SKAction.sequence([wait, reset]))
                let halfwait = SKAction.wait(forDuration: randTime/2)
                let halfGo = SKAction.sequence([halfwait, reset])
                form.run(SKAction.sequence([halfGo, SKAction.repeatForever(waitRepeat)]))
            }
            
        default:
            
            for i in 1...5 {
                if itemArray.count <= i {
                    for item in itemArray {
                        form.addChild(item)
                    }
                    return
                }
                itemArray[i].position = CGPoint(x:  -(400 / 2) + (400 / 5) * Double(i), y: -125)
                
            }
            for i in 6...10 {
                if itemArray.count <= i {
                    for item in itemArray {
                        form.addChild(item)
                    }
                    return
                }
                itemArray[i].position = CGPoint(x: -(400 / 2) + (400 / 5) * Double(i - 5), y: 0)
                
            }
            for i in 11...15 {
                if itemArray.count <= i {
                    for item in itemArray {
                        form.addChild(item)
                    }
                    return
                }
                itemArray[i].position = CGPoint(x:  -(400 / 2) + (400 / 5) * Double(i - 10), y: 125)
                
            }
            
            for item in itemArray {
                form.addChild(item)
            }
        }

    }
}
