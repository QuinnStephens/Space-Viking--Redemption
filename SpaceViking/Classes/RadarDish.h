//
//  RadarDish.h
//  SpaceViking
//
//  Created by Quinn Stephens on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameCharacter.h"

@interface RadarDish : GameCharacter{
  CCAnimation *tiltingAnim;
  CCAnimation *transmittingAnim;
  CCAnimation *takingAHitAnim;
  CCAnimation *blowingUpAnim;
  GameCharacter *vikingCharacter;
}

@property (nonatomic, retain) CCAnimation *tiltingAnim;
@property (nonatomic, retain) CCAnimation *transmittingAnim; 
@property (nonatomic, retain) CCAnimation *takingAHitAnim; 
@property (nonatomic, retain) CCAnimation *blowingUpAnim;

@end
