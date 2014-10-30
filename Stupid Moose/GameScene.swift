//
//  GameScene.swift
//  Stupid Moose
//
//  Created by Maxwell Furman on 10/30/14.
//  Copyright (c) 2014 Maxwell Furman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    let BACK_SCROLLING_SPEED: CGFloat = 0.5
    let FLOOR_SCROLLING_SPEED: CGFloat = 3.0
    let VERTICAL_GAP_SIZE: CGFloat = 120
    let FIRST_OBSTACLE_PADDING: CGFloat = 100
    let OBSTACLE_MIN_HEIGHT: CGFloat = 60
    let OBSTACLE_INTERVAL_SPACE: CGFloat = 130
    
    var floor : SKScrollingNode?
    var background : SKScrollingNode?
    var moose : Moose?
    var deadMoose = false


    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
        self.physicsWorld.contactDelegate = self;
        self.startGame();
    }
    
    func startGame() {
        self.createMoose()
        self.setBackground()
        
    }

    func setBackground() {
        self.background = SKScrollingNode.scrollingNode("treeLeftRight", containerWidth:self.frame.size.width);
        self.background!.scrollingSpeed = BACK_SCROLLING_SPEED;
        self.background!.anchorPoint = CGPointZero;
        self.background!.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame);

        self.addChild(background!);
    }

    func createMoose() {
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
    }
}
