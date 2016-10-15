//
//  GameSolver.m
//  Minesweeper
//
//  Created by A Philipeit on 13/09/2016.
//  Copyright © 2016 Arne Philipeit Software. All rights reserved.
//

#import "GameSolver.h"

@implementation GameSolver{
    NSPoint mouseLocation;
    BOOL flagPoint;
}

+ (instancetype)gameSolverForMap: (Map*)map andWithMapView: (MapView*)mapView{
    if (!map||!mapView) {
        @throw NSInvalidArgumentException;
        return nil;
    }
    
    return [[[self class] alloc] initForMap:map andWithMapView:mapView];
}

- (instancetype)initForMap: (Map*)map andWithMapView: (MapView*)mapView{
    if (!map||!mapView) {
        @throw NSInvalidArgumentException;
        return nil;
    }
    self = [super init];
    if (self) {
        _map = map;
        _mapView = mapView;
        _finished = _map.allPointsVisible;
    }
    return self;
}

- (void)startSolving{
    if (_map.allPointsVisible) {
        _finished = YES;
        return;
    }
    flagPoint = NO;
    mouseLocation = NSMakePoint(-1, -1);
    
    _mapView.blockUserEvents = YES;
    _mapView.targetForMouseMoveFinished = self;
    _mapView.selectorForMouseMoveFinished = @selector(mouseMoveFinished);
    
    if (_map.noPointVisible) {
        NSUInteger x = arc4random() % (NSUInteger)_map.size.width;
        NSUInteger y = arc4random() % (NSUInteger)_map.size.height;
        [self clickPoint:NSMakePoint(x, y)];
        
    }else{
        
        [self performNextMove];
    }
}

- (void)performNextMove{}

- (void)clickPoint: (NSPoint)point {
    mouseLocation = point;
    flagPoint = NO;
    [_mapView moveMouseToPoint:mouseLocation animated:YES];
}

- (void)flagPoint: (NSPoint)point {
    mouseLocation = point;
    flagPoint = YES;
    [_mapView moveMouseToPoint:mouseLocation animated:YES];
}

- (void)mouseMoveFinished{
    if (mouseLocation.x != -1 || mouseLocation.y != -1) {
        if (!flagPoint) {
            [_mapView clickPoint:mouseLocation];
        }else{
            [_mapView markPoint:mouseLocation];
        }
    }
    
    if (_map.allPointsVisible) {
        _finished = YES;
        return;
    }
    
    [self performNextMove];
}

@end
