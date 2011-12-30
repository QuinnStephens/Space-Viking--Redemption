//
//  GameplayLayer.m
//  SpaceViking
//
//  Created by Quinn Stephens on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayLayer.h"

@implementation GameplayLayer

-(id) init{
  self = [super init];
  if(self != nil){
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.isTouchEnabled = YES;
    
    vikingSprite = [CCSprite spriteWithFile:@"sv_anim_1.png"];
    [vikingSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height*0.17f)];
    [self addChild:vikingSprite];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
      // scale down Ole if not on iPad
      [vikingSprite setScaleX:screenSize.width/1024.0f];
      [vikingSprite setScaleY:screenSize.height/768.0f];
    }
    return self;
  }
}

@end
