//
//  GameSolver.h
//  Minesweeper
//
//  Created by A Philipeit on 13/09/2016.
//  Copyright © 2016 Arne Philipeit Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "MapView.h"

@interface GameSolver : NSObject

@property (readonly) Map *map;
@property (readonly) MapView *mapView;

@property (readonly) BOOL finished;

+ (instancetype)gameSolverForMap: (Map*)map andWithMapView: (MapView*)mapView;
- (instancetype)initForMap: (Map*)map andWithMapView: (MapView*)mapView;

- (void)startSolving;

- (void)performNextMove;

- (void)clickPoint: (NSPoint)point;
- (void)flagPoint: (NSPoint)point;

@end
