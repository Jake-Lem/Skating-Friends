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
    
    var achievementDict : Dictionary = [Int : goalSet]()
    
    func checkComplete () {
        completed = set[0].completed && set[1].completed && set[2].completed
    }
    
    func loadGoals()
    {
        achievementDict[1] = goalSet.init(types: [], levels: [], runSpecifics: [], items: [])
        
        achievementDict[1] = goalSet.init(types: [], levels: [], runSpecifics: [], items: [])
        
    }
    
    struct goalSet {
        var types : [Goal]
        var levels : [Int]
        var runSpecifics : [Bool]
        var items : [Item]
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
            set.append(Achievement(withType: .DoublesTotal, withLevel: 3, isRunSpecific: false))
            set.append(Achievement(withType: .ItemsRun, withLevel: 2, isRunSpecific: true, withItem: .Butterfly))
            set.append(Achievement(withType: .CoinsRun, withLevel: 1, isRunSpecific: true))
        case 2:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .CoinsRun, withLevel: 2, isRunSpecific: true))
        case 3:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .CoinsRun, withLevel: 2, isRunSpecific: true))
        case 4:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .CoinsRun, withLevel: 2, isRunSpecific: true))
        case 5:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .CoinsRun, withLevel: 2, isRunSpecific: true))
            
        case 6:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .CoinsRun, withLevel: 2, isRunSpecific: true))
            
        case 7:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .CoinsRun, withLevel: 2, isRunSpecific: true))
            
        case 2:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .CoinsRun, withLevel: 2, isRunSpecific: true))
            
            
        case 2:
            set.removeAll()
            set.append(Achievement(withType: .TriplesTotal, withLevel: 2, isRunSpecific: false))
            set.append(Achievement(withType: .ObstaclesRun, withLevel: 3, isRunSpecific: true, withItem: .Banana))
            set.append(Achievement(withType: .CoinsRun, withLevel: 2, isRunSpecific: true))
        default:
            set.removeAll()
            set.append(Achievement(withType: .DoublesTotal, withLevel: 3, isRunSpecific: false))
            set.append(Achievement(withType: .ItemsRun, withLevel: 2, isRunSpecific: true, withItem: .Butterfly))
            set.append(Achievement(withType: .CoinsRun, withLevel: 1, isRunSpecific: true))
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
    
    func incLevel() {
        checkComplete()
        
        if defaults.integer(forKey: "PlayerLevel") == 0 {
            defaults.set(1, forKey: "PlayerLevel")
        }
        if completed {
            let currLevel = defaults.integer(forKey: "PlayerLevel")
            let newLevel = currLevel + 1
            defaults.set(newLevel, forKey: "PlayerLevel")
            makeNewSet(level: newLevel)
            retrieveSet()
            
        }
        
        checkComplete()
        print(defaults.integer(forKey: "PlayerLevel"))
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
