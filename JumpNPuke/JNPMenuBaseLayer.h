//
//  MenuBaseLayer.h
//  plop
//
//  Created by Alain Vagner on 22/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMenu.h"
#import "JNPAudioManager.h"
#import "GCHelper.h"
#import "JNPBasicLayer.h"
#import "JNPGameScene.h"


@interface JNPMenuBaseLayer : CCLayer <GCEnabled> {
    
}

+(CCScene *) scene;
-(void)startMenuAction;
-(void)setupMenu;
-(void)handleAuthChange:(BOOL) n;

@end
