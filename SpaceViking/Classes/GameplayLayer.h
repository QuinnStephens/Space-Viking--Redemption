//
//  GameplayLayer.h
//  SpaceViking
//
//  Created by Quinn Stephens on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedBase.h"

@interface GameplayLayer : CCLayer{
  CCSprite *vikingSprite;
  SneakyJoystick *leftJoystick;
  SneakyButton *jumpButton;
  SneakyButton *attackButton;
}

@end
