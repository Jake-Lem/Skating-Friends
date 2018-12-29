//
//  Skater.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/11/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import Foundation
import SpriteKit


class MeowAsada : Skater {
    
    
    
    var maxSpeed : Double = 1800

    var spinPower: Double = 4.5
    var spiralPower : Double = 5
    
    var spin = SKAction(named:"MeowSpiral", duration: 1.5)!
    

    
    var artistry: Double = 10
    
    var reputation: Double = 10
    var spiral = SKAction(named:"MeowSpiral", duration: 1.5)!
    var spiralEntrance = SKAction(named:"MeowSpiralEntrance", duration: 0.5)!
    var upStep = SKAction(named:"MeowSpiral", duration: 1.5)!
    
    var leftStep = SKAction(named:"MeowBackTurn", duration: 0.3)!
    
    var rightStep = SKAction(named:"MeowSkating")!
    
    var downStep: SKAction = SKAction(named:"MeowBackTurn", duration: 0.3)!
    
    
    var footDiv: Double = 3
    
    var size : Double = 270
    var airTime: Double = 1.1
    var jumpHeight : Double = 190
    var rotationSpeed: Double = 0.39

    var control : Double = 0.5

    
    var sprite = SKSpriteNode(imageNamed: "Meow_0")
    var midair: SKAction!
    var rotate : SKAction!

    //var midair = SKAction(named:"MeowMidair", duration: 1)!
    let skaterName = "Meow Asada"
    let skating = SKAction(named:"MeowSkating")!
    let backTurn = SKAction(named:"MeowBackTurn")!
    let lutzTakeoff = SKAction(named:"MeowLutz", duration: 0.2)!
    let flipTakeoff = SKAction(named:"MeowLutz", duration: 0.2)!
    let loopTakeoff = SKAction(named:"MeowLoop", duration: 0.2)!
    let toeTakeoff = SKAction(named:"MeowToe", duration: 0.2)!
    let salTakeoff = SKAction(named:"MeowSal", duration: 0.2)!
    let axelTakeoff = SKAction(named:"MeowAxel", duration: 0.2)!

    let landing = SKAction(named:"MeowLanding", duration: 0.75)!
    let fall = SKAction(named:"MeowFall", duration: 1)!
    let bow = SKAction(named:"MeowBow", duration: 2)!
    let jumpTrans = SKAction(named:"MeowSplitTrans", duration: 0.07)!
    
    required init () {
       // var midairAniSpeed = 1/airTime
        sprite.name = "Meow Asada"
        sprite.size = CGSize (width: size, height: size)
        sprite.position = CGPoint(x: -180, y:-150)
        

        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Meow_0"), size: sprite.size)
        sprite.physicsBody?.allowsRotation = false

        sprite.physicsBody!.affectedByGravity = true
        midair = SKAction(named:"MeowMidair", duration: airTime)!
        rotate = SKAction(named:"MeowRotate", duration: rotationSpeed)!
    }
    
    func setSize(withSize: Double) {
        size = withSize
        sprite.size = CGSize (width: size, height: size)
        
        
    }
    
    func setAirTime (withTime: Double) {
        midair = SKAction(named:"MeowMidair", duration: withTime)!
        
    }
    
    func setRotationSpeed(withTime: Double) {
        if withTime < 0.12 {
            rotationSpeed = 0.18
        } else {
            rotationSpeed = withTime
        }
        rotate = SKAction(named:"MeowRotate", duration: rotationSpeed)!
        
    }
    
    func executeMove (withName: Move) {
        switch withName {
        case .lutzTakeoff:
            sprite.run(SKAction.sequence([lutzTakeoff,midair]))
        case .rotate :
            sprite.run(SKAction(named:"MeowRotate")!)
        case .backTurn :
            sprite.run(backTurn)
        case .landing :
            sprite.run(landing)
        default:
            sprite.run(SKAction(named:"MeowSkating")!)
        }
    }
    func setSpinTrans(spinType: Tech, stage: Int) {
        switch spinType {
        case .Layback:
            switch stage {
            case 0:
                
                spin = SKAction(named:"MeowCamelEntrance", duration: 0.3)!
            case 1:
                spin = SKAction(named:"MeowCamelEntrance", duration: 0.3)!

                
            case 2:
                spin = SKAction(named:"MeowSitSpinEntrance", duration: 0.3)!
                
            case 3:
                spin = SKAction(named:"MeowISpinEntrance", duration: 0.3)!
            case 4:
                spin = SKAction(named:"MeowISpin", duration: 0.3)!

                /*
            case 4:
                spin = SKAction(named:"CatokoLayback34", duration: 0.3)!
            case 5:
                spin = SKAction(named:"CatokoLayback4", duration: 0.3)!
 */
                
            default:
                spin = SKAction(named:"MeowISpinExit", duration: 0.3)!
                
            }
        case .ComboSpin:
            break
        default:
            break
        }
    }
    
    func setSpin(spinType: Tech, stage: Int)  -> Bool {
        switch spinType {
        case .Layback:
            switch stage {
                
                
            case 1:
                
                spin = SKAction.sequence([SKAction(named:"MeowCamelEntrance", duration: 0.3)!
, SKAction.repeatForever(SKAction(named:"MeowCamel", duration: rotationSpeed)!)])
                return false
                
                
            case 2:
                spin = SKAction.repeatForever(SKAction(named:"MeowISpinEntranceRotate", duration: rotationSpeed)!)
                return false

            case 3:
                spin =  SKAction.repeatForever(SKAction(named:"MeowISpin", duration: rotationSpeed)!)
                return false
                /*
            case 4:
                spin =  SKAction.repeatForever(SKAction(named:"MeowISpin", duration: 0.3)!)

   */
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
}
