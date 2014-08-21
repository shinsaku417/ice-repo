//
//  Tutorial.m
//  Save The ICE
//
//  Created by Shinsaku Uesugi on 8/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tutorial.h"

@implementation Tutorial

- (void)understand {
    NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
    [gameState setBool:true forKey:@"tutorial"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] presentScene:gameplayScene];
}

@end
