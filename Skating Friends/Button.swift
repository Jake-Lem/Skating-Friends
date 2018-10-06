//
//  Skater.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/11/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import Foundation
import SpriteKit


class Button {
    
    var sprite : SKSpriteNode
    var clicked = false
    var action : SKAction
    var reverseAction : SKAction

    
    init (theSprite: SKSpriteNode, theAction: SKAction) {
        sprite = theSprite
        action = theAction
        reverseAction = theAction.reversed()
    }
    
    init (theSprite: SKSpriteNode, theAction: SKAction, theReverse: SKAction) {
        sprite = theSprite
        action = theAction
        reverseAction = theReverse
    }
    
    func unclick () {
        if clicked {
            sprite.run(reverseAction)
            clicked = false
        }
    }
    
    func click () {
        if clicked {
            sprite.run(reverseAction)
            clicked = false
        } else {
            sprite.run(action)
            clicked = true
        }
    }
    
  
}
