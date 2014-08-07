//
//  Credits.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 8/6/14.
//  Copyright (c) 2014 Sagadev/Brandon Richey. All rights reserved.
//

#import "CreditsScene.h"

@implementation CreditsScene

-(id)init {
    if (self = [super init]) {
        self.userInteractionEnabled = TRUE;
    }
    return self;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"TitleScreen"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
