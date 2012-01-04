//
//  GameObject.h
//  SpaceViking
//
//  Created by Quinn Stephens on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "CommonProtocols.h"

@interface GameObject : CCSprite {
  BOOL isActive;
  BOOL reactsToScreenBoundaries;
  CGSize screenSize;
  GameObjectType gameObjectType;
}
@property (readwrite) BOOL isActive;
@property (readwrite) BOOL reactsToScreenBoundaries;
@property (readwrite) CGSize screenSize;
@property (readwrite) GameObjectType gameObjectType;

-(void)changeState:(CharacterStates)newState;
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects;
-(CGRect)adjustedBoundingBox;
-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className;

@end
