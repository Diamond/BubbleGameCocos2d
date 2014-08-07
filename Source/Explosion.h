//
//  Explosion.h
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 7/30/14.
//  Copyright (c) 2014 Sagadev/Brandon Richey. All rights reserved.
//

#import "CCSprite.h"

@interface Explosion : CCSprite

@property (nonatomic) BOOL active;

-(void)startAt:(CGPoint)location;

@end
