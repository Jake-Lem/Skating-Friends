//
//  GameScene.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/10/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let defaults = UserDefaults.standard
    //prevents actions from being decoded and called multiple times from a non input action (eg a touchdown)
    var newInput = false
    var held = false {
        didSet {
            decodeAction()
        }
    }
    var screen = SKSpriteNode()
    var fixed = SKSpriteNode()
    var cam : SKCameraNode?
    //stops the camera from snapping to player if player snaps in game
    var stopJerk = false

    var changeScene = false
    var rink = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var gamePaused = false
    var grounded = false
    var marker : SKSpriteNode!
    var jumpHeight : Double = 0
    var imageName : String?
    var foregroundName : String?
    var playerLevel : Int = 0
    var currentGoals : AchievementSet = AchievementSet()
    
    var backgroundNum = 1 {
        didSet {
            updateBackground()

            didChange = true
        }
    }
    
    var effect : SKSpriteNode = SKSpriteNode(imageNamed: "Success0")
    
    var saveCount = 2 {
        didSet{
        if saveCount > 4 {
            saveCount = 1
        }
        }
    }
    
    var didChange = false
    
    var coins = 0 {
        didSet {
            coinsLabel.text = String(coins)
        }
    }

    var numKois = 0
    var numButterflies = 0
    var numPineapples = 0
    var bananaSmash = 0
    

    
    var score : Double = 0 {
        didSet {
            score = Double(round(100*score)/100)
            scoreLabel.text = String(format:"%.1f", score)
            
        }
    }
    
    var coinArray : [Collectible] = []
    var itemArray : [Collectible] = []
    var coinFormation : Formation!
    
    
    var banana = Collectible (imageNamed: "banana0001")
    var trampoline = Collectible(imageNamed: "trampoline0001")
    var platformArray : [SKSpriteNode] = []
    var platformArray2 : [SKSpriteNode] = []
    var platformArray3 : [SKSpriteNode] = []

    var platFormation : Formation!
    var platFormation2 : Formation!
    var platFormation3 : Formation!

    //if all platforms should not make contact with player
    var allOff = false
    var currentItem : Collectible!
    var speedFactor : Double = 2
    var collected = false
    var inputs: [Int] = []
    
    var thePlayer : Skater!
    
    var jumpNum = 0 {
        didSet {
            if jumpNum > 5 {
                jumpNum = 0
            }
        }
    }
    
    lazy var backgroundPieces : [SKSpriteNode] = [SKSpriteNode(imageNamed: "sky1"), SKSpriteNode(imageNamed: "sky1"), SKSpriteNode(imageNamed: "sky1")]
    
    lazy var backgroundPieces2 : [SKSpriteNode] = [SKSpriteNode(imageNamed: "foreground1"), SKSpriteNode(imageNamed: "foreground1"), SKSpriteNode(imageNamed: "foreground1")]
    
    var invincible = false
    
    var minSpeed : Double = 500
    var catSpeed : Double = 500 {
        didSet {

            
            for background in backgroundPieces {
                // Minus, because the background is moving from left to right.
                background.physicsBody!.velocity.dx = CGFloat(-catSpeed / 8)
            }
            
            goalBackground.physicsBody!.velocity.dx = CGFloat(-catSpeed / 8)
            
            for background in backgroundPieces2 {
                // Minus, because the background is moving from left to right.
                background.physicsBody!.velocity.dx = CGFloat(-catSpeed / 3)
            }
            
            
            
            
            coinFormation.form.physicsBody!.velocity.dx = CGFloat(-catSpeed / speedFactor)
            
            for coin in coinArray {
                coin.physicsBody!.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
            }
            
            for item in itemArray {
                item.physicsBody!.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
                
            }
            
            for platform in platformArray {
                platform.physicsBody?.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
            }
            
            for platform in platformArray2 {
                platform.physicsBody?.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
            }
            
            for platform in platformArray3 {
                platform.physicsBody?.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
            }
            
            platFormation.form.physicsBody!.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
            platFormation2.form.physicsBody!.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
            platFormation3.form.physicsBody!.velocity.dx = coinFormation.form.physicsBody!.velocity.dx

            
            banana.physicsBody!.velocity.dx = coinFormation.form.physicsBody!.velocity.dx


        }
    }
    
    var speedChange : Double = 500
    
    var difficulty : Double = 1
    var upTimer : Double = 0 {
        didSet {
            difficulty += 0.0005
        }
    }
    
    
    var holdTime : Double = 0
    var actionTimer : Double = 0
    var gameOver = false
    var timeLeft : Double = 30 {
        didSet {
            
            if timeLeft > 60 {
                timeLeft = 60
            }
            
            if timeLeft <= 0 {
                //end game
                updateScore()
                currentGoals.save()
                currentGoals.incLevel()
                gameOver = true

                timeLeft = 0
                thePlayer.sprite.removeAllActions()

                endCollisions()
                self.currentMotion = Motion.Stationary
                thePlayer.sprite.run(self.thePlayer.bow)
                
                let wait = SKAction.wait(forDuration: 3)
                let changeScene = SKAction.run({
                    [unowned self] in self.changeScene = true
                })
                self.run(SKAction.sequence([wait, changeScene]))
            }
            timerLabel.text = String(format:"Time: %.1f", timeLeft)
            let fraction = timeLeft / 60
            momentumBar.run(SKAction.resize(toWidth: CGFloat(fraction * 200), duration: 0.1))
            var r : CGFloat = 0
            var g : CGFloat = 0
            var b : CGFloat = 0
            let inverse = 2 * (1 - fraction)
            
            if fraction >= 0.5 {
                g = 1
                r = CGFloat(inverse)
            } else {
                r = 1
                g = CGFloat(2 * fraction)
                
            }
            momentumBar.color = UIColor(red: r, green: g, blue: b, alpha:1)
        }
    }
    
    var timerLabel = SKLabelNode(fontNamed:"Helvetica")
    
    var spiralLevel : Double = 0 {
        didSet {
            if spiralLevel > 100 {
                spiralLevel = 100
            }
            
            if spiralLevel < 0 {
                spiralLevel = 0
            }
            
            let fraction = spiralLevel / 100
            spiralBar.run(SKAction.resize(toWidth: CGFloat(fraction * 200), duration: 0.1))

        }
    }
    
    var spiralBar = SKSpriteNode (color: UIColor(red:1, green:1, blue:1, alpha:1), size: CGSize(width: 0, height: 10))
    
    
    var scoresheet : [Element] = [] {
        didSet {
            //display the most recent element and its score on the scoreboard
            if(!scoresheet.isEmpty) {
                let lastEl = scoresheet[scoresheet.count - comboCount]
                if(lastEl.type != Tech.Steps) {
                    lastElLabel.text = lastEl.toString()
                    lastElScoreLabel.text = String(format:"%.1f", (lastEl.score))
                }
            }
            currentGoals.set[0].updateTotal(fromScoresheet: scoresheet)
            currentGoals.set[1].updateTotal(fromScoresheet: scoresheet)
            currentGoals.set[2].updateTotal(fromScoresheet: scoresheet)
        }
    }
    var comboCount = 1
    var comboDone = true
    var jumpCombo : Combo!
    
    var timeInt : Double = 0
    enum MoveQuality : String {
        case good
        case bad
        case notBegun
    }
    
    var goodMove = MoveQuality.notBegun
    var currentElement : Element = Element(ofType: Tech.None)
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    
    
    var currentMotion = Motion.Midair {
        didSet{
            
            if gameOver {
                currentMotion = Motion.Stationary
            }
            switch currentMotion {
            case Motion.Spinning, Motion.Stationary:
                //stop the background from moving
                let speedInt = catSpeed / 6
                let reduceSpeed = SKAction.run {
                    [unowned self] in
                    
                    if (self.catSpeed > 0) {
                        self.catSpeed -= speedInt
                    }
                    if (self.catSpeed <= 0) {
                        self.catSpeed = 0
                    }
                }
                //decelerate in incremements of 0.1 seconds
                let wait = SKAction.wait(forDuration: 0.1)
                let waitReduce = SKAction.sequence([wait, reduceSpeed])
                run(SKAction.repeatForever(waitReduce), withKey: "reduceSpeed")
            case Motion.Skating:
                cancelAllMoves()
                removeAction(forKey: "reduceSpeed")

            default:
                removeAction(forKey: "reduceSpeed")
            }
        }
    }
    
    var scoreLabel = SKLabelNode(fontNamed:"Helvetica")
    var lastElLabel = SKLabelNode(fontNamed:"Helvetica")
    var lastElScoreLabel = SKLabelNode(fontNamed:"Helvetica")
    var coinsLabel = SKLabelNode(fontNamed:"Helvetica")
    var scoreBackground = SKSpriteNode(color: UIColor(red:0.40, green:0.47, blue:0.64, alpha:0), size: CGSize(width: 1000, height: 250))
    var pausebox : SKSpriteNode!
    var quitLabel = SKLabelNode(fontNamed:"Helvetica")
    var restartLabel = SKLabelNode(fontNamed:"Helvetica")
    var resumeLabel = SKLabelNode(fontNamed:"Helvetica")

    var timingBar = SKSpriteNode (color: UIColor(red:1, green:1, blue:1, alpha:1), size: CGSize(width: 0, height: 10))
    
    var momentumBar = SKSpriteNode (color: UIColor(red:1, green:1, blue:1, alpha:1), size: CGSize(width: 0, height: 20))
    
    let goalBackground = SKSpriteNode(color: UIColor(red:0.40, green:0.47, blue:0.64, alpha:0), size: CGSize(width: 1000, height: 500))
    
    var initGoalLabelArray : [SKLabelNode] = []
    var pauseGoalLabelArray : [SKLabelNode] = []


    let SkaterCategory  : UInt32 = 0x1 << 1
    //let SkaterCategory  : UInt32 = 0x1 << 1

    func createPauseBox() {
    //setup pausebox position
       pausebox = SKSpriteNode (color: UIColor(red:1, green:1, blue:1, alpha:0.8), size: CGSize(width: size.width, height: size.height))

    pausebox.position = CGPoint(x: 0, y: 0)
    pausebox.zPosition = 12
    
    //setup restart and quit labels
    restartLabel.text = "Restart"
    restartLabel.fontColor = SKColor.black
    restartLabel.fontSize = 60
    restartLabel.zPosition = 12
    restartLabel.position = CGPoint(x: -200, y: -200)
    
    
    quitLabel.text = "Quit"
    quitLabel.fontColor = SKColor.black
    quitLabel.fontSize = 60
    quitLabel.zPosition = 12
    quitLabel.position = CGPoint(x: 0, y: -200)
    
    
    resumeLabel.text = "Resume"
    resumeLabel.fontColor = SKColor.black
    resumeLabel.fontSize = 60
    resumeLabel.zPosition = 12
    resumeLabel.position = CGPoint(x: 200, y: -200)
    
    
    //add restart and quit labels to pausebox
    pausebox.addChild(restartLabel)
    pausebox.addChild(quitLabel)
    pausebox.addChild(resumeLabel)
        
        for goal in currentGoals.set {
            let goalLabel = SKLabelNode(fontNamed: "Helvetica")
            goalLabel.text = goal.text
            goalLabel.fontSize = 45
            goalLabel.zPosition = 12
            goalLabel.fontColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            pauseGoalLabelArray.append(goalLabel)
        }
        
        var count = 0
        for label in pauseGoalLabelArray {
            let strikethrough = SKSpriteNode(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0), size: CGSize(width: label.frame.width, height: 10))
            strikethrough.name = "strikethrough"
            strikethrough.position = CGPoint(x: 0, y: label.frame.height / 2)
            //strikethrough.zPosition =
            label.position = CGPoint(x: 0, y: 100 - 100 * count)
            label.addChild(strikethrough)
            pausebox.addChild(label)
            count += 1
        }
        
        


    }
    
   
    func makeCombo() {
        jumpCombo = Combo(firstEl: currentElement)
    }
    
    override func didMove(to view: SKView) {

        self.physicsWorld.contactDelegate = self
        self.physicsWorld.speed = 3.0
        //adding swipe gesture recognizers
        swipeRightRec.addTarget(self, action: #selector(GameScene.swipedRight))
        swipeRightRec.direction = .right
        swipeRightRec.cancelsTouchesInView = false
        
        view.addGestureRecognizer(swipeRightRec)
        
        swipeLeftRec.addTarget(self, action: #selector(GameScene.swipedLeft))
        swipeLeftRec.direction = .left
        swipeLeftRec.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeLeftRec)
        
        swipeDownRec.addTarget(self, action: #selector(GameScene.swipedDown))
        swipeDownRec.direction = .down
        swipeDownRec.cancelsTouchesInView = false
        
        view.addGestureRecognizer(swipeDownRec)
        
        swipeUpRec.addTarget(self, action: #selector(GameScene.swipedUp))
        swipeUpRec.direction = .up
        swipeUpRec.cancelsTouchesInView = false
        
        view.addGestureRecognizer(swipeUpRec)
        
        
        setScreen()
        setFixed()
        setPlayer()
        setCam()
        setGoals ()
        makeGoalLabels()
        drawBackground()
        createBanana()
        createTrampoline ()
        createBackgroundTransition()
        createCoins()
        setPlatforms()
        createItems()
        createScoreBox()
        setTimer()
        currentElement = Element(ofType: Tech.None, bySkater: thePlayer)
        createPauseButton()
        createPauseBox()
        makeMarker()
        
        


    }
    func setScreen() {
        screen = SKSpriteNode(color: UIColor(red:1, green:1, blue:1, alpha:0.95), size: CGSize(width: size.width, height: size.height))
        screen.position = CGPoint(x: 0, y: 0)
        screen.zPosition = -5
        
        addChild(screen)
    }
    
    func setFixed() {
        fixed = SKSpriteNode(color: UIColor(red:1, green:1, blue:1, alpha:0.95), size: CGSize(width: size.width, height: size.height))
        fixed.position = CGPoint(x: 0, y: 0)
        fixed.zPosition = -5
    }
    
    func setCam() {
        cam = SKCameraNode()
        self.camera = cam
        cam?.addChild(fixed)
        self.addChild(cam!)
        cam?.position.y = thePlayer.sprite.position.y
    }
    
    func createTimingBar() {
        //setup action timing bar
        timingBar.position = CGPoint(x: -(thePlayer.sprite.size.width / 8) , y: thePlayer.sprite.size.height / 2)
        timingBar.anchorPoint = CGPoint(x: 0, y: 0)
        //thePlayer.sprite.addChild(timingBar)
    }
    
    //creates marker of player's sprite position for testing purposes
    func makeMarker() {
        marker = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0.2, alpha: 0), size: CGSize(width: 40, height: 10))
        marker.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        marker.position = CGPoint(x: 0, y: 0)
        marker.zPosition = 100
        screen.addChild(marker)
    }
    
    func setEffect() {
        effect.alpha = 0
        effect.size = CGSize(width: 300, height: 300)
        //thePlayer.sprite.addChild(effect)
    }
    
    func createPauseButton () {
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.size = CGSize (width: 60, height: 75)
        pauseButton.position = CGPoint(x: self.frame.minX + 100, y: self.frame.maxY - 100)
        pauseButton.zPosition = 4
        fixed.addChild(pauseButton)
    }
    
    //prints details of all elements in scoresheet
    func dumpScore(){
        for thing in scoresheet {
            print("type: \(thing.type), score: \(thing.score), rotations: \(thing.rotations)")
        }
    }
    
    func setLevel() {
        playerLevel = defaults.integer(forKey: "PlayerLevel")
    }
    
    func setGoals() {
        currentGoals.retrieveSet()
        
        
    }
    
    
    func makeGoalLabels() {
        goalBackground.position = CGPoint(x: 0, y: 0)
        goalBackground.zPosition = 1

        for goal in currentGoals.set {
            
            let goalLabel = SKLabelNode(fontNamed:"Helvetica")
            goalLabel.text = goal.text
            goalLabel.fontSize = 40
            goalLabel.fontColor  = UIColor(red: 0.6, green: 0.6, blue: 0.75, alpha: 1)
            if goal.completed {
                goalLabel.fontColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
            }
            initGoalLabelArray.append(goalLabel)
        }
        
        var i = 0
        
        for label in initGoalLabelArray {
            let strikethrough = SKSpriteNode(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0), size: CGSize(width: label.frame.width, height: 10))
            
            strikethrough.name = "strikethrough"
            strikethrough.position = CGPoint(x: 0, y: label.frame.height / 2)
            //strikethrough.zPosition = 13
            label.addChild(strikethrough)
            label.position = CGPoint(x: 0, y: 250 - 100 * i)
            goalBackground.addChild(label)
            
            i += 1
        }
        
        
        
        
        fixed.addChild(goalBackground)
        goalBackground.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        goalBackground.physicsBody!.affectedByGravity = false
        goalBackground.physicsBody!.allowsRotation = false
        goalBackground.physicsBody!.linearDamping = 0
        goalBackground.physicsBody!.friction = 0
        goalBackground.physicsBody!.velocity.dx = CGFloat(-catSpeed / 8)
        goalBackground.physicsBody!.categoryBitMask = 0
        goalBackground.physicsBody!.collisionBitMask = 0
        
        
    }
    
    func setPlayer () {
        let currentSkater = defaults.integer(forKey: "Current Skater")
        switch currentSkater {
        case 0:
            thePlayer = Catoko()
        case 1:
            thePlayer = MeowAsada()
        case 2:
            thePlayer = Mewna()
        default:
            thePlayer = Catoko()
        }
        
        jumpHeight = thePlayer.jumpHeight
        
        //setup physics body, zPosition, etc... for sprite
        thePlayer.sprite.zPosition = 7
        thePlayer.sprite.physicsBody!.contactTestBitMask = SkaterCategory
        thePlayer.sprite.physicsBody!.categoryBitMask = SkaterCategory
        thePlayer.sprite.physicsBody!.restitution = 0
        thePlayer.sprite.physicsBody!.friction = 0
        thePlayer.sprite.name = "player"
        thePlayer.sprite.run(thePlayer.skating)
        let range = SKRange(lowerLimit: -450, upperLimit: -450)
        let lockPlayer = SKConstraint.positionX(range)
        thePlayer.sprite.constraints = [lockPlayer]
        //add sprite to screen
        screen.addChild(thePlayer.sprite)

    }
    
    func createScoreBox() {
        scoreBackground.position = CGPoint(x: 0, y: self.frame.maxY - 150)
        scoreBackground.zPosition = 4
        //scoreBackground.setScale(0.7)
        fixed.addChild(scoreBackground)
        
        timerLabel.text = "Time: 30.0"
        timerLabel.fontSize = 50
        timerLabel.fontColor = SKColor.white
        timerLabel.position = CGPoint(x: 0, y: 50)
        timerLabel.zPosition = 5
        //scoreBackground.addChild(timerLabel)
        
        momentumBar.anchorPoint = CGPoint (x: 0, y: 0.5)
        momentumBar.size.width = CGFloat((timeLeft / 60) *  300)
        momentumBar.position = CGPoint (x: -momentumBar.size.width / 2, y: 70)
        scoreBackground.addChild(momentumBar)
        
        spiralBar.anchorPoint = CGPoint (x: 0, y: 0.5)
        spiralBar.size.width = CGFloat((spiralLevel / 100) *  300)
        spiralBar.position = CGPoint (x: -spiralBar.size.width / 2, y: 40)
        scoreBackground.addChild(spiralBar)
        
        //making score labels
        scoreLabel.text = "0.0"
        scoreLabel.fontSize = 70
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: 600, y: 20)
        scoreLabel.zPosition = 5
        
        lastElLabel.text = ""
        lastElLabel.fontSize = 26
        lastElLabel.fontColor = SKColor.white
        lastElLabel.horizontalAlignmentMode = .right
        lastElLabel.position = CGPoint(x: 550, y: -15)
        lastElLabel.zPosition = 5
        
        lastElScoreLabel.text = ""
        lastElScoreLabel.fontSize = 26
        lastElScoreLabel.fontColor = SKColor.white
        lastElScoreLabel.horizontalAlignmentMode = .right
        lastElScoreLabel.position = CGPoint(x: 600, y: -15)
        lastElScoreLabel.zPosition = 5
        
        
        let coinIcon = SKSpriteNode(imageNamed: "coin0001")
        coinIcon.size = CGSize (width: 40, height: 40)
        coinIcon.position = CGPoint(x: -55, y:10)
        coinsLabel.text = "0"
        coinsLabel.fontSize = 26
        coinsLabel.fontColor = SKColor.white
        coinsLabel.horizontalAlignmentMode = .right
        coinsLabel.position = CGPoint(x: 600, y: -50)
        coinsLabel.zPosition = 5
        coinsLabel.addChild(coinIcon)
        
        
        //adding labels to score box
        scoreBackground.addChild(scoreLabel)
        scoreBackground.addChild(lastElLabel)
        scoreBackground.addChild(lastElScoreLabel)
        scoreBackground.addChild(coinsLabel)
    }
    
    func createItems () {
        let koi = Collectible(imageNamed: "koi0001")
        koi.size = CGSize(width: 90, height: 90)
        koi.position = CGPoint(x: 900,y:100)
        koi.zPosition = 4
        koi.run(SKAction.repeatForever(SKAction(named: "Koi")!))
        koi.name = "koi"
        koi.physicsBody = SKPhysicsBody(rectangleOf: koi.size)
        koi.physicsBody!.contactTestBitMask = SkaterCategory
        koi.physicsBody!.categoryBitMask = 0
        koi.physicsBody!.collisionBitMask = 0
        koi.physicsBody!.affectedByGravity = false
        itemArray.append(koi)
        
        let pineapple = Collectible(imageNamed: "pineapple0001")
        pineapple.size = CGSize(width: 90, height: 90)
        pineapple.position = CGPoint(x: 900,y:100)
        pineapple.zPosition = 4
        pineapple.run(SKAction.repeatForever(SKAction(named: "Pineapple")!))
        pineapple.name = "pineapple"
        pineapple.physicsBody = SKPhysicsBody(rectangleOf: koi.size)
        pineapple.physicsBody!.contactTestBitMask = SkaterCategory
        pineapple.physicsBody!.categoryBitMask = 0
        pineapple.physicsBody!.collisionBitMask = 0
        pineapple.physicsBody!.affectedByGravity = false
        itemArray.append(pineapple)
        
        let butterfly = Collectible(imageNamed: "butterfly0001")
        butterfly.size = CGSize(width: 90, height: 90)
        butterfly.position = CGPoint(x: 900,y:100)
        butterfly.zPosition = 4
        butterfly.run(SKAction.repeatForever(SKAction(named: "Butterfly")!))
        butterfly.name = "butterfly"
        butterfly.physicsBody = SKPhysicsBody(rectangleOf: butterfly.size)
        butterfly.physicsBody!.contactTestBitMask = SkaterCategory
        butterfly.physicsBody!.categoryBitMask = 0
        butterfly.physicsBody!.collisionBitMask = 0
        butterfly.physicsBody!.affectedByGravity = false
        itemArray.append(butterfly)
        
        
        for item in itemArray {
            item.zPosition = 8
        }
        let number = arc4random_uniform(2)
        currentItem = itemArray[0]
        currentItem.physicsBody?.velocity.dx = CGFloat(-catSpeed / speedFactor)
        screen.addChild(currentItem)
    }
    
    func setTimer() {
        //make timer for counting down and up
        let waitTime = SKAction.wait(forDuration: 0.1)
        
        let countTime = SKAction.run(
        {[unowned self] in
            self.upTimer += 0.1
            self.timeInt += 0.0002
            if self.timeLeft > 0 {
                self.timeLeft -= self.timeInt
                
            } else {
                self.removeAction(forKey: "countdown")
            }
        })
        
        
        let countTimeSeq = SKAction.sequence([waitTime,countTime])
        thePlayer.sprite.run(SKAction.repeatForever(countTimeSeq))
    }
    
    func drawBackground () {
        //draw background
        
        for i in 0...2 {
            // Setup the position, zPosition, size, etc...
            let rink = backgroundPieces2[i]
            
            rink.name = "Rink"
            rink.size = CGSize (width: 828, height: 900)
            
            rink.anchorPoint = CGPoint(x: 0.5, y:0.5)
            rink.position = CGPoint(x: -500 + CGFloat(i) * rink.size.width - 5 * CGFloat(i), y: -100)
            rink.zPosition = 2
            rink.physicsBody = SKPhysicsBody(rectangleOf: rink.size)
            rink.physicsBody!.affectedByGravity = false
            rink.physicsBody!.allowsRotation = false
            rink.physicsBody!.linearDamping = 0
            rink.physicsBody!.friction = 0
            rink.physicsBody!.velocity.dx = CGFloat(-catSpeed / 3)
            rink.physicsBody!.categoryBitMask = 0
            rink.physicsBody!.collisionBitMask = 0
            
            screen.addChild(rink)
            
            
            let sky = backgroundPieces[i]
            
            sky.name = "Rink"
            sky.size = CGSize (width: 828, height: 900)
            sky.anchorPoint = CGPoint(x: 0.5, y:0.5)
            sky.position = CGPoint(x: -500 + CGFloat(i) * sky.size.width - 20 * CGFloat(i), y: 0)
            sky.zPosition = 0
            sky.physicsBody = SKPhysicsBody(rectangleOf: sky.size)
            sky.physicsBody!.affectedByGravity = false
            sky.physicsBody!.allowsRotation = false
            sky.physicsBody!.linearDamping = 0
            sky.physicsBody!.friction = 0
            sky.physicsBody!.velocity.dx = CGFloat(-catSpeed / 8)
            sky.physicsBody!.categoryBitMask = 0
            sky.physicsBody!.collisionBitMask = 0
            
            fixed.addChild(sky)
            
            
            
            //draw ground for physics body simulation
            let ground = SKSpriteNode(color: UIColor(red:1, green:1, blue:1, alpha:0.3), size: CGSize(width: frame.width, height: 500))
            
            // let ground = SKSpriteNode(imageNamed: "ice")
            ground.position = CGPoint(x: CGFloat(i) * rink.size.width, y: -500)
            ground.zPosition = 6
            ground.name = "ground"
            
            ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground.size.width, height: ground.size.height))
            ground.physicsBody!.contactTestBitMask = SkaterCategory
            ground.physicsBody!.collisionBitMask = SkaterCategory
            ground.physicsBody!.categoryBitMask = SkaterCategory
            
            ground.physicsBody!.affectedByGravity = false
            ground.physicsBody!.isDynamic = false
            ground.physicsBody!.restitution = 0
            
            
            screen.addChild(ground)
            
            
        }
    }
    
    func createBanana() {
        banana.size = CGSize(width: 80, height: 80)
        banana.position = CGPoint(x: 900, y: 100)
        banana.zPosition = 9
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "banana0001"), size: banana.size)
        banana.run(SKAction(named:"RegularBanana")!)
        banana.physicsBody!.contactTestBitMask = SkaterCategory
        banana.physicsBody!.categoryBitMask = 0
        banana.physicsBody!.collisionBitMask = 0
        banana.physicsBody!.affectedByGravity = true
        banana.physicsBody!.velocity.dx = CGFloat(-catSpeed / speedFactor)
        screen.addChild(banana)
    }
    
    func createBackgroundTransition() {
        let trans = SKSpriteNode(imageNamed: "background9")
        
        trans.size = CGSize (width: 1564, height: 1700)
        trans.name = "trans"
        trans.anchorPoint = CGPoint(x: 0.5, y:0.5)
        trans.position = CGPoint(x: 0, y: 0)
        trans.zPosition = 1
        trans.alpha = 0
        fixed.addChild(trans)
        startTrans()
    }
    
    func startTrans() {
        let changeBack = SKAction.run {
            [unowned self] in
            
            /*if self.backgroundNum != 0 {
             self.backgroundNum = 0
             
             } else {*/
            self.saveCount += 1
            //let number = 1 + Int(arc4random_uniform(2))
            self.backgroundNum = self.saveCount
            
            // }
        }
        
        let waitChange = SKAction.wait(forDuration: 20)
        
        run(SKAction.repeatForever(SKAction.sequence([waitChange, changeBack])))
    }
    
    func createTrampoline ()
    {
        trampoline.size = CGSize(width: 360, height: 360)
        trampoline.zPosition = 3
        trampoline.name = "trampoline"
        trampoline.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "trampoline0001"), size: trampoline.size)

        trampoline.physicsBody!.contactTestBitMask = SkaterCategory
        trampoline.physicsBody!.categoryBitMask = 0
        trampoline.physicsBody!.collisionBitMask = 0
        trampoline.physicsBody!.affectedByGravity = false
        trampoline.physicsBody!.velocity.dx = CGFloat(-catSpeed / speedFactor)
screen.addChild(trampoline)

    }

    
    func createCoins() {
        //create coins
        for i in 0...15 {
            let coin = Collectible(imageNamed: "coin0001")
            coin.size = CGSize(width: 40, height: 40)
            coin.zPosition = 4
            coin.run(SKAction(named: "Coin")!)
            coin.name = "coin"
            coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
            coin.physicsBody!.contactTestBitMask = SkaterCategory
            coin.physicsBody!.categoryBitMask = 0
            coin.physicsBody!.collisionBitMask = 0
            coin.physicsBody!.affectedByGravity = false
            coin.physicsBody!.velocity.dx = CGFloat(-catSpeed / speedFactor)
            coinArray.append(coin)
            
        }
        
        
        
        coinFormation = Formation(withArray: coinArray, withModel: coinArray[0], withPhysics: coinArray[0].physicsBody!)
        let randcoin = arc4random_uniform(6)
        coinFormation.setFormation(withForm: Int(randcoin))
        coinFormation.form.position = CGPoint(x: 400, y: 0)
        coinFormation.form.zPosition = 3
        coinFormation.form.size = CGSize(width: screen.size.width * 2, height: screen.size.height)
        
        coinFormation.form.physicsBody = SKPhysicsBody(rectangleOf: coinFormation.form.size)
        coinFormation.form.physicsBody!.categoryBitMask = 0
        coinFormation.form.physicsBody!.collisionBitMask = 0
        coinFormation.form.physicsBody!.affectedByGravity = false
        coinFormation.form.physicsBody!.friction = 0
        coinFormation.form.physicsBody!.linearDamping = 0
        coinFormation.form.physicsBody!.velocity.dx = CGFloat(-catSpeed / speedFactor)
        
        
        screen.addChild(coinFormation.form)
    }
    
    func createPlatforms(num: Int, inArray: inout [SKSpriteNode]) {
        for i in 0...num {
            let platSprite = SKSpriteNode(imageNamed: "ice")
            platSprite.size = CGSize(width: 400, height: 105)
            platSprite.anchorPoint = CGPoint(x: 0.5,y: 1)
            let platform = Collectible(color: UIColor(red:CGFloat(Double(i) * 0.15), green:1, blue:1, alpha:0), size: CGSize(width: 350, height: 30))
            platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
            platform.zPosition = 3
            //platform.physicsBody!.pinned = true
            
            
            
            platform.name = "platform"
            platform.physicsBody!.contactTestBitMask = SkaterCategory
            platform.physicsBody!.categoryBitMask = SkaterCategory
            platform.physicsBody!.collisionBitMask = 0
            platform.physicsBody!.affectedByGravity = false
            platform.physicsBody!.allowsRotation = false
            platform.physicsBody!.friction = 0
            platform.physicsBody!.restitution = 0.0
            platSprite.position.y = platform.size.height / 2 + 10
            platform.addChild(platSprite)
            
            inArray.append(platform)
        }
    }
    
    func createPlatFormation(useArray: [SKSpriteNode], name: String, pos: CGPoint) -> Formation {
        let theFormation = Formation(withArray: useArray, withModel: useArray[0], withPhysics: useArray[0].physicsBody!)
        theFormation.form.color = UIColor(red: 0, green: 0.9, blue: 1, alpha: 0)
        let randPlat2 = 4 + arc4random_uniform(3)
        theFormation.setFormation(withForm: Int(randPlat2))
        theFormation.form.position = pos
        theFormation.form.zPosition = 3
        theFormation.form.size = CGSize(width: screen.size.width * 2, height: screen.size.height)
        theFormation.form.name = name
        
        theFormation.form.physicsBody = SKPhysicsBody(rectangleOf: theFormation.form.size)
        theFormation.form.physicsBody!.categoryBitMask = 0
        theFormation.form.physicsBody!.collisionBitMask = 0
        theFormation.form.physicsBody!.affectedByGravity = false
        theFormation.form.physicsBody!.allowsRotation = false
        theFormation.form.physicsBody!.velocity.dx = CGFloat(-catSpeed / speedFactor)
        return theFormation
    }
    

    
    func setPlatforms() {
        createPlatforms(num: 5, inArray: &platformArray)
        createPlatforms(num: 5, inArray: &platformArray2)
        createPlatforms(num: 5, inArray: &platformArray3)
        
        platFormation = createPlatFormation(useArray: platformArray, name: "form1", pos: CGPoint(x: 0, y: -200))
        screen.addChild(platFormation.form)
        
        platFormation2 = createPlatFormation(useArray: platformArray2, name: "form2", pos: CGPoint(x: 400, y: -130))
        screen.addChild(platFormation2.form)

        platFormation3 = createPlatFormation(useArray: platformArray3, name: "form3", pos: CGPoint(x: 800, y: -60))
        screen.addChild(platFormation3.form)
    }
    
    func addInput(withInt: Int) {
        let removeInput : SKAction = SKAction.run({
            [unowned self] in
            self.inputs.removeFirst()
        })
        
        let wait = SKAction.wait(forDuration: 0.3)
        
        let waitThenRemove = SKAction.sequence([wait, removeInput])
        
        inputs.append(withInt)
        thePlayer.sprite.run(waitThenRemove)
        newInput = true
        
    }
    
    func backgroundRun() {
        let vy = CGFloat((jumpHeight * 9.8 * 2 * 135).squareRoot())
        thePlayer.sprite.physicsBody!.velocity.dy = vy
    }
    
    func calcVY (forHeight: Double) -> CGFloat {
        return CGFloat((forHeight * 9.8 * 2 * 135).squareRoot())
    }
    
    func decodeAction() {
        var a = 0
        var b = 0
        var c = 0
        
        if (inputs.count > 0) {
            c = inputs[inputs.count - 1]
        }
        if (inputs.count > 1) {
            b = inputs[inputs.count - 2]
        }
        if (inputs.count > 2) {
            a = inputs[inputs.count - 3]
        }
        
        let lastThree = (a, b, c)
        
        
        // print(lastThree)
        
        
        if thePlayer.sprite.action(forKey: "fall") != nil {
            return
        }
        
        switch currentMotion {
        case .Skating :
            
            if newInput {
                switch lastThree {
                case (_,_,3) :
                    switch jumpNum {
                    case 1:
                    beginJump(withType: .Salchow, withTakeoff: .salTakeoff)
                    case 2:
                    beginJump(withType: .Loop, withTakeoff: .loopTakeoff)
                    case 3:
                        beginJump(withType: .Flip, withTakeoff: .flipTakeoff)
                        
                    case 4:
                        beginJump(withType: .Lutz, withTakeoff: .lutzTakeoff)
                        
                    case 5:
                        beginJump(withType: .Axel, withTakeoff: .axelTakeoff)


                    default:
                        beginJump(withType: .Toe, withTakeoff: .toeTakeoff)
                    }
                    
                    jumpNum += 1
                case (_,_,4) :
                    beginSpin()
                case (_,_,2) :
                    beginSpiral()
                    
                default:
                    currentElement = Element(ofType: Tech.None, bySkater: thePlayer)
                }
            }
        case .Midair :
            rotateJump()
            
        case .Spinning:
            spin()
            
        case .Spiral:
            spiral()
        case .Landing:
            if jumpCombo == nil {
                return
                
            }
                switch lastThree {
                case (_,_,3) :
                    //if skater didn't fall and hasn't done a full 3 jump combo, can start new jump
                    if !currentElement.fall && thePlayer.sprite.action(forKey: "fall") == nil {
                        beginComboJump(withType: Tech.Toe)
                    }
                case (_,_,4) :
                    thePlayer.sprite.removeAction(forKey: "land")
                    thePlayer.sprite.removeAction(forKey: "comboJump")
                    updateScore()

                    beginSpin()
                    
                case (_,_,2) :
                    thePlayer.sprite.removeAction(forKey: "land")
                    thePlayer.sprite.removeAction(forKey: "comboJump")
                    beginSpiral()
                    
                default:
                    let runBlock = SKAction.run {
                        [unowned self] in
                        if self.held && !self.currentElement.fall {
                            self.beginComboJump(withType: Tech.Toe)
                        }
                    }
                    thePlayer.sprite.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), runBlock]), withKey: "comboJump")

            }
            
        default:
            break
    }
        
        newInput = false

    }
    
    func beginJump(withType: Tech, withTakeoff: Move) {
        let theVy = calcVY(forHeight: jumpHeight)
        currentElement = Element(ofType: withType, withSpeed: catSpeed, bySkater: thePlayer)
        jumpCombo = Combo(firstEl: currentElement)
        jump(with: withTakeoff, vy: theVy)
    }
    
    func beginComboJump(withType: Tech) {
        let theVy = calcVY(forHeight: jumpHeight / (pow(1.3, Double(jumpCombo.combo.count))))
            thePlayer.sprite.removeAction(forKey: "land")
            currentElement = Element(ofType: withType, withSpeed: catSpeed, bySkater: thePlayer)
            jumpCombo.addMove(withEl: currentElement)
            jump(with: Move.toeTakeoff, vy: theVy)
        
    }
    
    
    func landJump() {
        thePlayer.sprite.removeAction(forKey: "jump")

        if held {
            self.currentElement.addFall()
        }
        
        let land = SKAction.run {
            [unowned self] in
            self.thePlayer.sprite.physicsBody?.velocity.dy = 0

            self.currentMotion = Motion.Landing
            self.goodMove = MoveQuality.notBegun
            self.timingBar.color = UIColor (red:1.0, green:1.0, blue:1.0, alpha:1.0)
            
            if self.currentElement.fall {
                self.speedChange = self.minSpeed
                self.thePlayer.sprite.run(self.thePlayer.fall, withKey: "fall")
                
            } else {
                self.speedChange = self.catSpeed + 60
                self.thePlayer.sprite.run(SKAction.sequence([self.thePlayer.landing]), withKey: "landing")
                
            }
            self.catSpeed = min(self.speedChange, self.thePlayer.maxSpeed)
            
            
        }
        
        let waitLand = SKAction.wait(forDuration: thePlayer.landing.duration / 2)
        
        let finish = SKAction.run {
            [unowned self] in
            //finish jump combo
            self.comboDone = true
            if self.jumpCombo == nil {
                self.currentMotion = Motion.Skating
                return
            }
            self.currentElement = self.jumpCombo
            self.updateScore()
            self.currentMotion = Motion.Skating
        }
        
        if thePlayer.sprite.action(forKey: "land") == nil {
            
            thePlayer.sprite.run(SKAction.sequence([land, waitLand, finish]), withKey: "land")
        } else {
            //if land is called twice, stop velocity but don't play any animations or update the score
            self.thePlayer.sprite.physicsBody?.velocity.dy = 0
            
        }
    }
    
    func jump(with: Move, vy: CGFloat) {
        comboDone = false
        
        let turnOff = SKAction.run {
            [unowned self] in
            self.allOff = true
        }
        
        let backOn = SKAction.run {
            [unowned self] in
            self.allOff = false
        }

        let time : Double = 0
        
        
        let trans = SKAction.run {
            [unowned self]  in self.currentMotion = Motion.Transition
            self.thePlayer.sprite.physicsBody?.affectedByGravity = false
            self.thePlayer.sprite.physicsBody!.velocity.dy /= 2

            self.allOff = true

        }
        
        let postTakeoff = SKAction.run(
        {
            [unowned self]  in
            //self.thePlayer.sprite.physicsBody?.affectedByGravity = true
            self.thePlayer.sprite.physicsBody?.affectedByGravity = true
            self.currentMotion = Motion.Midair

            self.thePlayer.sprite.physicsBody!.velocity.dy = vy
            //self.thePlayer.sprite.run(SKAction.sequence([SKAction.wait(forDuration: 0.1),setMidair]))

            }
        )
        
        let rotate = SKAction.run{
            [unowned self]  in
            self.rotateJump()
        }
        
        let delayRotation = SKAction.sequence([SKAction.wait(forDuration: time / 10), rotate])
        
        let transMidair = SKAction.sequence([thePlayer.jumpTrans, SKAction.repeatForever(thePlayer.midair)])
        
        let rotateMidair = SKAction.group([transMidair, delayRotation])
        
        var takeoff : SKAction!
        
        switch with {
        case .lutzTakeoff :
            takeoff = thePlayer.lutzTakeoff
        case .flipTakeoff :
            takeoff = thePlayer.flipTakeoff
        case .loopTakeoff :
            takeoff = thePlayer.loopTakeoff
        case .toeTakeoff :
            takeoff = thePlayer.toeTakeoff
        case .salTakeoff :
            takeoff = thePlayer.salTakeoff
        case .axelTakeoff :
            takeoff = thePlayer.axelTakeoff
        default :
            break
        }
        
        
        //turnOff contact for platforms momentarily, allowing player to take off without touching platform
        let waitBackOn = SKAction.sequence([SKAction.wait(forDuration: 0.01), backOn])
        let postTakeoffToOn = SKAction.group([postTakeoff, waitBackOn])

        thePlayer.sprite.run(SKAction.sequence([trans, takeoff, postTakeoffToOn, rotateMidair]), withKey: "jump")
        
        
    }
    
    func rotateJump() {
        
        if held {

            let postRotate = SKAction.run {
                [unowned self] in
                self.thePlayer.sprite.physicsBody!.velocity.dy += 100
                if self.currentElement.rotations < 4 {
                    self.currentElement.addRotation()
                    let turnOn = SKAction.fadeAlpha(to: 1, duration: 0)
                    let turnOff = SKAction.fadeAlpha(to: 0, duration: 0)
                    let success = SKAction(named: "Success", duration: 0.2)!
                    let successSeq = SKAction.sequence([turnOn, success, turnOff])
                    self.effect.run(successSeq, withKey: "rotate")
                }

            }
            
            if goodMove == MoveQuality.bad {
                currentElement.addFall()
            }
            
            let waitRotate = SKAction.sequence([thePlayer.rotate, postRotate])
            thePlayer.sprite.run(SKAction.sequence([ thePlayer.jumpTrans.reversed(), SKAction.repeat(waitRotate, count: 4 - currentElement.rotations)]), withKey: "rotate")
            
        } else {
            if thePlayer.sprite.action(forKey: "rotate") == nil {
                return
            }
            
            thePlayer.sprite.removeAction(forKey: "rotate")
            effect.removeAction(forKey: "rotate")

            thePlayer.sprite.run(thePlayer.jumpTrans)
            
        }
    }
    
    func beginSpiral() {
        currentElement = Element(ofType: Tech.Spiral, withSpeed: catSpeed, bySkater: thePlayer)
        currentMotion = Motion.Spiral
        spiral()
    }
    
    func spiral() {
        let spiralExit = thePlayer.spiralEntrance.reversed()
        let add = SKAction.run {
            [unowned self] in
            self.currentElement.addBonus(byNum: 1)
        }
        
        let makeInvincible = SKAction.run {
            [unowned self] in
            self.invincible = true
        }
        
        let endInvincible = SKAction.run {
            [unowned self] in
            self.invincible = false
        }
        
        let finish = SKAction.run {
            [unowned self] in
            print("FINSH")
            self.thePlayer.sprite.removeAction(forKey:  "endSpiral")
            self.thePlayer.sprite.removeAction(forKey: "spiral")
            self.updateScore()
            self.currentMotion = Motion.Skating
            
           self.catSpeed = self.speedChange
            self.thePlayer.sprite.run(SKAction.sequence([SKAction.wait(forDuration: 0.9), endInvincible]))
            
        }
        
        //let waitEnd = SKAction.sequence([SKAction.wait(forDuration: maxTime), finish])
        
        //thePlayer.sprite.run(waitEnd, withKey: "endSpiral")
        let finishGroup = SKAction.group([spiralExit, finish])
        //let maxTime = spiralLevel / 10
        
        
        let addSpeed = SKAction.run {
            [unowned self] in
            let speed = self.spiralLevel * 5 * self.thePlayer.spiralPower
            self.speedChange = self.catSpeed
        self.catSpeed += speed
        }
        let removeTime = SKAction.run {
            [unowned self] in
            self.spiralLevel -= 0.1 * 100 / self.thePlayer.spiralPower
            if self.spiralLevel <= 0 {
                
                self.thePlayer.sprite.run(finishGroup)
            }
        }
        let waitAdd = SKAction.sequence([SKAction.wait(forDuration: 0.1), add])
        let waitRemove = SKAction.sequence([SKAction.wait(forDuration: 0.1), removeTime])
        let endlessSpiral = SKAction.repeatForever(thePlayer.spiral)
        let endlessAdd = SKAction.repeatForever(waitAdd)
        let endlessRemove = SKAction.repeatForever(waitRemove)
        let endlessGroup = SKAction.group([endlessRemove, endlessAdd, endlessSpiral])
        
        

        thePlayer.sprite.run(SKAction.sequence([thePlayer.spiralEntrance, addSpeed, makeInvincible, endlessGroup]), withKey: "spiral")
        
        if !held {
            thePlayer.sprite.run(finishGroup)
        }
        
        
    }
    
    func beginSpin() {
        currentElement = Element(ofType: Tech.Layback, withSpeed: catSpeed, bySkater: thePlayer)
        speedChange = catSpeed
        currentMotion = Motion.Spinning
        spin()
    }
    
    func spin() {
        let spinTime : Double = 3 * thePlayer.spinPower

        let endSpin = SKAction.run(
        {
            [unowned self]  in
            self.thePlayer.sprite.removeAction(forKey:  "endSpin")
            self.thePlayer.setSpinTrans(spinType: Tech.Layback, stage: 100)
            
            //either set the multiplier to 1 or the amount of time spun divided by 10
            self.currentElement.setMultiplier(withNum: min(1, self.actionTimer / 5))
            self.updateScore()
            self.thePlayer.sprite.removeAction(forKey:  "timeAction")
            self.thePlayer.sprite.run(self.thePlayer.spin)
            self.currentMotion = Motion.Skating
            self.catSpeed = min(self.speedChange, self.thePlayer.maxSpeed)

            self.actionTimer = 0
            }
        )
        
        
        
        //adds time to the actionTimer variable
        let addAction = SKAction.run {
            [unowned self] in
            self.actionTimer += 0.1
        }
        
        let timeAction = SKAction.sequence([SKAction.wait(forDuration: 0.1), addAction])
        thePlayer.sprite.run(SKAction.repeatForever(timeAction), withKey: "timeAction")
        
        if thePlayer.sprite.action(forKey: "endSpin") == nil {
            let waitEnd = SKAction.sequence([SKAction.wait(forDuration: spinTime), endSpin])
            thePlayer.sprite.run(waitEnd, withKey: "endSpin")
        }
        
        if !held {
            thePlayer.sprite.removeAction(forKey: "spin")
            thePlayer.setSpinTrans(spinType: Tech.Layback, stage: currentElement.level + 1)
            thePlayer.sprite.run(SKAction.sequence([thePlayer.spin, endSpin]), withKey: "spin")
            
        } else {
            currentElement.addLevel()
            thePlayer.sprite.removeAction(forKey: "spin")
            let spinDone =
                thePlayer.setSpin(spinType: Tech.Layback, stage: currentElement.level)
            if !spinDone {
                thePlayer.sprite.run(thePlayer.spin, withKey: "spin")
            } else {
                thePlayer.sprite.run(endSpin)
            }
        }
    }
    
    
    func countReps(prevNum: Int) ->  Double {
        var staleCount : Double = 0
        var currIndex = 0
        for el in scoresheet {
            if scoresheet.count - currIndex < prevNum {
                if el.type == currentElement.type {
                    staleCount += 1
                }
            }
            currIndex += 1
            
        }
        
        if staleCount == 0 {
            staleCount = 1
        }
        return staleCount
    }
    
    func updateMomentum() {
        let staleCount = countReps(prevNum:5)
        
        switch currentElement.type {
            
        case .Loop, .Axel, .Flip, .Lutz, .Toe, .Salchow, .JumpCombo :
            spiralLevel += currentElement.score
            if currentElement.fall {
                timeLeft -= max(20,timeInt * 40)
                
            } else {
                timeLeft += currentElement.score
                
            }
            
        case .Layback :
            //print((actionTimer * 3) / staleCount)
            spiralLevel += currentElement.score
            timeLeft += max((actionTimer * timeInt) * thePlayer.spinPower / staleCount,(actionTimer * thePlayer.spinPower) / staleCount)
            
            print(staleCount)
        case .Spiral :
            timeLeft += currentElement.score
        default:
            break
        }
        if timeLeft > 60 {
            timeLeft = 60
        }
    }
    
    func updateBanana() {
        if banana.collected {
            banana.collected = false
        }
        banana.physicsBody?.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
        
        if banana.position.x + (banana.size.width / 2) < screen.position.x - (screen.size.width / 2) || banana.parent == nil {
            banana.removeFromParent()
            
            let rand = CGFloat(arc4random_uniform(101)) / 100
            banana.position.y = 100 + 400 * rand
            
            
            banana.position.x = 900
            banana.physicsBody?.affectedByGravity = true
            banana.alpha = 1
            screen.addChild(banana)
            
        }
    }
    
    func updateCoins() {
        for coin in coinArray {
            coin.physicsBody?.velocity.dx = coinFormation.form.physicsBody!.velocity.dx

            if coin.collected && coin.parent == nil {
                coin.collected = false

            }
            
        }
        
        
        if coinFormation.form.position.x + (coinFormation.form.size.width / 2) < screen.position.x - (screen.size.width / 2)  {
            coinFormation.form.removeFromParent()
            
            let rand = CGFloat(arc4random_uniform(101)) / 100
            coinFormation.form.position.y = -100 + 300 * rand
            
            
            coinFormation.form.position.x = 900
            let number = arc4random_uniform(4)
            
            coinFormation.setFormation(withForm: Int(number))

            screen.addChild(coinFormation.form)
            
        }
    }
    
    
    func replaceBackground() {
        for background in backgroundPieces {
            
            if background.frame.maxX < screen.frame.minX {
                let transformed = backgroundPieces.map { $0.frame.maxX }
                let maxX = transformed.max()
                background.position.x = maxX! + background.size.width / 2 - 30

            }
        }
        
        
    for background in backgroundPieces2 {
        
            if background.frame.maxX < screen.frame.minX {
                let transformed = backgroundPieces2.map { $0.frame.maxX }
                let maxX = transformed.max()
                background.position.x = maxX! + background.size.width / 2 - 30
                
            }
        }
    }
    
    func updateBackground() {
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 5)

        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 4)
        
        let backgroundTrans = fixed.childNode(withName: "trans")

        
        
        if imageName == "background7" {
            backgroundTrans?.zPosition = 3
        }
        switch backgroundNum {

        case 1:
            backgroundTrans?.zPosition = 3
            imageName = "background7"
            foregroundName = "foregroundtrans"
            
        case 2:

            imageName = "sky1"
            foregroundName = "foreground1"
            
        case 3:

            imageName = "background10"
            foregroundName = "foreground1"

        case 4:

            imageName = "background11"
            foregroundName = "foreground1"
            
        default:
            backgroundTrans?.run(fadeIn)


        }
        
        if imageName == nil || foregroundName == nil {
            return
        }

        let change = SKAction.run {
        [unowned self] in
        for background in self.backgroundPieces {
          background.texture = SKTexture(imageNamed: self.imageName!)
            }
        for background in self.backgroundPieces2 {
            background.texture = SKTexture(imageNamed: self.foregroundName!)
        }
        }
        
        let moveBack = SKAction.run {
            backgroundTrans?.zPosition = 1
            
        }
        
        backgroundTrans?.run(SKAction.sequence([fadeIn, change, SKAction.wait(forDuration: 3), fadeOut, moveBack]))
    }
    
    func updateTrampoline() {
        trampoline.physicsBody?.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
        let playerPos = thePlayer.sprite.position
        let trampUpperEdge = trampoline.position.y - trampoline.size.height / 2
        let playerFoot = playerPos.y - thePlayer.sprite.size.height / CGFloat(thePlayer.footDiv)
        let trampRightEdge = trampoline.position.x + trampoline.size.width / 2
        let playerXEdge = playerPos.x - thePlayer.sprite.size.width / 8
        
        //set collisions and contacts only if the player is moving down and the platform is at player's foot area
        if trampUpperEdge < playerFoot && trampRightEdge > playerXEdge && (thePlayer.sprite.physicsBody?.velocity.dy)! <= CGFloat(0) && !allOff {
            trampoline.alpha = 1
            trampoline.physicsBody!.categoryBitMask = SkaterCategory
            trampoline.physicsBody!.collisionBitMask = 0
            trampoline.physicsBody!.contactTestBitMask = SkaterCategory
            

        } else {
            trampoline.physicsBody!.categoryBitMask = 0
            trampoline.physicsBody!.collisionBitMask = 0
            trampoline.physicsBody!.contactTestBitMask = 0

            //trampoline.alpha = 0.4

        }
        
        if trampoline.position.x + (trampoline.size.width / 2) < screen.position.x - (screen.size.width / 2) {
            trampoline.removeFromParent()
            let xNumber = 2000 + arc4random_uniform(2000)

            trampoline.position.x = CGFloat(xNumber)
            let number = arc4random_uniform(200)
            trampoline.position.y = CGFloat(number)
            screen.addChild(trampoline)
            
        }
    }
    
    func updatePlatforms(platArr: inout [SKSpriteNode], platForm: Formation) {
        var allGone = true
        var count = 0
        platForm.form.physicsBody?.velocity.dx =  coinFormation.form.physicsBody!.velocity.dx
        marker.removeFromParent()
        marker.position.x = 0
        marker.position.y = thePlayer.sprite.position.y - thePlayer.sprite.size.height / CGFloat(thePlayer.footDiv)
        screen.addChild(marker)
        
        for platform in platArr {
            platform.physicsBody?.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
            let platformPos = platForm.form.convert(platform.position, to: screen)
            let playerPos = thePlayer.sprite.position
            let platUpperEdge = platformPos.y - platform.size.height / 2
            let playerFoot = playerPos.y - thePlayer.sprite.size.height / CGFloat(thePlayer.footDiv)
            let platRightEdge = platformPos.x + platform.size.width / 2
            let playerXEdge = playerPos.x - thePlayer.sprite.size.width / 8

            //set collisions and contacts only if the player is moving down and the platform is at player's foot area
            if platUpperEdge < playerFoot && platRightEdge > playerXEdge && (thePlayer.sprite.physicsBody?.velocity.dy)! <= CGFloat(0) && !allOff {
                platform.physicsBody!.categoryBitMask = SkaterCategory
                platform.physicsBody!.collisionBitMask = 0
                platform.physicsBody!.contactTestBitMask = SkaterCategory
 
               //platform.color = UIColor(red: 0, green: 1, blue: 0.2, alpha: 1)
                
                
            } else {
               
                platform.physicsBody!.categoryBitMask = 0
                platform.physicsBody!.collisionBitMask = 0
                platform.physicsBody!.contactTestBitMask = 0
                //platform.color = UIColor(red: 0, green: 1, blue: 1, alpha: 0.5)
                
                
            }
            
            if platformPos.x + (platform.size.width / 2) > screen.position.x - (screen.size.width / 2) {
                allGone = false
            }
            count += 1
            
        }
        
        //if all platforms are off the screen, reset platforms
        
        if allGone  {
            platForm.form.removeFromParent()
            platForm.form.position.x = 900
            let number = 4 + arc4random_uniform(3)
            
            platForm.setFormation(withForm: Int(number))
            screen.addChild(platForm.form)
            
        }
        
        
    }
    
    func updateItems() {
        var allGone = true
        
        if currentItem.collected && currentItem.parent == nil {
            currentItem.collected = false
            
        }
        for item in itemArray {
            
            item.physicsBody?.velocity.dx = coinFormation.form.physicsBody!.velocity.dx

            if item.collected && item.parent == nil {
                item.collected = false
                
            }
            
            if item.position.x + (item.size.width / 2) < screen.position.x - (screen.size.width / 2) {
                item.removeFromParent()
                item.position.x = 900
                let rand = CGFloat(arc4random_uniform(101)) / 100
                item.position.y = -100 + 300 * rand
                
            }
            
            if item.parent != nil {
                allGone = false
            }
            
        }
        
        if allGone {
            let koi = itemArray[Int(0)]
            koi.position.x = 900
            
            let rand = CGFloat(arc4random_uniform(101)) / 100
            
            koi.position.y = -100 + 400 * rand
            koi.physicsBody?.velocity.dx = coinFormation.form.physicsBody!.velocity.dx
            screen.addChild(koi)
            
            
            let number = arc4random_uniform(2) + 1
            let item = itemArray[Int(number)]
            let rand2 = CGFloat(arc4random_uniform(101)) / 100

            item.position.x = 1300
            item.position.y = -100 + 400 * rand2
            
            screen.addChild(item)
            
        }
        
    }
    
    func updateGoalText () {
        
        var count = 0
        for goal in currentGoals.set {
            initGoalLabelArray[count].text = goal.text
            pauseGoalLabelArray[count].text = goal.text
            if goal.completed {
                let doneColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
                initGoalLabelArray[count].fontColor = doneColor
                let strike1 = initGoalLabelArray[count].childNode(withName: "strikethrough") as! SKSpriteNode
                strike1.color = doneColor
                pauseGoalLabelArray[count].fontColor = doneColor
                let strike2 = pauseGoalLabelArray[count].childNode(withName: "strikethrough") as! SKSpriteNode
                strike2.color = doneColor
            }

            count += 1
        }
    }
    
    func updateScore() {
        if currentElement == nil {
            return
        }
        currentElement.calcScore()
        score += currentElement.score
        if currentElement.type != Tech.None {
            scoresheet.append(currentElement)
        }
        
        if timeLeft > 0 {
        updateMomentum()
        }
        currentElement = Element(ofType: Tech.None, bySkater: thePlayer)
    }
    
    func cancelAllMoves() {
        thePlayer.sprite.removeAction(forKey: "jump")
        thePlayer.sprite.removeAction(forKey: "rotate")
        thePlayer.sprite.removeAction(forKey: "comboJump")

        thePlayer.sprite.removeAction(forKey: "spin")
        thePlayer.sprite.removeAction(forKey: "land")
        thePlayer.sprite.removeAction(forKey: "spiral")


    }
    
    func endCollisions() {
        for item in itemArray {
            item.physicsBody?.contactTestBitMask = 0
            item.physicsBody?.categoryBitMask = 0
            item.physicsBody?.collisionBitMask = 0

        }
        
        for coin in coinArray {
            coin.physicsBody?.contactTestBitMask = 0
            coin.physicsBody?.categoryBitMask = 0
            coin.physicsBody?.collisionBitMask = 0

        }
        
        for platform in platformArray {
            platform.physicsBody?.contactTestBitMask = 0
            platform.physicsBody?.categoryBitMask = 0
            platform.physicsBody?.collisionBitMask = 0
            
        }
        
        for platform in platformArray2 {
            platform.physicsBody?.contactTestBitMask = 0
            platform.physicsBody?.categoryBitMask = 0
            platform.physicsBody?.collisionBitMask = 0
            
        }
    }
    
    
    func moveAbovePlatform(plat: Collectible) {
        var platformPos : CGPoint
        platformPos = platFormation.form.convert(plat.position, to: screen)
        
        
        if plat.parent?.name == "form2" {
            platformPos = platFormation2.form.convert(plat.position, to: screen)
        }
        
        if plat.parent?.name == "form3" {
            platformPos = platFormation3.form.convert(plat.position, to: screen)
        }
        
        let platHeight = platformPos.y + plat.size.height / 2 + thePlayer.sprite.size.height / CGFloat(thePlayer.footDiv)
        
        stopJerk = true
        thePlayer.sprite.removeFromParent()
        thePlayer.sprite.position.y = platHeight
        screen.addChild(thePlayer.sprite)
        stopJerk = false


    }
    
    func moveItemAbovePlatform(plat: Collectible, toMove: SKSpriteNode) {
        var platformPos : CGPoint
        var itemPos = toMove.convert(toMove.position, to: screen)
        platformPos = platFormation.form.convert(plat.position, to: screen)
        
        
        if plat.parent?.name == "form2" {
            platformPos = platFormation2.form.convert(plat.position, to: screen)
        }
        
        if plat.parent?.name == "form3" {
            platformPos = platFormation3.form.convert(plat.position, to: screen)
        }
        
        let platHeight = platformPos.y + plat.size.height / 2 + toMove.size.height / 2
        
        //toMove.removeFromParent()
        let move = SKAction.moveTo(y: platHeight, duration: 0)
        toMove.run(move)
        //screen.addChild(toMove)
        
    }
    
    func makeFall() {
        cancelAllMoves()
        
        self.catSpeed = minSpeed
        self.thePlayer.sprite.physicsBody?.affectedByGravity = true
        self.currentMotion = Motion.Skating
        
        let postFall = SKAction.run{
            [unowned self] in
            self.timeLeft -= max(20,self.timeInt * 40)
            self.currentMotion = Motion.Skating
            self.thePlayer.sprite.physicsBody?.affectedByGravity = true
            
        }
        let fallDown = SKAction.sequence([self.thePlayer.fall, postFall])
        self.thePlayer.sprite.run(fallDown, withKey: "fall")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        
        
            if (nodeA.name == "player" && nodeB.name == "ground") || (contact.bodyB.node?.name == "player" && contact.bodyA.node?.name == "ground") {
                if currentMotion == Motion.Midair {

                    //if the player is already landing, don't land again
                    landJump()
                    thePlayer.sprite.physicsBody?.velocity.dy = 0
                    // thePlayer.sprite.physicsBody?.affectedByGravity = false
                    grounded = true
                }
            }
            
            if (nodeA.name == "player" && nodeB.name == "platform") {
                let platform = nodeB as! Collectible
                
                if currentMotion == Motion.Midair {

                currentMotion = Motion.Landing
                moveAbovePlatform(plat: platform)
                   
                landJump()

                platform.collected = true
                
                } else {
                    moveAbovePlatform(plat: platform)

                    thePlayer.sprite.physicsBody?.velocity.dy = 0
                    //currentMotion = Motion.Skating


                }
                
            }
            
            if (nodeB.name == "player" && nodeA.name == "platform") {
                let platform = nodeA as! Collectible
                
                if currentMotion == Motion.Midair {

                currentMotion = Motion.Landing
                    moveAbovePlatform(plat: platform)

                thePlayer.sprite.physicsBody?.velocity.dy = 0

                landJump()

                platform.collected = true
                } else {
                    moveAbovePlatform(plat: platform)

                    thePlayer.sprite.physicsBody?.velocity.dy = 0
                    //currentMotion = Motion.Skating

                }
                
            }
        
        
        
        
        if (nodeA.name == "banana" && nodeB.name == "ground") || (nodeB.name == "banana" && nodeA.name == "ground") {
            
            banana.physicsBody?.velocity.dy = 0
            banana.physicsBody?.affectedByGravity = false
            
            let groundHeight = -250 + banana.size.height / 2 - banana.size.height / 4
            
            let move = SKAction.moveTo(y: groundHeight, duration: 0)
            banana.run(move)

            
        }
        
        if (nodeA.name == "banana" && nodeB.name == "platform") {
            let platform = nodeB as! Collectible
            banana.physicsBody?.velocity.dy = 0
            banana.physicsBody?.affectedByGravity = false
            
            if (banana.physicsBody?.velocity.dy)! < CGFloat(0) {
            moveItemAbovePlatform(plat: platform, toMove: banana)
            }
            
        }
        
        if (nodeB.name == "banana" && nodeA.name == "platform") {
            let platform = nodeA as! Collectible

            banana.physicsBody?.velocity.dy = 0
            banana.physicsBody?.affectedByGravity = false
            if (banana.physicsBody?.velocity.dy)! < CGFloat(0) {
                moveItemAbovePlatform(plat: platform, toMove: banana)
            }
        }
        
        
        if (nodeA.name == "player" && nodeB.name == "banana") {
            let theBanana = contact.bodyB.node as! Collectible
            if theBanana.physicsBody == nil {return}
            if theBanana.parent == nil {return}
            if thePlayer.sprite.action(forKey: "fall") == nil && currentMotion != Motion.Midair &&  currentMotion != Motion.Landing &&  currentMotion != Motion.Spiral && !invincible {
                if !theBanana.collected {
                    
                    consumeBanana(forBanana: theBanana)
                    
                }
            } else {
                if thePlayer.sprite.action(forKey: "fall")
                    != nil {
                    return
                }
                smashBanana(forBanana: theBanana)
            }
        
            
        } else if (nodeB.name == "player" && nodeA.name == "banana") {
            let theBanana = contact.bodyA.node as! Collectible
            if theBanana.physicsBody == nil {return}
            if theBanana.parent == nil {return}
            
            if thePlayer.sprite.action(forKey: "fall") == nil && currentMotion != Motion.Midair &&  currentMotion != Motion.Landing &&  currentMotion != Motion.Spiral && !invincible {

                consumeBanana(forBanana: theBanana)

                

                
            } else {
                if thePlayer.sprite.action(forKey: "fall") != nil {
                    return
                }
                smashBanana(forBanana: theBanana)
            }
            
        
        }
        
        
        
        if (nodeA.name == "player" && nodeB.name == "coin") {
            let theCoin = contact.bodyB.node as! Collectible
            if theCoin.physicsBody == nil {return}
            if theCoin.parent == nil {return}
            if !theCoin.collected {
                consumeCoin(coin: theCoin)
                
            }
            
        } else if (nodeB.name == "player" && nodeA.name == "coin") {
            let theCoin = contact.bodyA.node as! Collectible
            if theCoin.physicsBody == nil {return}
            if theCoin.parent == nil {return}
            if !theCoin.collected {
                consumeCoin(coin: theCoin)
                
            }
            
        }
        
        if (nodeA.name == "player" && nodeB.name == "butterfly") {
            let theButterfly = contact.bodyB.node as! Collectible
            if theButterfly.physicsBody == nil {return}
            if theButterfly.parent == nil {return}
            if !theButterfly.collected {
                consumeButterfly(butterfly: theButterfly)
            }
            
        } else if (nodeB.name == "player" && nodeA.name == "butterfly") {
            let theButterfly = contact.bodyA.node as! Collectible
            if theButterfly.physicsBody == nil {return}
            if theButterfly.parent == nil {return}
            if !theButterfly.collected {
                consumeButterfly(butterfly: theButterfly)
            }
            
        }
        
        
        if (nodeA.name == "player" && nodeB.name == "pineapple") {
            let thePineapple = contact.bodyB.node as! Collectible
            if thePineapple.physicsBody == nil {return}
            if thePineapple.parent == nil {return}
            if !thePineapple.collected {
                consumePineapple(pineapple: thePineapple)
                
            }
            
        } else if (nodeB.name == "player" && nodeA.name == "pineapple") {
            let thePineapple = contact.bodyA.node as! Collectible
            if thePineapple.physicsBody == nil {return}
            if thePineapple.parent == nil {return}
            if !thePineapple.collected {
                consumePineapple(pineapple: thePineapple)
                
            }
            
        }
        
        
        if (nodeA.name == "player" && nodeB.name == "koi") {
            let theKoi = contact.bodyB.node as! Collectible
            if theKoi.physicsBody == nil {return}
            if theKoi.parent == nil {return}
            if !theKoi.collected && currentMotion != Motion.Spiral {
                consumeKoi(koi: theKoi)
                
            }
            
        } else if (nodeB.name == "player" && nodeA.name == "koi") {
            let theKoi = contact.bodyA.node as! Collectible
            if theKoi.physicsBody == nil {return}
            if theKoi.parent == nil {return}
            if !theKoi.collected && currentMotion != Motion.Spiral {
                consumeKoi(koi: theKoi)
                    
                }
                
            }
        
        
        if (nodeA.name == "player" && nodeB.name == "trampoline") {
            let trampoline = nodeB as! Collectible
            thePlayer.sprite.physicsBody?.velocity.dy = 500
            trampoline.run(SKAction(named: "TrampolineBounce")!)

            
        } else if (nodeB.name == "player" && nodeA.name == "trampoline") {
            let trampoline = nodeA as! Collectible
            thePlayer.sprite.physicsBody?.velocity.dy = 500
            trampoline.run(SKAction(named: "TrampolineBounce")!)


            
        }
    }
    
    
    func smashBanana (forBanana: Collectible) {
        burstItem(item: forBanana)
        bananaSmash += 1
        banana.collected = true
    }
    func consumeBanana(forBanana: Collectible) {
        
        let remove = SKAction.run {
            [unowned self] in
            forBanana.removeFromParent()
            forBanana.collected = true
            forBanana.alpha = 1
            let rand = CGFloat(arc4random_uniform(101)) / 100
            let newY = 100 + 400 * rand
            
            forBanana.position = CGPoint(x: 900, y: newY)
            forBanana.physicsBody?.affectedByGravity = true
            self.screen.addChild(forBanana)
            forBanana.collected = false
        }
        
        let aniRemove = SKAction.sequence([SKAction(named:"BananaFlip")!, SKAction.fadeAlpha(to: 0, duration: 0.2), remove])
        
        forBanana.run(aniRemove)
        cancelAllMoves()
        
        self.catSpeed = minSpeed
        self.thePlayer.sprite.physicsBody?.affectedByGravity = true
        
        self.currentMotion = Motion.Skating
        
        makeFall()
        forBanana.collected = true
    }
    
    func consumeCoin(coin: Collectible) {
        burstItem(item: coin)
        coins += 1
        coin.collected = true
    }
    
    
    func consumeKoi(koi: Collectible) {
        cancelAllMoves()
        thePlayer.sprite.removeAction(forKey: "fall")
        self.thePlayer.sprite.physicsBody?.affectedByGravity = true
        self.currentMotion = Motion.Skating
        
        burstItem(item: koi)
        catSpeed += 200
        if currentElement.type == Tech.None {
            beginJump(withType: .Loop, withTakeoff: .loopTakeoff)
        } else {
            beginComboJump(withType: .Loop)
            
        }
        numKois += 1
        koi.collected = true
    }
    
    func consumePineapple(pineapple: Collectible) {
        burstItem(item: pineapple)
        timeLeft += 60
        numPineapples += 1
        pineapple.collected = true
    }
    
    func consumeButterfly(butterfly: Collectible) {
        burstItem(item: butterfly)
        catSpeed += 800
        invincible = true
        butterfly.collected = true
        
        let reduceSpeed = SKAction.run {
            [unowned self] in
            self.invincible = false
            self.catSpeed = max(self.minSpeed, self.catSpeed - 200)
        }
        let waitReduce = SKAction.sequence([SKAction.wait(forDuration: 0.1), reduceSpeed])
        let repeatReduce = SKAction.repeat(waitReduce, count: 4)
        thePlayer.sprite.run(SKAction.sequence([SKAction.wait(forDuration: 1), repeatReduce]))
        numButterflies += 1
    }
    
    func burstItem(item: Collectible) {
        let removeItem = SKAction.run {
            item.removeFromParent()
        }
        item.run(SKAction.sequence([SKAction(named: "Snowburst")!, removeItem]))
    }
    
    func presentPostGame() {
        let postGameScene = SKScene(fileNamed: "PostGameScene")
        postGameScene?.scaleMode = SKSceneScaleMode.aspectFill
        postGameScene?.userData = NSMutableDictionary()
        postGameScene?.userData?.setValue(scoresheet, forKey: "scoresheet")
        postGameScene?.userData?.setValue(score, forKey: "score")
        postGameScene?.userData?.setValue(coins, forKey: "coins")
        
        self.scene?.view?.presentScene(postGameScene!)
    }
    

    
    func swipedRight() {
        if(!gamePaused) {
            
            addInput(withInt: 2)
            if (catSpeed < 1200) {
                
                catSpeed += 20
            }
            decodeAction()
        }
    }
    
    func swipedLeft() {
        if(!gamePaused) {
            
            addInput(withInt: 1)
            decodeAction()
        }
    }
    
    func swipedUp() {
        if(!gamePaused) {
            
            addInput(withInt: 3)
            decodeAction()
        }
    }
    
    func swipedDown() {
        if(!gamePaused) {
            addInput(withInt: 4)
            decodeAction()
        }
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        held = true
        
        let waitTime = SKAction.wait(forDuration: 0.1)
        let countUp = SKAction.run(
        {[unowned self] in
            self.holdTime += 0.1
            
        })
        
        
        let countUpSeq = SKAction.sequence([waitTime,countUp])
        
        screen.run(SKAction.repeatForever(countUpSeq), withKey: "heldTime")
        
        let converted = convert(pos, to: fixed)
        if pauseButton.contains(converted) {
            gamePaused = !gamePaused
            if gamePaused {
                screen.isPaused = true
                
                physicsWorld.speed = 0
                fixed.addChild(pausebox)
                
            } else {
                screen.isPaused = false
                physicsWorld.speed = 1.0
                pausebox.removeFromParent()
                
            }
            
        }
        
        if gamePaused {
            let pausePos = convert(pos, to: pausebox)
            if restartLabel.contains(pausePos) {
                let newGame = SKScene(fileNamed: "GameScene")
                newGame?.scaleMode = SKSceneScaleMode.aspectFill
                self.scene?.view?.presentScene(newGame!)
            }
            
            if quitLabel.contains(pausePos) {
                let startScene = SKScene(fileNamed: "StartScene")
                startScene?.scaleMode = SKSceneScaleMode.aspectFill
                self.scene?.view?.presentScene(startScene!)
            }
            
            if resumeLabel.contains(pausePos) {
                physicsWorld.speed = 1.0
                pausebox.removeFromParent()
                screen.isPaused = false
                gamePaused = !gamePaused

            }
        }
        
        
        if(changeScene) {
            presentPostGame()
        }
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        held = false
        holdTime = 0
        screen.removeAction(forKey: "heldTime")
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    //print(currentMotion)
        //print("1: " + String(Double(platFormation.form.physicsBody!.velocity.dx)))
        //print("2: " + String(Double(platFormation2.form.physicsBody!.velocity.dx)))

        if gamePaused {
            screen.isPaused = true
            
            self.physicsWorld.speed = 0
        } else {
            screen.isPaused = false
            self.physicsWorld.speed = 1.0
            
        }
        
        
        if !stopJerk {
        cam?.position.y = thePlayer.sprite.position.y / 1.5
        }
        replaceBackground()
        updateCoins()
        updateItems()
        updateBanana()
        updateTrampoline()
        updatePlatforms(platArr: &platformArray, platForm: platFormation)
        updatePlatforms(platArr: &platformArray2, platForm: platFormation2)
        updatePlatforms(platArr: &platformArray3, platForm: platFormation3)
        updateGoalText ()
        if currentElement == nil {
            print("nil")
        } else {
        print(currentElement.type)
        }
        for el in currentGoals.set {
            el.updateTotal(bananas: bananaSmash, kois: numKois, butterflies: numButterflies, pineapples: numPineapples, coins: coins)
            
        }



    }
    
}

