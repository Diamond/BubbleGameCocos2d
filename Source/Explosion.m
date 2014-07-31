//
//  Explosion.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

-(id)init
{
    if (self = [super init]) {

    }
    return self;
}

-(void)didLoadFromCCB
{
    self.anchorPoint = ccp(0.5, 0.5);
    self.position    = ccp(self.contentSize.width/2, self.contentSize.height/2);
}

-(void)update:(CCTime)delta
{
    CGSize newSize = CGSizeMake(self.contentSize.width * self.scale, self.contentSize.height * self.scale);
    self.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:newSize.width/2 andCenter:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    self.physicsBody.collisionType = @"explosion";
    self.physicsBody.collisionMask = @[@"bubble"];
    self.physicsBody.affectedByGravity = FALSE;
}

@end
