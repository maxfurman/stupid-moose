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
    let FIRST_OBSTACLE_PADDING: CGFloat = 0
    let OBSTACLE_MIN_HEIGHT: CGFloat = 60
    let OBSTACLE_INTERVAL_SPACE: CGFloat = 330
    let MAX_DEAD_BOUNCES: Int = 3;
    
    var floor : SKScrollingNode?
    var background : SKScrollingNode?
    var moose : Moose?
    var deadMoose = false
    
    var rocks : [SKSpriteNode] = [];
    var nbObstacles = 0;
    var deadBounceCounter = 0;


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
        self.deadMoose = false
        self.deadBounceCounter = 0;
        self.removeAllChildren()
        
        self.setBackground()
        self.createFloor()
        self.createRocks()
        self.createMoose()
        
    }

    func setBackground() {
        self.background = SKScrollingNode.scrollingNode("treeLeftRight", containerSize:self.frame.size);
        background!.scrollingSpeed = BACK_SCROLLING_SPEED;
        background!.anchorPoint = CGPointZero;
        background!.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame);
        background!.physicsBody!.categoryBitMask = Constants.BACK_BIT_MASK;
        background!.physicsBody!.contactTestBitMask = Constants.MOOSE_BIT_MASK;

            self.addChild(background!);
    }

    func createMoose() {
        if (moose == nil) {
            moose = Moose.instance();
        } else {
            moose!.zRotation = 0;
        }
        moose!.position = CGPointMake(150,200);
        moose!.name = "moose";
        self.addChild(moose!);
    }
    
    func createFloor() {
        self.floor = SKScrollingNode.scrollingNode("floor", containerSize: self.frame.size) as SKScrollingNode;
        floor!.scrollingSpeed = FLOOR_SCROLLING_SPEED;
        floor!.anchorPoint = CGPointZero;
        floor!.name = "floor";
        
        floor!.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0,0, floor!.frame.size.width, floor!.frame.size.height));
        floor!.physicsBody!.mass = 0.1;
        floor!.physicsBody!.categoryBitMask = Constants.FLOOR_BIT_MASK;
        floor!.physicsBody!.contactTestBitMask = Constants.MOOSE_BIT_MASK;

        self.addChild(floor!)
        
    }
    
    func createRocks() {
        self.rocks = [];
        self.nbObstacles = Int(ceil(Double(self.frame.size.width)/Double(OBSTACLE_INTERVAL_SPACE)));
        var lastBlockPos:CGFloat = 0.0;
        
        for var i=0; i<self.nbObstacles ; i++ {
            let thisRock = SKSpriteNode(imageNamed: "rock");
            thisRock.anchorPoint = CGPointZero;
            self.addChild(thisRock);
            self.rocks.append(thisRock);
            
            if(i==0) {
                place(thisRock, xPos: self.frame.size.width + FIRST_OBSTACLE_PADDING);
            } else {
                place(thisRock, xPos: lastBlockPos + thisRock.frame.size.width +
                    OBSTACLE_INTERVAL_SPACE);
            }
            lastBlockPos = thisRock.position.x;
        }
    }
    
    func place(rock: SKSpriteNode, xPos: CGFloat) {
        
        rock.position = CGPointMake(xPos, 0.0);
        rock.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0,0, rock.frame.size.width, rock.frame.size.height));
        
        rock.physicsBody!.categoryBitMask = Constants.ROCK_BIT_MASK;
        rock.physicsBody!.contactTestBitMask = Constants.MOOSE_BIT_MASK;
        rock.name = "rock"

        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
            if (self.deadMoose == true) {
                startGame();
            } else {
                self.moose!.jump();
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (!self.deadMoose) {
            self.moose!.update(currentTime);
            self.background!.update(currentTime);
            self.floor!.update(currentTime);
            self.updateObstacles(currentTime);
        }
    }
    
    func updateObstacles(currentTime: NSTimeInterval) {
        if(self.moose!.physicsBody == nil) {
            return;
        }
        
        for var i=0; i<self.nbObstacles; i++ {

            let thisRock = self.rocks[i];
            
            if(thisRock.frame.origin.x < -thisRock.size.width) {
                let mostRightRock = self.rocks[(i+(self.nbObstacles-1))%self.nbObstacles];
                place(thisRock, xPos: mostRightRock.frame.origin.x + thisRock.frame.size.width + OBSTACLE_INTERVAL_SPACE);
            }
            
            thisRock.position = CGPointMake(thisRock.frame.origin.x - FLOOR_SCROLLING_SPEED, thisRock.frame.origin.y);
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch (contactMask) {
        case Constants.MOOSE_BIT_MASK | Constants.ROCK_BIT_MASK:
            if (self.deadBounceCounter < MAX_DEAD_BOUNCES) {
                self.deadBounceCounter++;
                self.deadMoose = true;
                self.moose!.die();
            }
        default:
            return
        }
    }
}
