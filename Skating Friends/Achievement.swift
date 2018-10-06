//
//  Achievement.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 8/24/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import Foundation


class Achievement: NSObject, NSCoding {
    
    
    
    
    var completed = false
    
    var runSpecific: Bool
    
    var text: String = ""
    
    var level: Int!
    
    var goalType: Goal
    
    var itemType : Item?
    var currTotal = 0
    var savedTotal = 0
    var requirement = 0
    
    
    init(withType: Goal, withLevel: Int, isRunSpecific: Bool) {
        
        goalType = withType
        level = withLevel
        runSpecific = isRunSpecific
        
        super.init()
        
        setRequirement()
        generateText()
        itemType = .Banana
        
    }
    
    init(withType: Goal, withLevel: Int, isRunSpecific: Bool, withItem: Item) {
        
        goalType = withType
        level = withLevel
        runSpecific = isRunSpecific
        itemType = withItem
        
        super.init()
        
        setRequirement()
        generateText()
    }
    
    init(withType: Goal, withLevel: Int, isRunSpecific: Bool, withItem: Item, forSavedTotal: Int, isComplete: Bool) {
        
        goalType = withType
        level = withLevel
        runSpecific = isRunSpecific
        itemType = withItem
        savedTotal = forSavedTotal
        completed = isComplete
        super.init()
        
        setRequirement()
        generateText()
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        let completed = aDecoder.decodeBool(forKey: "completed")
        let runSpecific = aDecoder.decodeBool(forKey: "runSpecific")
        //let text = aDecoder.decodeObject(forKey: "text") as! String
        let level = aDecoder.decodeInteger(forKey: "level")
        let goalType = aDecoder.decodeObject(forKey: "goal") as! String
        let item = aDecoder.decodeObject(forKey: "item") as! String
        let savedTotal = aDecoder.decodeInteger(forKey: "savedTotal")
        self.init(withType: Goal(rawValue: goalType)!, withLevel: level, isRunSpecific: runSpecific, withItem: Item(rawValue: item)!, forSavedTotal: savedTotal, isComplete: completed)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(completed, forKey: "completed")
        aCoder.encode(runSpecific, forKey: "runSpecific")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(level!, forKey: "level")
        aCoder.encode(goalType.rawValue, forKey: "goal")
        aCoder.encode(itemType?.rawValue, forKey: "item")
        aCoder.encode(savedTotal, forKey: "savedTotal")
        
    }
    
    
    func reset() {
        if runSpecific {
            currTotal = 0
        }
    }
    
    func setRequirement() {
        switch goalType {
        case .DoubleCombo :
            switch level {
            case 1:
                requirement = 2
            case 2:
                requirement = 3
            case 3:
                requirement = 4
            case 4:
                requirement = 6
            case 5:
                requirement = 8
            case 6:
                requirement = 12
            default:
                break
            }
            
        case .DoublesRun :
            switch level {
            case 1:
                requirement = 1
            case 2:
                requirement = 3
            case 3:
                requirement = 6
            case 4:
                requirement = 12
            case 5:
                requirement = 30
            case 6:
                requirement = 50
            default:
                break
            }
            
        case .DoublesTotal :
            switch level {
            case 1:
                requirement = 10
            case 2:
                requirement = 20
            case 3:
                requirement = 50
            case 4:
                requirement = 100
            case 5:
                requirement = 150
            case 6:
                requirement = 300
            default:
                break
            }
            
        case .TriplesCombo:
            switch level {
            case 1:
                requirement = 2
            case 2:
                requirement = 3
            case 3:
                requirement = 4
            case 4:
                requirement = 5
            case 5:
                requirement = 6
            case 6:
                requirement = 8
            default:
                break
            }
            
        case .TriplesRun :
            switch level {
            case 1:
                requirement = 1
            case 2:
                requirement = 3
            case 3:
                requirement = 6
            case 4:
                requirement = 12
            case 5:
                requirement = 24
            case 6:
                requirement = 36
            default:
                break
            }
            
            
        case .TriplesTotal :
            switch level {
            case 1:
                requirement = 10
            case 2:
                requirement = 30
            case 3:
                requirement = 75
            case 4:
                requirement = 150
            case 5:
                requirement = 300
            case 6:
                requirement = 500
            default:
                break
            }
            
        case .QuadsRun:
            switch level {
            case 1:
                requirement = 1
            case 2:
                requirement = 3
            case 3:
                requirement = 6
            case 4:
                requirement = 12
            case 5:
                requirement = 18
            case 6:
                requirement = 24
            default:
                break
            }
            
        case .QuadCombo :
            switch level {
            case 1:
                requirement = 1
            case 2:
                requirement = 2
            case 3:
                requirement = 3
            case 4:
                requirement = 4
            default:
                break
            }
            
            
        case .QuadsTotal :
            switch level {
            case 1:
                requirement = 10
            case 2:
                requirement = 15
            case 3:
                requirement = 30
            case 4:
                requirement = 60
            case 5:
                requirement = 120
            case 6:
                requirement = 200
            default:
                break
            }
            
        case .SpinsRun :
            switch level {
            case 1:
                requirement = 1
            case 2:
                requirement = 2
            case 3:
                requirement = 5
            case 4:
                requirement = 8
            case 5:
                requirement = 12
            case 6:
                requirement = 20
            default:
                break
            }
            
        case .CoinsRun :
            switch level {
            case 1:
                requirement = 50
            case 2:
                requirement = 100
            case 3:
                requirement = 500
            case 4:
                requirement = 1000
            case 5:
                requirement = 2000
            default:
                break
            }
            
        case .CoinsTotal :
            switch level {
            case 1:
                requirement = 500
            case 2:
                requirement = 1000
            case 3:
                requirement = 5000
            case 4:
                requirement = 10000
            case 5:
                requirement = 30000
            case 6:
                requirement = 50000
            default:
                break
            }
            
        case .ItemsRun :
            switch level {
            case 1:
                requirement = 1
            case 2:
                requirement = 3
            case 3:
                requirement = 5
            case 4:
                requirement = 10
            case 5:
                requirement = 20
            case 6:
                requirement = 40
            default:
                break
            }
            
        case .ItemsTotal :
            switch level {
            case 1:
                requirement = 40
            case 2:
                requirement = 125
            case 3:
                requirement = 250
            case 4:
                requirement = 500
            case 5:
                requirement = 700
            case 6:
                requirement = 1000
            default:
                break
            }
        case .ObstaclesRun :
            switch level {
            case 1:
                requirement = 1
            case 2:
                requirement = 2
            case 3:
                requirement = 5
            case 4:
                requirement = 8
            case 5:
                requirement = 12
            case 6:
                requirement = 20
            default:
                break
            }
            
        case .ObstaclesTotal :
            switch level {
            case 1:
                requirement = 1
            case 2:
                requirement = 2
            case 3:
                requirement = 5
            case 4:
                requirement = 8
            case 5:
                requirement = 12
            case 6:
                requirement = 20
            default:
                break
            }
            
            default:
            break
        
        }
    }
    
        func makeComboString(elType: String) -> String {
            return String(format: "Perform %d %@ in one combination", requirement, elType)
        }
        
        func makeRunString(elType: String) -> String {
            return String(format: "Perform %d %@ in one run", requirement, elType)
        }
        
        func makeTotalString(elType: String) -> String {
            return String(format: "Perform %d %@ in total. %d to go!", requirement, elType, requirement - currTotal - savedTotal)
        }
    
    
    func makeCollectRunString(itemType: String) -> String {
        return String(format: "Collect %d %@ in one run", requirement, itemType)
    }
    
    func makeCollectTotalString(itemType: String) -> String {
        return String(format: "Collect %d %@ in total. %d to go!", requirement, itemType, requirement - currTotal - savedTotal)
    }
        
    func generateText() {
        switch goalType {
       
        case .DoubleCombo :
            text = makeComboString(elType: "Double jumps")
        case .DoublesRun :
            text = makeRunString(elType: "Double jumps")
        case .DoublesTotal :
            text = makeTotalString(elType: "Double jumps")
        case .QuadCombo :
            text = makeComboString(elType: "Quad jumps")
        case .QuadsRun :
            text = makeRunString(elType: "Quad jumps")
        case .QuadsTotal :
            text = makeTotalString(elType: "Quad jumps")
        case .SpinsRun :
            text = makeRunString(elType: "Spins")
        case .SpinsTotal :
            text = makeTotalString(elType: "Spins")
        case .SpiralsRun :
            text = makeRunString(elType: "Spiral Sequences")
        case .SpiralsTotal :
            text = makeTotalString(elType: "Spiral Sequences")
        case .TechRun :
            text = String(format: "Score %d technical points in one run", requirement)
        case .TechTotal :
            text = String(format: "Score %d technical points in total", requirement)
        case .TriplesCombo :
            text = makeComboString(elType: "Triple jumps")
        case .TriplesRun :
            text = makeRunString(elType: "Triple jumps")
        case .TriplesTotal :
            text = makeTotalString(elType: "Triple jumps")
        case .CoinsTotal:
            text = makeCollectTotalString(itemType: "Coins")
         
        case .CoinsRun:
            text = makeCollectRunString(itemType: "Coins")
            
        case .ItemsTotal:
            switch itemType! {
            case .Koi:
                text = makeCollectTotalString(itemType: "Kois")
            case .Butterfly:
                text = makeCollectTotalString(itemType: "Butterflies")
            case .Pineapple:
                text = makeCollectTotalString(itemType: "Pineapples")
            default:
                break
                
            }
        case .ItemsRun:
            switch itemType! {
            case .Koi:
                text = makeCollectRunString(itemType: "Kois")
            case .Butterfly:
                text = makeCollectRunString(itemType: "Butterflies")
            case .Pineapple:
                text = makeCollectRunString(itemType: "Pineapples")
            default:
                break
                
            }
            
        case .ObstaclesTotal:
            switch itemType! {
            case .Banana:
                text = String(format: "Smash %d bananas in total. %d to go!", requirement, requirement - currTotal - savedTotal)
            default:
                break
            }

            
        case .ObstaclesRun:
            switch itemType! {
            case .Banana:
                text = String(format: "Smash %d bananas in one run.", requirement)
            default:
                break
            }
            
            
        default :
            break
        }
    }
    
    func updateTotal(fromScoresheet: [Element]) {
        
        switch goalType {
            
        case .DoubleCombo :
            currTotal = checkLastJump(theScoresheet: fromScoresheet, numRots: 2)
        case .DoublesRun, .DoublesTotal :
            currTotal += checkLastJump(theScoresheet: fromScoresheet, numRots: 2)
        case .QuadCombo :
            currTotal = checkLastJump(theScoresheet: fromScoresheet, numRots: 4)
        case .QuadsRun, .QuadsTotal :
            currTotal += checkLastJump(theScoresheet: fromScoresheet, numRots: 4)
        case .SpinsRun, .SpinsTotal :
            currTotal += checkLastSpin(theScoresheet: fromScoresheet)
        case .SpiralsRun, .SpiralsTotal :
            currTotal += checkLastSpiral(theScoresheet: fromScoresheet)
        case .TechRun :
            text = String(format: "Score %d technical points in one run", requirement)
        case .TechTotal :
            text = String(format: "Score %d technical points in one total", requirement)
        case .TriplesCombo :
            currTotal = checkLastJump(theScoresheet: fromScoresheet, numRots: 3)
        case .TriplesRun, .TriplesTotal :
            currTotal += checkLastJump(theScoresheet: fromScoresheet, numRots: 3)
            
        default :
            break
        }
        checkCompletion()
        generateText()
        print("saved total:" + String(savedTotal))
        print("saved total + currtotal: " + String(currTotal + savedTotal))
    }
    
    func updateTotal(bananas: Int, kois: Int, butterflies: Int, pineapples: Int, coins: Int) {
        switch goalType {
            
        case .ItemsTotal, .ItemsRun, .ObstaclesTotal, .ObstaclesRun :
            switch itemType! {
            case .Banana:
                 currTotal = bananas
            case .Koi:
                currTotal = kois
            case .Butterfly:
                currTotal = butterflies
            case .Pineapple:
                currTotal = pineapples
            default:
                break
                
            }
            
        case .CoinsTotal, .CoinsRun :
            currTotal = coins
            
        default :
            break
        }
        checkCompletion()
        generateText()
    }
    
    func checkCompletion() {
        if completed {
            return
        }
        if currTotal + savedTotal >= requirement {
            completed = true
        }
    }
    
    func countJumps(theScoresheet: [Element], numRots: Int) -> Int {
        var counter = 0
        for el in theScoresheet {
            
            if el.type == .JumpCombo {
                let theCombo = el as! Combo
                
                for jump in theCombo.combo {
                    if jump.rotations == numRots {
                        counter += 1
                    }
                }
            }
        }
        return counter
    }
        
    func checkLastJump(theScoresheet: [Element], numRots: Int) -> Int {
            var counter = 0
            let el = theScoresheet.last
            if el == nil {
                return 0

            }
            if el?.type == .JumpCombo {
                let theCombo = el as! Combo
                
                for jump in theCombo.combo {
                    if jump.rotations == numRots {
                        counter += 1
                    }
                }
            }
            
            return counter
        }
    
    func checkLastSpin(theScoresheet: [Element]) -> Int {
        let el = theScoresheet.last
        if el == nil {
            return 0
        }
        if el?.type == .Layback {
            return 1
        }
        
        return 0
    }
    
    
    func checkLastSpiral(theScoresheet: [Element]) -> Int {
        let el = theScoresheet.last
        if el == nil {
            return 0
        }
        if el?.type == .Spiral {
            return 1
        }
        
        return 0
    }
    
    }
