//
//  Preferences.m
//  Minesweeper
//
//  Created by Programmieren on 25.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import "Preferences.h"

const Preferences *sharedPreferences;

@implementation Preferences{
    BOOL sendNotifications;
    
    CGFloat squareSize;
    NSSize mapSize;
    NSUInteger minesPerMap;
    BOOL useStandardNameForHighscores;
    NSString *standardNameForHighscores;
    BOOL dontPlaySounds;
    BOOL pauseOnDeactivate;
}

#pragma mark Init

+ (Preferences*)sharedPreferences{
    if (!sharedPreferences) {
        sharedPreferences = [[Preferences alloc] init];
    }
    return (Preferences*)sharedPreferences;
}

- (id)init{
    if (sharedPreferences) {
        return (Preferences*)sharedPreferences;
    }
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

#pragma mark Load/Save

- (void)load{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    squareSize = [defaults floatForKey:@"squareSize"];
    
    NSUInteger mapSizeWidth = [defaults integerForKey:@"mapSizeWidth"];
    NSUInteger mapSizeHeight = [defaults integerForKey:@"mapSizeHeight"];
    if (mapSizeWidth == 0) {
        mapSizeWidth = 8;
    }
    if (mapSizeHeight == 0) {
        mapSizeHeight = 8;
    }
    mapSize = NSMakeSize(mapSizeWidth, mapSizeHeight);
    
    minesPerMap = [defaults integerForKey:@"minesPerMap"];
    if (minesPerMap == 0) {
        minesPerMap = 10;
    }
    
    useStandardNameForHighscores = [defaults boolForKey:@"useStandardNameForHighscores"];
    
    standardNameForHighscores = [defaults objectForKey:@"standardNameForHighscores"];
    if (!standardNameForHighscores) {
        standardNameForHighscores = @"";
    }
    
    dontPlaySounds = [defaults boolForKey:@"dontPlaySounds"];
    pauseOnDeactivate = [defaults boolForKey:@"pauseOnDeactivate"];
}

- (void)save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:squareSize forKey:@"squareSize"];
    
    [defaults setInteger:mapSize.width forKey:@"mapSizeWidth"];
    [defaults setInteger:mapSize.height forKey:@"mapSizeHeight"];
    
    [defaults setInteger:minesPerMap forKey:@"minesPerMap"];
    
    [defaults setBool:useStandardNameForHighscores forKey:@"useStandardNameForHighscores"];
    [defaults setObject:standardNameForHighscores forKey:@"standardNameForHighscores"];
    
    [defaults setBool:dontPlaySounds forKey:@"dontPlaySounds"];
    
    [defaults setBool:pauseOnDeactivate forKey:@"pauseOnDeactivate"];
}

#pragma mark Notifications

- (void)stopSendingNotifications{
    sendNotifications = NO;
}

- (void)continueSendingNotifications{
    sendNotifications = YES;
}

- (void)continueSendingNotificationsWithChangedNotification{
    sendNotifications = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:PreferencesChangedNotification
                                                        object:self];
}

#pragma mark Values

- (CGFloat)squareSize{
    return squareSize;
}

- (void)setSquareSize:(CGFloat)newSquareSize{
    squareSize = newSquareSize;
    if (sendNotifications)
        [[NSNotificationCenter defaultCenter] postNotificationName:PreferencesChangedNotification
                                                            object:self];
}

- (NSSize)mapSize{
    return mapSize;
}

- (void)setMapSize:(NSSize)newMapSize{
    mapSize = newMapSize;
    if (sendNotifications)
        [[NSNotificationCenter defaultCenter] postNotificationName:PreferencesChangedNotification
                                                            object:self];
}

- (NSUInteger)minesPerMap{
    return minesPerMap;
}

- (void)setMinesPerMap:(NSUInteger)newMinesPerMap{
    minesPerMap = newMinesPerMap;
    if (sendNotifications)
        [[NSNotificationCenter defaultCenter] postNotificationName:PreferencesChangedNotification
                                                            object:self];
}

- (BOOL)useStandardNameForHighscores{
    return useStandardNameForHighscores;
}

- (void)setUseStandardNameForHighscores: (BOOL)useStandardName{
    useStandardNameForHighscores = useStandardName;
    if (sendNotifications)
        [[NSNotificationCenter defaultCenter] postNotificationName:PreferencesChangedNotification
                                                            object:self];
}

- (NSString*)standardNameForHighscores{
    return standardNameForHighscores;
}

- (void)setStandardNameForHighscroes: (NSString*)standardName{
    standardNameForHighscores = standardName;
    if (sendNotifications)
        [[NSNotificationCenter defaultCenter] postNotificationName:PreferencesChangedNotification
                                                            object:self];
}

- (BOOL)playSounds{
    return !dontPlaySounds;
}

- (void)setPlaySounds:(BOOL)playSounds{
    dontPlaySounds = !playSounds;
    if (sendNotifications)
        [[NSNotificationCenter defaultCenter] postNotificationName:PreferencesChangedNotification
                                                            object:self];
}

- (BOOL)pauseOnDeactivate{
    return pauseOnDeactivate;
}

- (void)setPauseOnDeactivate:(BOOL)newPauseOnDeactivate{
    pauseOnDeactivate = newPauseOnDeactivate;
    if (sendNotifications)
        [[NSNotificationCenter defaultCenter] postNotificationName:PreferencesChangedNotification
                                                            object:self];
}

@end
