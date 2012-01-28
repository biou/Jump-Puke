//
//  AppDelegate.h
//  Test22
//
//  Created by Vincent on 28/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "JNPIntroScene.h"
#import "JNPIntroBaseLayer.h"
#import "JNPMenuScene.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
	
	CCDirectorIOS	*director_;							// weak ref

    JNPIntroScene *introScene;
    JNPIntroScene *introLayer;
	NSOperationQueue *queue;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, retain) NSOperationQueue *queue;

-(void) showMenuScene;

@end
