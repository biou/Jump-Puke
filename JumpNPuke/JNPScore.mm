//
//  JNPScore.mm
//  JumpNPuke
//
//  Created by Alain Vagner on 29/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPScore.h"

static JNPScore * instance = nil;

@implementation JNPScore

+(JNPScore *)jnpscore {
	if (instance == nil) {
		@synchronized(self) {
			if (instance == nil) {
				instance = [[super alloc] init ];
			}
		}
	}
	return instance;
}

- (id)init {
    self = [super init];
    if (self) {
		level=1;
		score=0;
    }
    return self;
}

-(int)getScore
{
	return score;
}

-(void)setScore:(int)s
{
	score = s;
}

-(void)incrementScore:(int)s
{
	score+=s;	
}

-(int)getLevel
{
	return level;
}

-(void)setLevel:(int)l
{
	level = l;
}

-(void)incrementLevel
{
	level++;	
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
			/*
			 If your application receives a network error, you should not discard the score. Instead, store the score object and attempt to report the player’s process at a later time. GKScore objects support the NSCoding protocol, so if necessary, they can be archived when your application terminates and unarchived after it launches.
			*/
        }
    }];
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

- (void)dealloc {
    self.vomis = nil;
    [super dealloc];
}

@synthesize vomis;

@end
