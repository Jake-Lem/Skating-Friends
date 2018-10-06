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


class Element {
    var score : Double = 0
    var theSkater : Skater!
    var base : Double = 0
    var goe : Double = 0
    var rotations = 0
    var fall = false
    var type : Tech = Tech.None
    var catSpeed : Double = 0
    var difficulty : Double = 1
    var level = 0
    var bonus : Double = 0
    var multiplier : Double = 1
    
    init(ofType: Tech) {
        type = ofType
        calcDifficulty()
    }
    
    init(ofType: Tech, bySkater: Skater) {
        type = ofType
        theSkater = bySkater
        calcDifficulty()
    }
    
    init(ofType: Tech, withSpeed: Double, bySkater: Skater) {
        type = ofType
        catSpeed = withSpeed
        theSkater = bySkater
        calcDifficulty()

    }
    
    /*func makeElement(ofType: Tech, withRotations: Int) {
        type = ofType
        rotations = withRotations
    }
    
    func makeElement(ofType: Tech, withFall: Bool) {
        type = ofType
        fall = withFall
    }*/
    func calcDifficulty() {
        switch type {
        case .Toe:
            difficulty = 1
            
        case .Salchow:
            difficulty = 1.05

        case .Loop:
            difficulty = 1.1
            
        case .Flip:
            difficulty = 1.15
            
        case .Lutz:
            difficulty = 1.18

        case .Axel:
            difficulty = 1.3

        default:
            break
    }
    }
    
    
    
    func toString() -> String {
        var numRots = ""
        let elType = type.rawValue
        if rotations == 1 {
            numRots = "1"
        }
        if rotations == 2 {
            numRots = "2"
        }
        if rotations == 3 {
            numRots = "3"
        }
        if rotations == 4 {
            numRots = "4"

        }
        switch type {
        case .Lutz, .Loop, .Axel, .Salchow, .Toe, .Flip:
        return numRots + " " + elType
        default:
            return elType
        }
    }
    
    func addRotation() {
        rotations += 1
    }
    
    func addLevel() {
        level += 1
    }
    
    func addFall() {
        fall = true
    }
    
    func baseVal() {
        var calculator : Double = 0
        switch type {
        case .Lutz:
            switch rotations {
            case 0:
                calculator += 0
            case 1:
                calculator += 0.6
                
            case 2:
                calculator += 2.1
                
            case 3:
                calculator += 6
            case 4:
                calculator += 11.5
            default:
                break
            }
            
        case .Flip:
            switch rotations {
            case 0:
                calculator += 0
            case 1:
                calculator += 0.5
                
            case 2:
                calculator += 1.8
                
            case 3:
                calculator += 5.3
            case 4:
                calculator += 11.0
            default:
                break
            }
            
        case .Salchow:
            switch rotations {
            case 0:
                calculator += 0
            case 1:
                calculator += 0.4
                
            case 2:
                calculator += 1.3
                
            case 3:
                calculator += 4.2
            case 4:
                calculator += 9.7
            default:
                break
            }
            
            
        case .Toe:
            switch rotations {
            case 0:
                calculator += 0
            case 1:
                calculator += 0.4
                
            case 2:
                calculator += 1.2
                
            case 3:
                calculator += 4
            case 4:
                calculator += 9.5
            default:
                break
            }
            
        case .Loop:
            switch rotations {
            case 0:
                calculator += 0
            case 1:
                calculator += 0.5
                
            case 2:
                calculator += 1.8
                
            case 3:
                calculator += 5.1
            case 4:
                calculator += 10.5
            default:
                break
            }
            
            
        case .Axel:
            switch rotations {
            case 0:
                calculator += 0
            case 1:
                calculator += 1.1
                
            case 2:
                calculator += 3.3
                
            case 3:
                calculator += 8.0
            case 4:
                calculator += 12.5
            default:
                break
            }
            
        case .Layback:
            switch level {
            case 0:
                calculator += 0
            case 1:
                calculator += 1.2
                
            case 2:
                calculator += 2.2
                
            case 3:
                calculator += 3.2
            case 4:
                calculator += 4.2
            default:
                if level > 4 {
                    calculator += 4.2
                }
            }
        default:
            break
        }
        
        
        calculator = Double(round(100*calculator)/100)
        base = calculator

    }
    
    
    func calcGoe() {
        
        switch type {
        case .Axel, .Loop, .Salchow, .Lutz, .Flip, .Toe:
                if catSpeed <= 200 {
                    goe += -3
            }
                if catSpeed > 200 && catSpeed <= 400 {
                    goe += -2
            }
            
                if catSpeed > 400 && catSpeed <= 600 {
                    goe += -1
            }
            
                if catSpeed > 600 && catSpeed <= 800 {
                    goe += 0
            }
            
                if catSpeed > 800 && catSpeed <= 1000 {
                    goe += 1
            }
                if catSpeed > 800 && catSpeed <= 1000 {
                    goe += 2
            }
            
                if catSpeed > 1000 {
                    goe += 3
            }
            
                
                if theSkater.jumpHeight <= 100 {
                    goe += 0
                }
                
                if theSkater.jumpHeight > 100 && theSkater.jumpHeight < 150 {
                    goe += 1
                }
                if theSkater.jumpHeight > 150 && theSkater.jumpHeight < 200  {
                    goe += 2
                }
                if theSkater.jumpHeight > 200  {
                    goe += 3
            }
        case .Layback:
            goe = theSkater.spinPower
        default:
            break
        }
        
        
        
        
        if fall {
            goe = -5
            score -= 1.0
        }

        if goe < -5 {
            goe = -5
        }
        
        if goe > 5 {
            goe = 5
        }
        
        //score += score * factor
        
    }
    
    func addBonus(byNum : Double) {
        bonus += byNum
    }
    
    func setBonus(withNum : Double) {
        bonus = withNum
    }
    
    func setMultiplier(withNum : Double) {
        multiplier = withNum
    }
    
    func calcScore() {
        baseVal()
        calcGoe()
        

        let factor = 0.1 * Double(goe)
        score = (base + base * factor + bonus) * multiplier
        /*
        print("base: \(base)")
        print("goe: \(goe)")
        print("score: \(score)")
        print("catSpeed \(catSpeed)")*/
    }
    
}
