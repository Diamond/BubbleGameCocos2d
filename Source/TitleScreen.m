//
//  TitleScreen.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TitleScreen.h"

@implementation TitleScreen

-(void)playNormal
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)playEndless
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)viewHighScores
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
