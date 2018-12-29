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


class Collectible : SKSpriteNode {
   var collected = false
   var itemSpeed = 0

}


enum Item : String {
    case Coin
    case Koi
    case Pineapple
    case Butterfly
    case Banana
    
}
