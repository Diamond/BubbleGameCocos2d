//
//  TitleScreen.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TitleScreen.h"
#import "MainScene.h"
#import "EndlessScene.h"

@implementation TitleScreen

-(void)playNormal
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:FALSE forKey:@"resumeLevel"];
    [defaults synchronize];
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)continueNormal
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:@"resumeLevel"];
    [defaults synchronize];
    
    MainScene *gameplayScene = (MainScene*)[CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)playEndless
{
    EndlessScene *gameplayScene = (EndlessScene*)[CCBReader loadAsScene:@"EndlessScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)viewHighScores
{
    CCLOG(@"Not implemented yet.");
}

@end
