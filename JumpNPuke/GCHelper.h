//
//  GCHelper.h
//  JumpNPuke
//
//  Created by Alain Vagner on 05/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface GCHelper : NSObject <GKLeaderboardViewControllerDelegate> {
    BOOL userAuthenticated; 
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) UIViewController * viewController;
@property (assign) 	SEL authenticationChanged; 


+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
-(BOOL)isUserAuthenticated;
-(void)displayLeaderboard;

@end
