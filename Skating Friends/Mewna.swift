//
//  Skater.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/11/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import Foundation
import SpriteKit


class Mewna : Skater {
    
    var spinPower: Double = 4
    var spiralPower : Double = 3.5
    
    
    var artistry: Double = 10
    var reputation: Double = 10
    var rotationSpeed: Double = 0.3
    var size : Double = 280
    var airTime : Double = 0.9
    var jumpHeight : Double = 200
    var control : Double = 0.9
    var maxSpeed : Double = 2000
    var sprite = SKSpriteNode(imageNamed: "Mewna_0")
    var midair: SKAction!
    var rotate : SKAction!
    
    
    let skaterName = "Kim Mewna"
    
    
    var upStep = SKAction(named:"MewnaSkating", duration: 0.45)!
    var spiral = SKAction(named:"MewnaSpiral", duration: 1.5)!
    var spiralEntrance = SKAction(named:"MewnaSpiralEntrance", duration: 0.2)!
    
    var leftStep = SKAction(named:"MewnaSkating", duration: 0.45)!
    var rightStep = SKAction(named:"MewnaSkating")!
    var downStep = SKAction(named:"MewnaSkating")!
    let skating = SKAction(named:"MewnaSkating")!
    let backTurn = SKAction(named:"MewnaBackTurn", duration: 0.3)!
    let lutzTakeoff = SKAction(named:"MewnaLutz", duration: 0.2)!
    let flipTakeoff = SKAction(named:"MewnaLutz", duration: 0.2)!
    let loopTakeoff = SKAction(named:"MewnaLoop", duration: 0.2)!
    let toeTakeoff = SKAction(named:"MewnaToe", duration: 0.2)!
    let salTakeoff = SKAction(named:"MewnaSal", duration: 0.2)!
    let axelTakeoff = SKAction(named:"MewnaAxel", duration: 0.2)!
    var spin = SKAction(named:"MewnaSpiral", duration: 1.5)!
    var footDiv: Double = 2.7
    
    let landing = SKAction(named:"MewnaLanding", duration: 0.5)!
    let fall = SKAction(named:"MewnaFall", duration: 1)!
    let bow = SKAction(named:"MewnaBow", duration: 2)!
    let jumpTrans = SKAction(named:"MewnaRotate", duration: 0)!
    
    required init () {
        sprite.name = "Kim Mew-Na"
        sprite.size = CGSize (width: size, height: size)
        sprite.position = CGPoint(x: -200, y:-200 )
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Mewna_0"), size: sprite.size)
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody!.affectedByGravity = true
        
        midair = SKAction(named:"MewnaMidair", duration: airTime)!
        rotate = SKAction(named:"MewnaRotate", duration: rotationSpeed)!
        
    }
    
    func setSize(withSize: Double) {
        size = withSize
        sprite.size = CGSize (width: size, height: size)
        
        
    }
    
    func setRotationSpeed(withTime: Double) {
        if withTime < 0.12 {
            rotationSpeed = 0.12
        } else {
            rotationSpeed = withTime
        }
        rotate = SKAction(named:"MewnaRotate", duration: rotationSpeed)!
        
    }
    
    func setAirTime (withTime: Double) {
        midair = SKAction(named:"MewnaMidair", duration: withTime)!
        
    }
    
    func setSpinTrans(spinType: Tech, stage: Int) {
        switch spinType {
        case .Layback:
            switch stage {
            case 0:
                spin = SKAction(named:"MewnaSpinTrans0")!
                print("0")
                
            case 1:
                spin = SKAction(named:"MewnaSpinTrans0")!
                print("1")
                
            case 2:
                let trans = SKAction(named:"MewnaSpinTrans1", duration: 0.15)!
                spin = trans
            case 3:
                spin = SKAction(named:"MewnaSpinTrans2", duration: 0.2)!
            case 4:
                spin = SKAction(named:"MewnaSpinTrans3", duration: 0.3)!
            case 5:
                spin = SKAction(named:"MewnaSpin4", duration: 0.3)!
                
            default:
                print("EXIt")
                spin = SKAction(named:"MewnaSpinExit", duration: 0.3)!
                
            }
        case .ComboSpin:
            break
        default:
            break
        }
    }
    
    func setSpin(spinType: Tech, stage: Int) -> Bool {
        switch spinType {
        case .Layback:
            switch stage {
                
                
            case 1:
                
                spin = SKAction.sequence([SKAction(named:"MewnaSpinTrans0", duration: 0.2)!, SKAction.repeatForever(SKAction(named:"MewnaSpin1", duration: 0.3)!)])
                return false
                
            case 2:
                spin = SKAction.repeatForever(SKAction(named:"MewnaSpin2", duration: 0.3)!)
                
                return false
            case 3:
                spin =  SKAction.repeatForever(SKAction(named:"MewnaSpin3", duration: 0.3)!)
                return false
            case 4:
                spin = SKAction.repeatForever(SKAction(named:"MewnaSpin4", duration: 0.3)!)
                return false
                
            default:
                return true
            }
        case .ComboSpin:
            break
        default:
            break
        }
        return true
    }
    
    func executeMove (withName: Move) {
        switch withName {
        case .lutzTakeoff:
            sprite.run(SKAction.sequence([lutzTakeoff,midair]))
        case .rotate :
            sprite.run(SKAction(named:"CatokoRotate")!)
        case .backTurn :
            sprite.run(backTurn)
        case .landing :
            sprite.run(landing)
        default:
            sprite.run(SKAction(named:"CatokoSkating")!)
        }
    }
}
