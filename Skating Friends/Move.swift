//
//  Move.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/11/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import Foundation

enum Move : String {
    case lutzTakeoff
    case flipTakeoff
    case loopTakeoff
    case toeTakeoff
    case salTakeoff
    case axelTakeoff
    case skating
    case midair
    case rotate
    case fall
    case backTurn
    case landing
    case bow
    case layback
    case comboSpin
}

enum Tech : String {
    case Lutz
    case Flip
    case Loop
    case Toe
    case Salchow
    case Axel
    case Steps
    case Layback
    case ComboSpin
    case Spiral
    case JumpCombo
    case None
}


enum Motion : String {
    case Skating
    case Spinning
    case Spiral
    case Midair
    case Stationary
    case Transition
    case Landing
}

enum Goal : String {
    case TechRun
    case TechTotal
    case CoinsRun
    case CoinsTotal
    case ItemsRun
    case ItemsTotal
    case ObstaclesRun
    case ObstaclesTotal
    case DoublesRun
    case DoublesTotal
    case TriplesRun
    case TriplesTotal
    case QuadsRun
    case QuadsTotal
    case DoubleCombo
    case TriplesCombo
    case QuadCombo
    case SpinsRun
    case SpinsTotal
    case SpiralsRun
    case SpiralsTotal
    
    case Blank
}
