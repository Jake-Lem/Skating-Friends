//
//  Skater.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/11/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import Foundation
import SpriteKit


class Catoko : Skater {
    
    var spinPower: Double = 5
    var spiralPower : Double = 5
    var artistry: Double = 10
    var reputation: Double = 10
    var rotationSpeed: Double = 0.26
    var size : Double = 225
    var airTime : Double = 0.9
    var jumpHeight : Double = 130
    var control : Double = 0.9
    var maxSpeed : Double = 1800

    var sprite = SKSpriteNode(imageNamed: "Catoko_0")
    var midair: SKAction!
    var rotate : SKAction!

    let skaterName = "Catoko Meowahara"
    
    
    var upStep = SKAction(named:"CatokoTwizzle", duration: 0.45)!
    var spiral = SKAction(named:"CatokoSpiral", duration: 1.5)!
    var spiralEntrance = SKAction(named:"CatokoSpiralEntrance", duration: 0.2)!

    var leftStep = SKAction.sequence([SKAction(named:"CatokoBackTurn", duration: 0.3)!, SKAction(named:"CatokoBackSkate", duration: 0.3)!, SKAction(named:"CatokoBackTurn", duration: 0.3)!.reversed()])
    var rightStep = SKAction(named:"CatokoSkating")!
    var downStep = SKAction.sequence([SKAction(named:"CatokoBackTurn", duration: 0.3)!, SKAction(named:"CatokoBackSkate", duration: 0.3)!, SKAction(named:"CatokoBackTurn", duration: 0.3)!.reversed()])
    let skating = SKAction(named:"CatokoSkating")!
    let backTurn = SKAction(named:"CatokoBackTurn", duration: 0.3)!
    let lutzTakeoff = SKAction(named:"CatokoLutz", duration: 0.2)!
    let flipTakeoff = SKAction(named:"CatokoLutz", duration: 0.2)!
    let loopTakeoff = SKAction(named:"CatokoLoop", duration: 0.2)!
    let toeTakeoff = SKAction(named:"CatokoToe", duration: 0.2)!
    let salTakeoff = SKAction(named:"CatokoSal", duration: 0.2)!
    let axelTakeoff = SKAction(named:"CatokoAxel", duration: 0.2)!
    var spin = SKAction(named:"MeowSpiral", duration: 1.5)!
    var footDiv: Double = 3

    let landing = SKAction(named:"CatokoLanding", duration: 0.5)!
    let fall = SKAction(named:"CatokoFall", duration: 1)!
    let bow = SKAction(named:"CatokoBow", duration: 2)!
    let jumpTrans = SKAction(named:"CatokoRotate", duration: 0)!
    
    required init () {
        sprite.name = "Catoko Meowahara"
        sprite.size = CGSize (width: size, height: size)
        sprite.position = CGPoint(x: -200, y:-200 )
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Catoko_5"), size: sprite.size)
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody!.affectedByGravity = true

        midair = SKAction(named:"CatokoMidair", duration: airTime)!
        rotate = SKAction(named:"CatokoRotate", duration: rotationSpeed)!

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
        rotate = SKAction(named:"CatokoRotate", duration: rotationSpeed)!
        
    }
    
    func setAirTime (withTime: Double) {
        midair = SKAction(named:"CatokoMidair", duration: withTime)!

    }
    
    func setSpinTrans(spinType: Tech, stage: Int) {
        switch spinType {
        case .Layback:
            switch stage {
            case 0:
                spin = SKAction(named:"CatokoLaybackEntrance")!
                print("0")

            case 1:
                spin = SKAction(named:"CatokoLaybackEntrance")!
                print("1")

            case 2:
                let trans = SKAction(named:"CatokoLayback2", duration: 0.3)!
                spin = trans
            case 3:
                spin = SKAction(named:"CatokoLayback23", duration: 0.3)!
            case 4:
                spin = SKAction(named:"CatokoLayback34", duration: 0.3)!
            case 5:
                spin = SKAction(named:"CatokoLayback4", duration: 0.3)!

            default:
                print("EXIt")
                spin = SKAction(named:"CatokoSpinExit", duration: 0.3)!

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
                
                spin = SKAction.sequence([SKAction(named:"CatokoLaybackEntrance")!, SKAction.repeatForever(SKAction(named:"CatokoLayback1", duration: 0.3)!)])
                return false

            case 2:
                spin = SKAction.repeatForever(SKAction(named:"CatokoLayback2", duration: 0.3)!)

                return false
            case 3:
                spin =  SKAction.repeatForever(SKAction(named:"CatokoLayback3", duration: 0.3)!)
                return false
            case 4:
                spin = SKAction.repeatForever(SKAction(named:"CatokoLayback4", duration: 0.3)!)
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
