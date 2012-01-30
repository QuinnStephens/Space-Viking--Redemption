//
//  PhaserBullet.h
//  SpaceViking
//
//  Created by Quinn Stephens on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameCharacter.h"

@interface PhaserBullet : GameCharacter{
  CCAnimation *firingAnim;
  CCAnimation *travelingAnim;
  
  PhaserDirection myDirection;
}

@property PhaserDirection myDirection;
@property (nonatomic, retain) CCAnimation *firingAnim;
@property (nonatomic, retain) CCAnimation *travelingAnim;

@end
