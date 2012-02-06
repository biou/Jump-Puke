//
//  GCHelper.m
//  JumpNPuke
//
//  Created by Alain Vagner on 05/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
// Attention: je n'ai pas ajouté de paramètre à l'init pour régler la valeur de la propriété viewController pour ne pas alourdir le
// code. Ceci est cependant nécessaire pour l'appel à displayLeaderboard.

#import "GCHelper.h"

@implementation GCHelper

@synthesize gameCenterAvailable;
@synthesize viewController;
@synthesize authenticationChanged;

static GCHelper *sharedHelper = nil;

+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}


- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer 
										   options:NSNumericSearch] != NSOrderedAscending);
	
    return (gcClass && osVersionSupported);
}

-(BOOL)isUserAuthenticated {
	return userAuthenticated;
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = 
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self 
                   selector:@selector(basicAuthenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName 
                     object:nil];
        }
    }
    return self;
}

- (void)basicAuthenticationChanged {    
	
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
		NSLog(@"Authentication changed: player authenticated.");
		userAuthenticated = TRUE;

    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
		NSLog(@"Authentication changed: player not authenticated");
		userAuthenticated = FALSE;
    }
	//[self performSelector:authenticationChanged withObject:[NSNumber numberWithBool:userAuthenticated]];
	
}

- (void)authenticateLocalUser { 
	
    if (!gameCenterAvailable) return;
	
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {     
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];        
    } else {
        NSLog(@"Already authenticated!");
    }
}

- (void) loadCategoryTitles
{
	
    [GKLeaderboard loadCategoriesWithCompletionHandler:^(NSArray *categories, NSArray *titles, NSError *error) {
        if (error != nil)
        {
			NSLog(@"Error: %@\n", error);
            // handle the error
        }
		NSLog(@"begin categories:\n");
		for(id i in categories) {
			NSLog(i);
		}
		NSLog(@"end categories\n");
        // use the category and title information
		
	}];
	
}

- (void) reportScore: (int64_t)score forCategory: (NSString*)category
{
    GKScore * scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];	
    scoreReporter.value = score;
	
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		NSLog(@"---Score Sent Successfully\n");
		if (error != nil)
		{
            NSLog(@"error reportScore: %@", error);
			// handle the reporting error
			/*  FIXME
			 If your application receives a network error, you should not discard the score. Instead, store the score object and attempt to report the player’s process at a later time. GKScore objects support the NSCoding protocol, so if necessary, they can be archived when your application terminates and unarchived after it launches.
			 */
        }
    }];
}

-(void)displayLeaderboard {
	
    if (!gameCenterAvailable) return;
	if (viewController == nil) {
		@throw [NSException exceptionWithName:@"ViewControllerNotSet"
				reason:@"viewController is not set in GCHelper"
				userInfo:nil];
	}
	
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];	
    if (leaderboardController != nil)		
    {
        leaderboardController.leaderboardDelegate = self;
		// on affiche le leaderboard
		[viewController presentModalViewController: leaderboardController animated: YES];
    }		
}


// implémentation de <GKLeaderboardViewControllerDelegate>
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	// on revient à la vue standard (appelé par le tap sur le bouton "Done")
	[viewController dismissModalViewControllerAnimated:YES];
}
@end

