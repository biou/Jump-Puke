//
//  GCHelper.m
//  JumpNPuke
//
//  Created by Alain Vagner on 05/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
// Attention: je n'ai pas ajouté de paramètre à l'init pour régler la valeur de la propriété viewController pour ne pas alourdir le
// code. Ceci est cependant nécessaire pour l'appel à displayLeaderboard.

// Il semblerait que le système de scoreBuffer soit surtout nécessaire sous IOS 4.1. Sous IOS5, quand il n'y a pas de réseau dispo
// le systeme tentera tout seul de renvoyer les scores au retour de la connectivité (et donc pas de network error)
// -> cette fonctionnalité n'est pas testée, je n'ai pas d'IOS 4 pour tester.

#import "GCHelper.h"

@implementation GCHelper

@synthesize gameCenterAvailable;
@synthesize viewController;
@synthesize authChangeDelegate;
@synthesize scoreBuffer;
@synthesize scoreArchiveFile;

static GCHelper *sharedHelper = nil;

+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
			scoreArchiveFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/PrivateData/scores.archive"];
			[self loadScoreBuffer];
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

- (void) dealloc
{
	[self saveScoreBuffer];
	[super dealloc];
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



- (void)basicAuthenticationChanged {    
	
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
		NSLog(@"Authentication changed: player authenticated.");
		userAuthenticated = TRUE;

    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
		NSLog(@"Authentication changed: player not authenticated");
		userAuthenticated = FALSE;
    }
	if (authChangeDelegate) {
		[authChangeDelegate handleAuthChange:userAuthenticated];
	}
	
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
			NSLog(@"%@\n",i);
		}
		NSLog(@"end categories\n");
        // use the category and title information
		
	}];
	
}

- (void) reportScore: (int64_t)score forCategory: (NSString*)category
{
    if (!gameCenterAvailable) return;
	
    GKScore * scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];	
    scoreReporter.value = score;
	
	[scoreBuffer addObject:scoreReporter];	
	[self sendScoreBuffer];
	
}

-(void) sendScoreBuffer {
    if (!gameCenterAvailable || ![self isUserAuthenticated]) return;	
	
		NSLog(@"-SendScoreBuffer\n");
	for (NSUInteger i=0; i< scoreBuffer.count; i++) {
		GKScore * scoreReporter = [scoreBuffer objectAtIndex:i];
		[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {

			if (error == nil) {
					NSLog(@"--scoreSent: %lld\n", scoreReporter.value);
				[scoreBuffer removeObjectAtIndex:i];
			} else {
				NSLog(@"error reportScore: %@", error);
			}
		}];
	}
}

-(void) loadScoreBuffer {
    if (!gameCenterAvailable || ![self isUserAuthenticated]) return;
	
	NSLog(@"-LoadScoreBuffer\n");
	scoreBuffer = (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithFile:scoreArchiveFile];
	if (scoreBuffer == Nil) {
		scoreBuffer = [[NSMutableArray alloc] init];
	}

}

-(void) saveScoreBuffer {
	
    if (!gameCenterAvailable || ![self isUserAuthenticated]) return;
	NSLog(@"-SaveScoreBuffer\n");	
	BOOL result = [NSKeyedArchiver archiveRootObject:scoreBuffer
										 toFile:scoreArchiveFile];
	if (result == NO) {
		NSLog(@"Unable to save score data to local filesystem\n");
	}

}

-(void)displayLeaderboard {
    if (!gameCenterAvailable || ![self isUserAuthenticated]) return;
	
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
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewC
{
	// on revient à la vue standard (appelé par le tap sur le bouton "Done")
	[viewC dismissModalViewControllerAnimated:YES];
}
@end

