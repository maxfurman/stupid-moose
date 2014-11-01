//
//  Moose.swift
//  Stupid Moose
//
//  Created by Maxwell Furman on 10/30/14.
//  Copyright (c) 2014 Maxwell Furman. All rights reserved.
//

import Foundation
import SpriteKit

class Moose : SKSpriteNode {
    
    var wobble: SKAction!

    class func instance() -> Moose {
        let texture = SKTexture(imageNamed:"Moose");
        let result = Moose(texture:texture);
        result.physicsBody = SKPhysicsBody(rectangleOfSize: result.frame.size);
        result.physicsBody!.mass = 1;
        result.physicsBody!.categoryBitMask = Constants.MOOSE_BIT_MASK;
    
//        let wobble1 = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1.0);
//        let wobble2 = SKAction.rotateByAngle(-CGFloat(M_PI), duration: 1.0);
//        result.wobble = SKAction.sequence([wobble1, wobble2]);
//
//        result.runAction(SKAction.repeatActionForever(result.wobble));
        
        return result;
    }
    
    func update(currentTime: CFTimeInterval) {

    }
    
    func jump() {
        if(self.physicsBody != nil) {
            self.physicsBody!.velocity = CGVectorMake(0, 0);
            self.physicsBody!.applyImpulse(CGVectorMake(0, 800));
        }
    }
    
    func die() {
        if (self.physicsBody != nil) {
//            self.physicsBody?.applyImpulse(CGVectorMake(-50, 200));
            self.physicsBody!.applyAngularImpulse(10);
        }
    }
}
