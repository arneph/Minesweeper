//
//  Highscores.m
//  Minesweeper
//
//  Created by Programmieren on 25.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import "Highscores.h"

const Highscores *sharedHighscores;

@implementation Highscores{
    NSMutableArray *highscores;
}

#pragma mark Init

+ (Highscores*)sharedHighscores{
    if (!sharedHighscores) {
        sharedHighscores = [[Highscores alloc] init];
    }
    return (Highscores*)sharedHighscores;
}

- (id)init{
    if (sharedHighscores) {
        return (Highscores*)sharedHighscores;
    }
    self = [super init];
    if (self) {
        highscores = [[NSMutableArray alloc] init];
        [self load];
    }
    return self;
}

#pragma mark Load/Save

- (void)load{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"highscores"];
    if (!data) {
        return;
    }
    highscores = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
}

- (void)save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:highscores] forKey:@"highscores"];
}

#pragma mark Public Methods

- (NSArray*)highscoresArray{
    return [NSArray arrayWithArray:highscores];
}

- (void)sortHighscoresArrayUsingSortDescriptors:(NSArray *)descriptors{
    [highscores sortUsingDescriptors:descriptors];
}

- (void)addHighscore: (Highscore*)highscore{
    if (highscore) {
        [highscores addObject:highscore];
        [[NSNotificationCenter defaultCenter] postNotificationName:HighscoresChangedNotification object:self];
        [self save];
    }
}

- (void)clearHighscores{
    [highscores removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:HighscoresChangedNotification object:self];
    [self save];
}

@end
