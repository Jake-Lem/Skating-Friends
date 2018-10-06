//
//  Skater.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/11/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import Foundation
import SpriteKit
protocol Skater : class {
    var airTime : Double {get}
    var control : Double {get}
    var artistry : Double {get}
    var reputation : Double {get}
    
    var jumpHeight : Double {get}
    var sprite: SKSpriteNode { get }
    
    //distance as a fraction of image size from anchor point to foot area
    var footDiv : Double {get}
    
    
    var midair : SKAction! {get}
    var skating : SKAction{get}
    var backTurn : SKAction{get}
    var lutzTakeoff : SKAction{get}
    var flipTakeoff : SKAction{get}
    var loopTakeoff : SKAction{get}
    var toeTakeoff : SKAction{get}
    var salTakeoff : SKAction{get}
    var axelTakeoff : SKAction{get}
    var spiral : SKAction{get}
    var spiralEntrance : SKAction{get}
    var maxSpeed : Double{get}
    var landing : SKAction{get}
    var fall : SKAction{get}
    var rotate : SKAction!{get}
    var bow : SKAction{get}
    var spin : SKAction {get}
    var spinPower : Double {get}
    var spiralPower : Double {get}
    var skaterName : String{get}
    var upStep : SKAction{get}
    var leftStep : SKAction{get}

    var rightStep : SKAction{get}
    var downStep : SKAction{get}
    var jumpTrans : SKAction{get}
    var rotationSpeed : Double{get}
    init()
    
    func setSize(withSize: Double)
    func setSpinTrans(spinType: Tech, stage: Int)
    func setRotationSpeed(withTime: Double)
    func setSpin(spinType: Tech, stage: Int) -> Bool
    
    func executeMove(withName: Move)
    func setAirTime(withTime: Double)
    //func makeCat()
}
