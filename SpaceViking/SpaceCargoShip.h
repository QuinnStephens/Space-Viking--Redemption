//
//  SpaceCargoShip.h
//  SpaceViking
//
//  Created by Quinn Stephens on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface SpaceCargoShip : GameObject{
  BOOL hasDroppedMallet;
  id <GameplayLayerDelegate> delegate;
}

@property (nonatomic, assign) id <GameplayLayerDelegate> delegate;

@end
