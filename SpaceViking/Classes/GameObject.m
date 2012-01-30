//
//  GameObject.m
//  SpaceViking
//
//  Created by Quinn Stephens on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject
@synthesize reactsToScreenBoundaries;
@synthesize screenSize;
@synthesize isActive;
@synthesize gameObjectType;

-(id)init{
  if(self == [super init]){
    CCLOG(@"GameObject init");
    screenSize = [CCDirector sharedDirector].winSize;
    isActive = TRUE;
    gameObjectType = kObjectTypeNone;
  }
  return self;
}

-(void)changeState:(CharacterStates)newState{
  CCLOG(@"GameObject->changeState method should be overridden");
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects{
  //CCLOG(@"updateStateWithDeltaTime method should be overridden");
}

-(CGRect)adjustedBoundingBox{
  //CCLOG(@"GameObject adjustedBoundingBox should be overridden");
  return [self boundingBox];
}

-(CCAnimation*)loadPlistForAnimationWithName:(NSString *)animationName andClassName:(NSString *)className{
  CCAnimation *animationToReturn = nil;
  NSString *fullFileName = [NSString stringWithFormat:@"%@.plist", className];
  NSString *plistPath;
  
  // Get the path to the plist file
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
  if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
    plistPath = [[NSBundle mainBundle] pathForResource:className ofType:@"plist"];
  }
  
  // Read in the plist file
  NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
  
  // If nil, file was not found
  if(plistDictionary == nil){
    CCLOG(@"Error reading plist: %@.plist", className);
    return nil;
  }
  
  // Get mini-dictionary for this animation
  NSDictionary *animationSettings = [plistDictionary objectForKey:animationName];
  if(animationSettings == nil){
    CCLOG(@"Could not locate AnimationWithName:%@", animationName);
    return nil;
  }
  
  // Get delay value for the animation
  float animationDelay = [[animationSettings objectForKey:@"delay"] floatValue];
  animationToReturn = [CCAnimation animation];
  [animationToReturn setDelay:animationDelay];
  
  // Add frames to the animation
  NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
  NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
  NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
  for(NSString *frameNumber in animationFrameNumbers){
    NSString *frameName = [NSString stringWithFormat:@"%@%@.png", animationFramePrefix,frameNumber];
    [animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
  }
  return animationToReturn;
}

@end
