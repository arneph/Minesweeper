//
//  MapView.h
//  Minesweeper
//
//  Created by Programmieren on 21.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Map.h"

#define SmallSquareSize 25
#define MediumSquareSize 30
#define LargeSquareSize 35

@protocol MapViewDelegate <NSObject>

- (Map*)map;
- (BOOL)activeGame;
- (BOOL)pausedGame;

- (NSPoint)failurePoint;

- (void)clickedPoint: (NSPoint)point;
- (void)markedPoint: (NSPoint)point;

- (void)startSolver;

@end

@interface MapView : NSView

@property CGFloat squareWidth;

@property IBOutlet id<MapViewDelegate> delegate;

@property BOOL blockUserEvents;

@property id targetForMouseMoveFinished;
@property SEL selectorForMouseMoveFinished;

- (void)refresh;
- (void)refreshPoint: (NSPoint)point;
- (void)refreshPointsInRect: (NSRect)rect;

- (void)moveMouseToPoint: (NSPoint)point animated: (BOOL)animate;

- (void)clickPoint: (NSPoint)point;
- (void)markPoint: (NSPoint)point;

@end
