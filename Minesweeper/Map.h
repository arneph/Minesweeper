//
//  Map.h
//  Minesweeper
//
//  Created by Programmieren on 21.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#define     MapSizeBeginner NSMakeSize(8, 8)
#define     MapSizeAdvanced NSMakeSize(16, 16)
#define MapSizeProfessional NSMakeSize(30, 16)

@protocol MapForSolver <NSObject>

@end

@interface Map : NSObject

+ (Map*)beginnerMap;
+ (Map*)advancedMap;
+ (Map*)professionalMap;

+ (Map*)mapWithSize: (NSSize)size;
- (id)initWithSize: (NSSize)size;

+ (Map*)mapWithSize:(NSSize)size andMines: (NSUInteger)nMines;
- (id)initWithSize:(NSSize)size andMines: (NSUInteger)nMines;

- (NSSize)size;

- (NSUInteger)numberOfMines;
- (NSUInteger)minesAroundPoint: (NSPoint)point;

- (BOOL)mineAtPoint: (NSPoint)point;
- (void)setMine: (BOOL)isMine atPoint: (NSPoint)point;

- (BOOL)isPointVisible: (NSPoint)point;
- (NSUInteger)visiblePointsArroundPoint: (NSPoint)point;
- (NSUInteger)invisiblePointsArroundPoint: (NSPoint)point;
- (void)setVisible: (BOOL)isVisible atPoint: (NSPoint)point;
- (BOOL)noPointVisible;
- (BOOL)allPointsVisible;
- (NSUInteger)numberOfVisiblePoints;
- (void)makeAllPointsVisible;

- (BOOL)isPointFlagged: (NSPoint)point;
- (NSUInteger)flaggedPointsArroundPoint: (NSPoint)point;
- (NSUInteger)unflaggedPointsArroundPoint: (NSPoint)point;
- (void)setFlagged: (BOOL)isFlagged atPoint: (NSPoint)point;

@end
