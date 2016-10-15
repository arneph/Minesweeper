//
//  GameSolver.m
//  Minesweeper
//
//  Created by Programmieren on 20.12.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import "StandardSolver.h"

@implementation StandardSolver

- (void)performNextMove{
    for (NSUInteger x = 0; x < self.map.size.width; x++) {
        for (NSUInteger y = 0; y < self.map.size.height; y++) {
            BOOL result = [self processPoint:NSMakePoint(x, y)];
            if (result == YES) {
                return;
            }
        }
    }
    
    NSUInteger x, y;
    x = arc4random() % (NSUInteger)self.map.size.width;
    y = arc4random() % (NSUInteger)self.map.size.height;
    
    while ([self.map isPointVisible:NSMakePoint(x, y)]||[self.map isPointFlagged:NSMakePoint(x, y)] ||
           [self.map mineAtPoint:NSMakePoint(x, y)]) {
        x = arc4random() % (NSUInteger)self.map.size.width;
        y = arc4random() % (NSUInteger)self.map.size.height;
    }
    
    [self clickPoint: NSMakePoint(x, y)];
}

- (BOOL)processPoint: (NSPoint)point{
    if (![self.map isPointVisible:point]) {
        return NO;
    }else if ([self.map minesAroundPoint:point] == 0) {
        return NO;
    }
    
    //NSUInteger visiblePoints = [self.map visiblePointsArroundPoint:point];
    NSUInteger invisiblePoints = [self.map invisiblePointsArroundPoint:point];
    NSUInteger flaggedPoints = [self.map flaggedPointsArroundPoint:point];
    //NSUInteger unflaggedPoints = [self.map unflaggedPointsArroundPoint:point];
    NSUInteger mines = [self.map minesAroundPoint:point];
    
    if (flaggedPoints == mines) {
        if (invisiblePoints > flaggedPoints) {
            BOOL hasLeft = (point.x > 0);
            BOOL hasTop = (point.y < self.map.size.height - 1);
            BOOL hasRight = (point.x < self.map.size.width - 1);
            BOOL hasBottom = (point.y > 0);
            
            if (hasLeft) {
                NSPoint leftPoint = NSMakePoint(point.x - 1, point.y);
                if (![self.map isPointVisible: leftPoint]&&![self.map isPointFlagged: leftPoint]) {
                    [self clickPoint:leftPoint];
                    return YES;
                }
            }
            
            if (hasLeft&&hasTop) {
                NSPoint topLeftPoint = NSMakePoint(point.x - 1, point.y + 1);
                if (![self.map isPointVisible: topLeftPoint]&&![self.map isPointFlagged: topLeftPoint]) {
                    [self clickPoint:topLeftPoint];
                    return YES;
                }
            }
            
            if (hasTop) {
                NSPoint topPoint = NSMakePoint(point.x, point.y + 1);
                if (![self.map isPointVisible: topPoint]&&![self.map isPointFlagged: topPoint]) {
                    [self clickPoint:topPoint];
                    return YES;
                }
            }
            
            if (hasTop&&hasRight) {
                NSPoint topRightPoint = NSMakePoint(point.x + 1, point.y + 1);
                if (![self.map isPointVisible: topRightPoint]&&![self.map isPointFlagged: topRightPoint]) {
                    [self clickPoint:topRightPoint];
                    return YES;
                }
            }
            
            if (hasRight) {
                NSPoint rightPoint = NSMakePoint(point.x + 1, point.y);
                if (![self.map isPointVisible: rightPoint]&&![self.map isPointFlagged: rightPoint]) {
                    [self clickPoint:rightPoint];
                    return YES;
                }
            }
            
            if (hasRight&&hasBottom) {
                NSPoint bottomRightPoint = NSMakePoint(point.x + 1, point.y - 1);
                if (![self.map isPointVisible: bottomRightPoint]&&![self.map isPointFlagged: bottomRightPoint]) {
                    [self clickPoint:bottomRightPoint];
                    return YES;
                }
            }
            
            if (hasBottom) {
                NSPoint bottomPoint = NSMakePoint(point.x, point.y - 1);
                if (![self.map isPointVisible: bottomPoint]&&![self.map isPointFlagged: bottomPoint]) {
                    [self clickPoint:bottomPoint];
                    return YES;
                }
            }
            
            if (hasBottom&&hasLeft) {
                NSPoint bottomLeftPoint = NSMakePoint(point.x - 1, point.y - 1);
                if (![self.map isPointVisible: bottomLeftPoint]&&![self.map isPointFlagged: bottomLeftPoint]) {
                    [self clickPoint:bottomLeftPoint];
                    return YES;
                }
            }
            
            return NO;
        }else{
            return NO;
        }
        
    }else{
        if (invisiblePoints == mines) {
            if (invisiblePoints > flaggedPoints) {
                BOOL hasLeft = (point.x > 0);
                BOOL hasTop = (point.y < self.map.size.height - 1);
                BOOL hasRight = (point.x < self.map.size.width - 1);
                BOOL hasBottom = (point.y > 0);
                
                if (hasLeft) {
                    NSPoint leftPoint = NSMakePoint(point.x - 1, point.y);
                    if (![self.map isPointVisible: leftPoint]&&![self.map isPointFlagged: leftPoint]) {
                        [self flagPoint:leftPoint];
                        return YES;
                    }
                }
                
                if (hasLeft&&hasTop) {
                    NSPoint topLeftPoint = NSMakePoint(point.x - 1, point.y + 1);
                    if (![self.map isPointVisible: topLeftPoint]&&![self.map isPointFlagged: topLeftPoint]) {
                        [self flagPoint:topLeftPoint];
                        return YES;
                    }
                }
                
                if (hasTop) {
                    NSPoint topPoint = NSMakePoint(point.x, point.y + 1);
                    if (![self.map isPointVisible: topPoint]&&![self.map isPointFlagged: topPoint]) {
                        [self flagPoint:topPoint];
                        return YES;
                    }
                }
                
                if (hasTop&&hasRight) {
                    NSPoint topRightPoint = NSMakePoint(point.x + 1, point.y + 1);
                    if (![self.map isPointVisible: topRightPoint]&&![self.map isPointFlagged: topRightPoint]) {
                        [self flagPoint:topRightPoint];
                        return YES;
                    }
                }
                
                if (hasRight) {
                    NSPoint rightPoint = NSMakePoint(point.x + 1, point.y);
                    if (![self.map isPointVisible: rightPoint]&&![self.map isPointFlagged: rightPoint]) {
                        [self flagPoint:rightPoint];
                        return YES;
                    }
                }
                
                if (hasRight&&hasBottom) {
                    NSPoint bottomRightPoint = NSMakePoint(point.x + 1, point.y - 1);
                    if (![self.map isPointVisible: bottomRightPoint]&&![self.map isPointFlagged: bottomRightPoint]) {
                        [self flagPoint:bottomRightPoint];
                        return YES;
                    }
                }
                
                if (hasBottom) {
                    NSPoint bottomPoint = NSMakePoint(point.x, point.y - 1);
                    if (![self.map isPointVisible: bottomPoint]&&![self.map isPointFlagged: bottomPoint]) {
                        [self flagPoint:bottomPoint];
                        return YES;
                    }
                }
                
                if (hasBottom&&hasLeft) {
                    NSPoint bottomLeftPoint = NSMakePoint(point.x - 1, point.y - 1);
                    if (![self.map isPointVisible: bottomLeftPoint]&&![self.map isPointFlagged: bottomLeftPoint]) {
                        [self flagPoint:bottomLeftPoint];
                        return YES;
                    }
                }
                return NO;
            }else{
                return NO;
            }
            
        }else{
            return NO;
        }
    }
}

@end
