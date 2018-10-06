//
//  Skater.swift
//  Skating Friends
//
//  Created by Jake Oscar Te Lem on 6/11/18.
//  Copyright © 2018 Jake Oscar Te Lem. All rights reserved.
//

import Foundation
import SpriteKit


class ScrollingSprite : SKSpriteNode {
    var bottom : CGFloat!
    var top : CGFloat!
    var leftmost : CGFloat!
    var rightmost : CGFloat!

    var minX : CGFloat!
    var minY : CGFloat!
    var maxX : CGFloat!
    var maxY : CGFloat!
    
    init(withTexture: SKTexture!, withColor: UIColor!, withSize: CGSize, withFrame: SKNode) {
        super.init(texture: withTexture, color: withColor, size: withSize)
        leftmost = position.x - size.width/2
        rightmost = position.x + size.width/2
        bottom = position.y - size.height/2
        top = position.y + size.height/2

        minX = withFrame.frame.minX
        maxX = withFrame.frame.maxX

        minY = withFrame.frame.minY
        maxY = withFrame.frame.maxY


    }
    
    func setExtremes(posX : CGFloat, posY: CGFloat) {
        leftmost = posX - size.width/2
        rightmost = posX + size.width/2
        bottom = posY - size.height/2
        top = posY + size.height/2

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scroll (initial:CGPoint?, final:CGPoint?) {
        
        if(initial != nil && final != nil) {
            
            let transX = final!.x - initial!.x
            let transY = final!.y - initial!.y
        let newX = position.x + transX
        let newY = position.y + transY
         //  print(String(Double(newX)))

        setExtremes(posX: newX, posY: newY)
           /* print("right: " + String(Double(rightmost)))
            print("left: " + String(Double(leftmost)))
            print("top: " + String(Double(top)))
            print("bottom: " + String(Double(bottom)))
            print("minX: " + String(Double(minX)))
            print("minY: " + String(Double(minY)))
            print("maxX: " + String(Double(maxX)))
            print("maxY: " + String(Double(maxY)))
*/

        var finalX = position.x
        var finalY = position.y
        
            if(leftmost < minX && rightmost > maxX) {
                finalX = newX

            }
            
            if(bottom < minY && top > maxY) {
                finalY = newY
            }
            
        position = CGPoint(x: finalX, y: finalY)
        }
        }
    }

