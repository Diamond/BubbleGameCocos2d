//
//  TitleScreen.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TitleScreen.h"

@implementation TitleScreen

-(void)play
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
