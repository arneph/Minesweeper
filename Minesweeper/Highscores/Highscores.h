//
//  Highscores.h
//  Minesweeper
//
//  Created by Programmieren on 25.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Highscore.h"

#define HighscoresChangedNotification @"HighscoresChangedNotification"

@interface Highscores : NSObject

+ (Highscores*)sharedHighscores;

- (NSArray*)highscoresArray;
- (void)sortHighscoresArrayUsingSortDescriptors: (NSArray*)descriptors;

- (void)addHighscore: (Highscore*)highscore;
- (void)clearHighscores;

@end
