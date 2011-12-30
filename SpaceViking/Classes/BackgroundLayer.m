//
//  BackgroundLayer.m
//  SpaceViking
//
//  Created by Quinn Stephens on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

-(id) init{
  self = [super init];
  if(self!= nil){
    CCSprite *backgroundImage;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
      // game is running on iPad
      backgroundImage = [CCSprite spriteWithFile:@"background.png"];
    } else {
      backgroundImage = [CCSprite spriteWithFile:@"backgroundiPhone.png"];
      // cocos2d automatically selects for retina display
    }
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    [backgroundImage setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
    [self addChild:backgroundImage z:0 tag:0];
  }
  return self;
}

@end
