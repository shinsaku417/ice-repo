//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Shinsaku Uesugi 8/21/14
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

- (void)play {
    NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
    if ([gameState boolForKey:@"tutorial"]) {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"GamePlay"];
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
        [[CCDirector sharedDirector] presentScene:gameplayScene withTransition:transition];
    } else {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Tutorial"];
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
        [[CCDirector sharedDirector] presentScene:gameplayScene withTransition:transition];
    }
}

@end
