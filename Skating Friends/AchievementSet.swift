//
//  AchievementSet.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 8/24/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import Foundation

class AchievementSet {
    let defaults = UserDefaults.standard
    
    var set : [Achievement] = []
    var completed = false
    var game : GameScene?
    var achievementDict : Dictionary = [Int : goalSet]()
    
    func checkComplete () {
        var isComplete = true
        for el in set {
            isComplete = isComplete && el.completed
        }
        completed = isComplete
    }

    
    struct goalSet {
        var types : [Goal]
        var levels : [Int]
        var runSpecifics : [Bool]
        var items : [Item]
    }
    
    func setGameScene(theScene: GameScene) {
        game = theScene
    }
    
    func appendAchievementSet(goals: goalSet) {
        set.removeAll()
        let types = goals.types
        let levels = goals.levels
        let runSpecifics = goals.runSpecifics
        let items = goals.items
        
        set.append(Achievement(withType: types[0], withLevel: levels[0], isRunSpecific: runSpecifics[0], withItem: items[0]))
        set.append(Achievement(withType: types[1], withLevel: levels[1], isRunSpecific: runSpecifics[1], withItem: items[1]))
        set.append(Achievement(withType: types[2], withLevel: levels[2], isRunSpecific: runSpecifics[2], withItem: items[2]))
    }
    
    func generateGoals(forLevel: Int) {
        
        switch forLevel {
        case 1:
            set.removeAll()
            set.append(Achievement(withType: .DoublesTotal, withLevel: 1, isRunSpecific: false))
            set.append(Achievement(withType: .ItemsRun, withLevel: 1, isRunSpecific: true, withItem: .Butterfly))
//            set.append(Achievement(withType: .Blank, withLevel: 1, isRunSpecific: true, withItem: .Butterfly, forSavedTotal: 0, isComplete: true))

            
        case 2:
            set.removeAll()
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 1, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .CoinsRun, withLevel: 1, isRunSpecific: true))

        case 3:
            set.removeAll()
            set.append(Achievement(withType: .DoublesRun, withLevel: 1, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .SpiralsRun, withLevel: 1, isRunSpecific: true))

        case 4:
            set.removeAll()
            set.append(Achievement(withType: .DoubleCombo, withLevel: 1, isRunSpecific: false))
            set.append(Achievement(withType: .SpinsTotal, withLevel: 1, isRunSpecific: false, withItem: .Banana))


        case 5:
            set.removeAll()
            set.append(Achievement(withType: .ObstaclesTotal, withLevel: 1, isRunSpecific: false, withItem: .Banana))
            set.append(Achievement(withType: .QuadsRun, withLevel: 1, isRunSpecific: true, withItem: .Banana))



            
        case 6:
            set.removeAll()
            set.append(Achievement(withType: .TriplesRun, withLevel: 1, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .SpinsRun, withLevel: 1, isRunSpecific: true, withItem: .Banana))


            
        case 7:
            set.removeAll()
            set.append(Achievement(withType: .QuadsTotal, withLevel: 1, isRunSpecific: false))
            set.append(Achievement(withType: .TriplesCombo, withLevel: 1, isRunSpecific: true))

            

        case 8:
            set.removeAll()
            set.append(Achievement(withType: .DoublesTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .DoubleCombo, withLevel: 2, isRunSpecific: true))
            
            
        case 9:
            set.removeAll()
            set.append(Achievement(withType: .DoublesRun, withLevel: 2, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .SpinsTotal, withLevel: 2, isRunSpecific: false, withItem: .Banana))

        case 10:
            set.removeAll()
            set.append(Achievement(withType: .QuadsTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .SpinsRun, withLevel: 2, isRunSpecific: true, withItem: .Banana))

            
        case 11:
            set.removeAll()
            set.append(Achievement(withType: .CoinsTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .TriplesRun, withLevel: 2, isRunSpecific: true, withItem: .Banana))

        case 12:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .SpiralsTotal, withLevel: 2, isRunSpecific: false))

            
        case 13:
            set.removeAll()
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 2, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .CoinsTotal, withLevel: 1, isRunSpecific: false))

        case 14:
            set.removeAll()
            set.append(Achievement(withType: .ItemsTotal, withLevel: 1, isRunSpecific: false))
            set.append(Achievement(withType: .TriplesCombo, withLevel: 2, isRunSpecific: true))

            
        case 15:
            set.removeAll()
            set.append(Achievement(withType: .ObstaclesTotal, withLevel: 2, isRunSpecific: false, withItem: .Banana))
            set.append(Achievement(withType: .SpiralsTotal, withLevel: 1, isRunSpecific: false))

        case 16:
            set.removeAll()
            set.append(Achievement(withType: .DoublesTotal, withLevel: 3, isRunSpecific: false))
            set.append(Achievement(withType: .SpinsRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))

            
        case 17:
            set.removeAll()
            set.append(Achievement(withType: .TechRun, withLevel: 1, isRunSpecific: true))
            set.append(Achievement(withType: .SpiralsTotal, withLevel: 3, isRunSpecific: false))


        case 18:
            set.removeAll()
            set.append(Achievement(withType: .CoinsRun, withLevel: 2, isRunSpecific: true))
            set.append(Achievement(withType: .QuadsRun, withLevel: 2, isRunSpecific: true, withItem: .Banana))

            
        case 19:
            set.removeAll()
            set.append(Achievement(withType: .DoubleCombo, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .TriplesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))

            
        case 20:
            set.removeAll()
            set.append(Achievement(withType: .ItemsRun, withLevel: 2, isRunSpecific: true, withItem: .Koi))
            set.append(Achievement(withType: .TechTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .TechRun, withLevel: 2, isRunSpecific: true))


            
        case 21:
            set.removeAll()
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .SpiralsTotal, withLevel: 4, isRunSpecific: false))
            set.append(Achievement(withType: .TriplesTotal, withLevel: 1, isRunSpecific: false))

            
        case 23:
            set.removeAll()
            set.append(Achievement(withType: .CoinsRun, withLevel: 3, isRunSpecific: true))
            set.append(Achievement(withType: .ObstaclesTotal, withLevel: 3, isRunSpecific: false, withItem: .Banana))
            set.append(Achievement(withType: .TechTotal, withLevel: 1, isRunSpecific: false))


            
        case 24:
            set.removeAll()
            set.append(Achievement(withType: .CoinsTotal, withLevel: 3, isRunSpecific: false))
            set.append(Achievement(withType: .QuadsRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .SpiralsRun, withLevel: 2, isRunSpecific: true))


            
        case 25:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 3, isRunSpecific: false))
            set.append(Achievement(withType: .DoublesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .SpiralsRun, withLevel: 3, isRunSpecific: true))


        case 26:
            set.removeAll()
            set.append(Achievement(withType: .ItemsTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .TriplesCombo, withLevel: 3, isRunSpecific: true))
            set.append(Achievement(withType: .SpinsRun, withLevel: 4, isRunSpecific: true, withItem: .Banana))


        case 27:
            set.removeAll()
            set.append(Achievement(withType: .TriplesRun, withLevel: 4, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .SpiralsTotal, withLevel: 5, isRunSpecific: false))
            set.append(Achievement(withType: .SpiralsRun, withLevel: 4, isRunSpecific: true))


        case 28:
            set.removeAll()
            set.append(Achievement(withType: .ObstaclesTotal, withLevel: 4, isRunSpecific: false, withItem: .Banana))
            set.append(Achievement(withType: .SpinsTotal, withLevel: 3, isRunSpecific: false, withItem: .Banana))
            set.append(Achievement(withType: .DoublesTotal, withLevel: 4, isRunSpecific: false))


        case 29:
            set.removeAll()
            set.append(Achievement(withType: .TechTotal, withLevel: 3, isRunSpecific: false))
            set.append(Achievement(withType: .QuadsTotal, withLevel: 3, isRunSpecific: false))

            set.append(Achievement(withType: .SpiralsRun, withLevel: 6, isRunSpecific: true))

        case 30:
            set.removeAll()
            set.append(Achievement(withType: .ItemsRun, withLevel: 3, isRunSpecific: true, withItem: .Butterfly))
            set.append(Achievement(withType: .CoinsTotal, withLevel: 4, isRunSpecific: false))
            set.append(Achievement(withType: .TriplesCombo, withLevel: 4, isRunSpecific: true))


            
        case 31:
            set.removeAll()
            set.append(Achievement(withType: .DoubleCombo, withLevel: 4, isRunSpecific: false))
            set.append(Achievement(withType: .ItemsTotal, withLevel: 3, isRunSpecific: false))
            set.append(Achievement(withType: .SpinsRun, withLevel: 5, isRunSpecific: true, withItem: .Banana))

            
        case 32:
            set.removeAll()
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 4, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .TriplesRun, withLevel: 5, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .SpiralsRun, withLevel: 5, isRunSpecific: true))

        case 33:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 4, isRunSpecific: false))
            set.append(Achievement(withType: .DoublesRun, withLevel: 4, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .QuadCombo, withLevel: 1, isRunSpecific: false))

        case 34:
            set.removeAll()
            set.append(Achievement(withType: .TechRun, withLevel: 3, isRunSpecific: true))
            set.append(Achievement(withType: .SpiralsTotal, withLevel: 6, isRunSpecific: false))

            set.append(Achievement(withType: .QuadsRun, withLevel: 4, isRunSpecific: true, withItem: .Banana))



            
        case 35:
            set.removeAll()
            set.append(Achievement(withType: .TechTotal, withLevel: 4, isRunSpecific: false))
            set.append(Achievement(withType: .CoinsTotal, withLevel: 5, isRunSpecific: false))
            set.append(Achievement(withType: .TriplesCombo, withLevel: 5, isRunSpecific: true))


            
        case 36:
            set.removeAll()
            set.append(Achievement(withType: .ItemsRun, withLevel: 4, isRunSpecific: true, withItem: .Butterfly))
            set.append(Achievement(withType: .ItemsTotal, withLevel: 4, isRunSpecific: false))
            set.append(Achievement(withType: .SpinsTotal, withLevel: 4, isRunSpecific: false, withItem: .Banana))


        case 37:
            set.removeAll()
            set.append(Achievement(withType: .TechRun, withLevel: 4, isRunSpecific: true))
            set.append(Achievement(withType: .ObstaclesTotal, withLevel: 5, isRunSpecific: false, withItem: .Banana))
            set.append(Achievement(withType: .SpinsRun, withLevel: 6, isRunSpecific: true, withItem: .Banana))

            
        case 38:
            set.removeAll()
            set.append(Achievement(withType: .DoublesTotal, withLevel: 5, isRunSpecific: false))
            set.append(Achievement(withType: .CoinsTotal, withLevel: 6, isRunSpecific: false))
            set.append(Achievement(withType: .TriplesCombo, withLevel: 6, isRunSpecific: true))

            
        case 39:
            set.removeAll()
            set.append(Achievement(withType: .CoinsRun, withLevel: 4, isRunSpecific: true))
            set.append(Achievement(withType: .TechTotal, withLevel: 5, isRunSpecific: false))
            set.append(Achievement(withType: .QuadsTotal, withLevel: 4, isRunSpecific: false))


            
            
        case 40:
            set.removeAll()
            set.append(Achievement(withType: .DoubleCombo, withLevel: 5, isRunSpecific: true))
            set.append(Achievement(withType: .TriplesTotal, withLevel: 5, isRunSpecific: false))

            set.append(Achievement(withType: .QuadCombo, withLevel: 2, isRunSpecific: false))

        case 41:
            set.removeAll()
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 5, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .DoublesRun, withLevel: 5, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .SpinsTotal, withLevel: 5, isRunSpecific: false, withItem: .Banana))



            
        case 42:
            set.removeAll()
            set.append(Achievement(withType: .ItemsTotal, withLevel: 5, isRunSpecific: false))
            set.append(Achievement(withType: .QuadsTotal, withLevel: 5, isRunSpecific: false))

            set.append(Achievement(withType: .TechRun, withLevel: 5, isRunSpecific: true))

            
        case 43:
            set.removeAll()
            set.append(Achievement(withType: .ItemsRun, withLevel: 5, isRunSpecific: true, withItem: .Butterfly))
            set.append(Achievement(withType: .DoublesTotal, withLevel: 6, isRunSpecific: false))
            set.append(Achievement(withType: .TriplesRun, withLevel: 6, isRunSpecific: true, withItem: .Banana))

        case 44:
            set.removeAll()
            set.append(Achievement(withType: .DoubleCombo, withLevel: 6, isRunSpecific: false))
            set.append(Achievement(withType: .QuadsRun, withLevel: 5, isRunSpecific: true, withItem: .Banana))


        case 45:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 6, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesTotal, withLevel: 5, isRunSpecific: false, withItem: .Banana))


            
        case 46:
            set.removeAll()
            set.append(Achievement(withType: .CoinsRun, withLevel: 5, isRunSpecific: true))
            set.append(Achievement(withType: .DoublesRun, withLevel: 6, isRunSpecific: true, withItem: .Banana))

            
        case 47:
            set.removeAll()
            set.append(Achievement(withType: .TechRun, withLevel: 6, isRunSpecific: true))
            set.append(Achievement(withType: .QuadsTotal, withLevel: 6, isRunSpecific: false))
            set.append(Achievement(withType: .SpinsTotal, withLevel: 6, isRunSpecific: false, withItem: .Banana))


            
        case 48:
            set.removeAll()
            set.append(Achievement(withType: .ItemsRun, withLevel: 6, isRunSpecific: true, withItem: .Butterfly))
            set.append(Achievement(withType: .ItemsTotal, withLevel: 6, isRunSpecific: false))

            
        case 49:
            set.removeAll()
            set.append(Achievement(withType: .TechTotal, withLevel: 6, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 6, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .QuadsRun, withLevel: 6, isRunSpecific: true, withItem: .Banana))

            

        case 50:
            set.removeAll()
            set.append(Achievement(withType: .CoinsRun, withLevel: 6, isRunSpecific: true))
            set.append(Achievement(withType: .QuadCombo, withLevel: 3, isRunSpecific: false))


        default:
            set.removeAll()
            set.append(Achievement(withType: .TechTotal, withLevel: 6, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 6, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .QuadsRun, withLevel: 6, isRunSpecific: true, withItem: .Banana))

        }
        
        
    }
    
    func makeNewSet(level: Int) {
        generateGoals(forLevel: level)
        print("new")
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: set)
        defaults.set(encodedData, forKey: "Achievements")
        defaults.synchronize()
    }
    
    func resetGoals() {
        let theLevel = defaults.integer(forKey: "PlayerLevel")
        makeNewSet(level: theLevel)
    }
    
    func incLevel() -> Bool {
        checkComplete()
        var levelUp = false
        if defaults.integer(forKey: "PlayerLevel") == 0 {
            defaults.set(1, forKey: "PlayerLevel")
        }
        if completed {
            let currLevel = defaults.integer(forKey: "PlayerLevel")
            let newLevel = currLevel + 1
            defaults.set(newLevel, forKey: "PlayerLevel")
            makeNewSet(level: newLevel)
            retrieveSet()
            levelUp = true
        }
        checkComplete()
        print(defaults.integer(forKey: "PlayerLevel"))
        return levelUp

    }
    
    func retrieveSet() {
        if defaults.object(forKey: "Achievements") == nil {
            makeNewSet(level: 1)
            
            
        } else {
            
            
            let decoded  = UserDefaults.standard.object(forKey: "Achievements") as! Data
            let decodedGoals = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Achievement]
            //print(decodedTeams.name)
            set = decodedGoals
        }
    }
    
    func save() {
        
        for el in set {
            if !el.runSpecific {
                el.savedTotal += el.currTotal
            } else {
                el.savedTotal = 0
            }
        }
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: set)
        defaults.set(encodedData, forKey: "Achievements")
        defaults.synchronize()
    }
    
    
}
