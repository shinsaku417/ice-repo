//
//  GamePlay.m
//  ice
//
//  Created by Shinsaku Uesugi on 8/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation GamePlay  {
    CCPhysicsNode *_physicsNode;
    
    CCSprite *_bucketOne;
    CCSprite *_bucketTwo;
    CCSprite *_bucketThree;
    
    CCSprite *_bar;
    CCNodeColor *_ground;
    
    int _score;
    CCLabelTTF *_scoreLabel;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = true;
    _physicsNode.collisionDelegate = self;
}

- (void)onEnter {
    [super onEnter];
    
    NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
    [gameState setBool:false forKey:@"moveten"];
    [gameState setBool:false forKey:@"movehundred"];
    [gameState setBool:false forKey:@"movethousand"];
    [gameState setBool:false forKey:@"movetenthousand"];
    
    [gameState setBool:false forKey:@"scheduleFive"];
    [gameState setBool:false forKey:@"scheduleTen"];
    [gameState setBool:false forKey:@"scheduleThirty"];
    [gameState setBool:false forKey:@"scheduleFifty"];
    [gameState setBool:false forKey:@"scheduleHundred"];
    
    [self schedule:@selector(spawnIce) interval:2.f];
}

- (void)spawnIce {
    CCSprite *ice = (CCSprite*)[CCBReader load:@"ice"];
    NSLog(@"%@ ice", ice.physicsBody.collisionType);
    NSLog(@"%@ bar", _bar.physicsBody.collisionType);
    NSLog(@"%@ ground", _ground.physicsBody.collisionType);
    int rngBucket = arc4random() % 3;
    switch (rngBucket) {
        case 0:
            ice.positionInPoints = ccp(_bucketOne.positionInPoints.x, _bucketOne.positionInPoints.y -30);
            break;
        case 1:
            ice.positionInPoints = ccp(_bucketTwo.positionInPoints.x, _bucketTwo.positionInPoints.y - 30);
            break;
        default:
            ice.positionInPoints = ccp(_bucketThree.positionInPoints.x, _bucketThree.positionInPoints.y - 30);
    }
    [_physicsNode addChild:ice];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    float touchX = touchLocation.x / self.contentSizeInPoints.width;
    if (touchX < _bar.position.x) {
        if (_bar.position.x > 0.25) {
            _bar.position = ccp(_bar.position.x - 0.1, _bar.position.y);
        }
    } else {
        if (_bar.position.x < 0.75) {
            _bar.position = ccp(_bar.position.x + 0.1, _bar.position.y);
        }
    }
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ice:(CCSprite *)ice bar:(CCSprite *)bar {
    [ice removeFromParent];
    
    _score++;
    _scoreLabel.string = [NSString stringWithFormat:@"%i", _score];
    
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ice:(CCSprite *)ice ground:(CCNodeColor *)ground {
    NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
    [gameState setInteger:_score forKey:@"score"];
    if ([gameState integerForKey:@"score"] > [gameState integerForKey:@"highscore"]) {
        [gameState setInteger:_score forKey:@"highscore"];
    }
    
    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
    [[CCDirector sharedDirector] presentScene:recapScene];
    
    return TRUE;
}

- (void)update:(CCTime)delta {
    NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
    if (_score == 10 && ![gameState boolForKey:@"moveten"]) {
        _scoreLabel.position = ccp(_scoreLabel.position.x + 0.01, _scoreLabel.position.y);
        [gameState setBool:true forKey:@"moveten"];
    } else if (_score == 100 && ![gameState boolForKey:@"movehundred"]) {
        _scoreLabel.position = ccp(_scoreLabel.position.x + 0.01, _scoreLabel.position.y);
        [gameState setBool:true forKey:@"movehundred"];
    } else if (_score == 1000 && ![gameState boolForKey:@"movethousand"]) {
        _scoreLabel.position = ccp(_scoreLabel.position.x + 0.01, _scoreLabel.position.y);
        [gameState setBool:true forKey:@"movethousand"];
    } else if (_score == 10000 && ![gameState boolForKey:@"movetenthousand"]) {
        _scoreLabel.position = ccp(_scoreLabel.position.x + 0.01, _scoreLabel.position.y);
        [gameState setBool:true forKey:@"movetenthousand"];
    }
    
    if (_score == 5 && ![gameState boolForKey:@"scheduleFive"]) {
        [self unschedule:@selector(spawnIce)];
        [self schedule:@selector(spawnIce) interval:1.5f];
        [gameState setBool:true forKey:@"scheduleFive"];
    } else if (_score == 10 && ![gameState boolForKey:@"scheduleTen"]) {
        [self unschedule:@selector(spawnIce)];
        [self schedule:@selector(spawnIce) interval:1.25f];
        [gameState setBool:true forKey:@"scheduleTen"];
    } else if (_score == 30 && ![gameState boolForKey:@"scheduleThirty"]) {
        [self unschedule:@selector(spawnIce)];
        [self schedule:@selector(spawnIce) interval:1.f];
        [gameState setBool:true forKey:@"scheduleThirty"];
    } else if (_score == 50 && ![gameState boolForKey:@"scheduleFifty"]) {
        [self unschedule:@selector(spawnIce)];
        [self schedule:@selector(spawnIce) interval:0.9f];
        [gameState setBool:true forKey:@"scheduleFifty"];
    } else if (_score == 100 && ![gameState boolForKey:@"scheduleHundred"]) {
        [self unschedule:@selector(spawnIce)];
        [self schedule:@selector(spawnIce) interval:0.775f];
        [gameState setBool:true forKey:@"scheduleHundred"];
    }
}

@end
