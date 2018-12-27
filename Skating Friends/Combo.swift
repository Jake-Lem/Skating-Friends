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


class Combo : Element {
    var combo : [Element] = []
    var full = false
    override func toString() -> String {
        var firstEl = ""
        if combo.count > 0 {
            firstEl = combo[0].toString()
        }
        /*
        if combo.count > 0 {
            firstEl = combo[0].toString()
            if combo.count > 1 {
       
                secondEl = " + " + combo[1].toString()
                if combo.count > 2 {
                    thirdEl = " + " + combo[2].toString()
                    
                }

            }
        }
        return firstEl + secondEl + thirdEl*/
        var count = 0
        for el in combo {
            if count == 0 {
                count += 1

                continue
            }
            
            
            
            firstEl += " + " + el.toString()
            
            if count % 3 == 0 {
                firstEl += "\n"
            }
            
            count += 1

        }
        
        return firstEl
    }
    
    init(firstEl: Element) {
        super.init(ofType: Tech.JumpCombo, withSpeed: firstEl.catSpeed, bySkater: firstEl.theSkater)
        
        combo.append(firstEl)
    }

    
    override func calcScore() {
        seeFall()
        score = 0
        for elem in combo {
            elem.calcScore()
            score += elem.score
        }
    }
    
    func seeFall() {
        fall = combo[combo.count - 1].fall
    }
    
    func clear() {
        combo.removeAll()
    }
    
    
    func addMove(withEl: Element) {
        combo.append(withEl)
        if combo.count > 2 {
            full = true
        }
    }
    
}
