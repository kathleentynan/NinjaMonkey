//
//  GameScene.m
//  NinjaMonkey
//
//  Created by Carolyn Tynan on 2/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

{
    CCNode *monkey;
    CCPhysicsNode *_physicsNode;
    
    
}



- (void)didLoadFromCCB
{
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // visualize physics bodies 
    _physicsNode.debugDraw = TRUE;
    
    
    
    
    monkey.physicsBody.collisionType = @"monkeyCollision";
    monkey.physicsBody.collisionGroup = @"monkeyGroup";
    
    
    [self schedule:@selector(addZookeeper) interval:2.0];
    _physicsNode.collisionDelegate = self;
}





-(void)shoot
{
   
    CCNode *poop = [CCBReader load:@"poop"];
    poop.physicsBody.collisionGroup=@"monkeyGroup";
    poop.physicsBody.collisionType = @"poopCollision";
    poop.scaleX = .15f;
    poop.scaleY = .15f;
    
    CGPoint position = monkey.position;
    position.x += 100;
    poop.position = position;
    
    //CGPoint hit = ccp(1000,monkey.position.y);
    [_physicsNode addChild:poop];
    
    //[self addChild: poop];
    
    // manually create & apply a force to launch the penguin
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 800000);
    
    [poop.physicsBody applyForce:force];
    
    
}

-(void)jump
{
    CGPoint launchDirection = ccp(0, 1);
    CGPoint force = ccpMult(launchDirection, 60000);
    
    [monkey.physicsBody applyForce:force];
}

-(void)addZookeeper
{
    CCNode *zookeeper = [CCBReader load:@"zookeeper"];
    zookeeper.scale = .35;
    zookeeper.position = ccp(638,132);
    zookeeper.physicsBody.collisionGroup = @"zookeeperGroup";
    zookeeper.physicsBody.collisionType = @"zookeeperCollision";
    [_physicsNode addChild:zookeeper];
    
    CCNode *gorilla = [CCBReader load:@"gorilla"];
    gorilla.scale = .35;
    gorilla.position= ccp(639,132);
    gorilla.physicsBody.collisionGroup = @"zookeeperGroup";
    [_physicsNode addChild:gorilla];
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
   
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:ccp(100,132)];
    CCAction *actionRemove = [CCActionRemove action];
    [zookeeper runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair zookeeperCollision:(CCNode *)zookeeper poopCollision:(CCNode *)poop
{
    [zookeeper removeFromParent];
    [poop removeFromParent];
    return YES;
    
    
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair zookeeperCollision:(CCNode *)zookeeper monkeyCollision:(CCNode *)monkey
{
    CCScene *GameOver = [CCBReader loadAsScene:@"GameOver"];
    [[CCDirector sharedDirector] replaceScene:GameOver];
}



@end
