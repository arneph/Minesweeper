//
//  Preferences.h
//  Minesweeper
//
//  Created by Programmieren on 25.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PreferencesChangedNotification @"PreferencesChangedNotification"

#define MapSize [Preferences sharedPreferences].mapSize
#define MinesPerMap [Preferences sharedPreferences].minesPerMap

#define UseStandardNameForHighscores [Preferences sharedPreferences].useStandardNameForHighscores
#define StandardNameForHighscores [Preferences sharedPreferences].standardNameForHighscores

#define PlaySounds [Preferences sharedPreferences].playSounds

#define PauseOnDeactivate [Preferences sharedPreferences].pauseOnDeactivate

@interface Preferences : NSObject

+ (Preferences*)sharedPreferences;

- (void)load;
- (void)save;

- (void)stopSendingNotifications;
- (void)continueSendingNotifications;
- (void)continueSendingNotificationsWithChangedNotification;

- (CGFloat)squareSize;
- (void)setSquareSize: (CGFloat)squareSize;

- (NSSize)mapSize;
- (void)setMapSize: (NSSize)mapSize;

- (NSUInteger)minesPerMap;
- (void)setMinesPerMap: (NSUInteger)minesPerMap;

- (BOOL)useStandardNameForHighscores;
- (void)setUseStandardNameForHighscores: (BOOL)useStandardName;

- (NSString*)standardNameForHighscores;
- (void)setStandardNameForHighscroes: (NSString*)standardName;

- (BOOL)playSounds;
- (void)setPlaySounds: (BOOL)playSounds;

- (BOOL)pauseOnDeactivate;
- (void)setPauseOnDeactivate: (BOOL)pauseOnDeactivate;

@end
