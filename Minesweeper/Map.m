//
//  Map.m
//  Minesweeper
//
//  Created by Programmieren on 21.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import "Map.h"

@interface Field : NSObject

@property BOOL isMine;
@property BOOL isVisible;
@property BOOL isFlagged;

@end

@implementation Field

- (id)init{
    self = [super init];
    if (self) {
        _isMine = NO;
        _isVisible = NO;
        _isFlagged = NO;
    }
    return self;
}

@end

@implementation Map{
    NSSize size;
    NSMutableArray *fields;
}

#pragma mark Init Methods

+ (Map*)beginnerMap{
    return [Map mapWithSize:MapSizeBeginner andMines:10];
}

+ (Map*)advancedMap{
    return [Map mapWithSize:MapSizeAdvanced andMines:40];
}

+ (Map*)professionalMap{
    return [Map mapWithSize:MapSizeProfessional andMines:99];
}

+ (Map *)mapWithSize:(NSSize)s{
    if (s.width < 8||s.height < 8) {
        @throw NSInvalidArgumentException;
        return nil;
    }
    return [[Map alloc] initWithSize:s];
}

+ (Map *)mapWithSize:(NSSize)s andMines:(NSUInteger)nMines{
    if (s.width < 8||s.height < 8||s.width * s.height < nMines * .93) {
        @throw NSInvalidArgumentException;
        return nil;
    }
    return [[Map alloc] initWithSize:s andMines:nMines];
}

- (id)init{
    self = [super init];
    if (self) {
        [self initializeFieldsWithSize:NSMakeSize(8, 8)];
    }
    return self;
}

- (id)initWithSize:(NSSize)s{
    if (s.width < 8||s.height < 8) {
        @throw NSInvalidArgumentException;
        return nil;
    }
    self = [super init];
    if (self) {
        [self initializeFieldsWithSize:s];
    }
    return self;
}

- (id)initWithSize:(NSSize)s andMines:(NSUInteger)nMines{
    if (s.width < 8||s.height < 8||s.width * s.height < nMines * .93) {
        @throw NSInvalidArgumentException;
        return nil;
    }
    self = [super init];
    if (self) {
        [self initializeFieldsWithSize:s];
        for (NSUInteger i = 0; i < nMines; i++) {
            NSUInteger x = arc4random() % (NSUInteger)size.width;
            NSUInteger y = arc4random() % (NSUInteger)size.height;
            while ([self mineAtPoint:NSMakePoint(x, y)]) {
                x = arc4random() % (NSUInteger)size.width;
                y = arc4random() % (NSUInteger)size.height;
            }
            Field *field = [self fieldAtPoint:NSMakePoint(x, y)];
            field.isMine = YES;
        }
    }
    return self;
}

#pragma mark Internal Methods

- (void)initializeFieldsWithSize: (NSSize)s{
    if (s.width < 8||s.height < 8) {
        @throw NSInvalidArgumentException;
        return;
    }
    size = s;
    fields = [[NSMutableArray alloc] initWithCapacity:size.width * size.height];
    for (NSUInteger i = 0; i < size.width * size.height; i++) {
        [fields addObject:[[Field alloc] init]];
    }
}

- (Field*)fieldAtPoint: (NSPoint)point{
    if (point.x < 0||point.x >= size.width||point.y < 0||point.y >= size.height) {
        @throw NSInvalidArgumentException;
        return nil;
    }
    NSUInteger index;
    index = point.y * size.width;
    index += point.x;
    return fields[index];
}

#pragma mark Public Methods

- (NSSize)size{
    return size;
}

- (NSUInteger)numberOfMines{
    NSUInteger n = 0;
    for (NSUInteger i = 0; i < fields.count; i++) {
        Field *field = fields[i];
        if (field.isMine) {
            n++;
        }
    }
    return n;
}

- (NSUInteger)minesAroundPoint: (NSPoint)point{
    if (point.x < 0||point.x >= size.width||point.y < 0||point.y >= size.height) {
        @throw NSInvalidArgumentException;
        return 0;
    }
    BOOL hasLeft = (point.x > 0);
    BOOL hasTop = (point.y < size.height - 1);
    BOOL hasRight = (point.x < size.width - 1);
    BOOL hasBottom = (point.y > 0);
    NSUInteger mines = 0;
    if (hasLeft) {
        mines += ([self mineAtPoint:NSMakePoint(point.x - 1, point.y)]);
    }
    if (hasLeft&&hasTop) {
        mines += ([self mineAtPoint:NSMakePoint(point.x - 1, point.y + 1)]);
    }
    if (hasTop) {
        mines += ([self mineAtPoint:NSMakePoint(point.x, point.y + 1)]);
    }
    if (hasTop&&hasRight) {
        mines += ([self mineAtPoint:NSMakePoint(point.x + 1, point.y + 1)]);
    }
    if (hasRight) {
        mines += ([self mineAtPoint:NSMakePoint(point.x + 1, point.y)]);
    }
    if (hasRight&&hasBottom) {
        mines += ([self mineAtPoint:NSMakePoint(point.x + 1, point.y - 1)]);
    }
    if (hasBottom) {
        mines += ([self mineAtPoint:NSMakePoint(point.x, point.y - 1)]);
    }
    if (hasBottom&&hasLeft) {
        mines += ([self mineAtPoint:NSMakePoint(point.x - 1, point.y - 1)]);
    }
    return mines;
}

- (BOOL)mineAtPoint:(NSPoint)point{
    return [self fieldAtPoint:point].isMine;
}

- (void)setMine:(BOOL)isMine atPoint:(NSPoint)point{
    [self fieldAtPoint:point].isMine = isMine;
}

- (BOOL)isPointVisible:(NSPoint)point{
    return [self fieldAtPoint:point].isVisible;
}

- (NSUInteger)visiblePointsArroundPoint:(NSPoint)point{
    if (point.x < 0||point.x >= size.width||point.y < 0||point.y >= size.height) {
        @throw NSInvalidArgumentException;
        return 0;
    }
    BOOL hasLeft = (point.x > 0);
    BOOL hasTop = (point.y < size.height - 1);
    BOOL hasRight = (point.x < size.width - 1);
    BOOL hasBottom = (point.y > 0);
    NSUInteger visiblePoints = 0;
    if (hasLeft) {
        visiblePoints += ([self isPointVisible:NSMakePoint(point.x - 1, point.y)]);
    }
    if (hasLeft&&hasTop) {
        visiblePoints += ([self isPointVisible:NSMakePoint(point.x - 1, point.y + 1)]);
    }
    if (hasTop) {
        visiblePoints += ([self isPointVisible:NSMakePoint(point.x, point.y + 1)]);
    }
    if (hasTop&&hasRight) {
        visiblePoints += ([self isPointVisible:NSMakePoint(point.x + 1, point.y + 1)]);
    }
    if (hasRight) {
        visiblePoints += ([self isPointVisible:NSMakePoint(point.x + 1, point.y)]);
    }
    if (hasRight&&hasBottom) {
        visiblePoints += ([self isPointVisible:NSMakePoint(point.x + 1, point.y - 1)]);
    }
    if (hasBottom) {
        visiblePoints += ([self isPointVisible:NSMakePoint(point.x, point.y - 1)]);
    }
    if (hasBottom&&hasLeft) {
        visiblePoints += ([self isPointVisible:NSMakePoint(point.x - 1, point.y - 1)]);
    }
    return visiblePoints;
}

- (NSUInteger)invisiblePointsArroundPoint:(NSPoint)point{
    if (point.x < 0||point.x >= size.width||point.y < 0||point.y >= size.height) {
        @throw NSInvalidArgumentException;
        return 0;
    }
    BOOL hasLeft = (point.x > 0);
    BOOL hasTop = (point.y < size.height - 1);
    BOOL hasRight = (point.x < size.width - 1);
    BOOL hasBottom = (point.y > 0);
    NSUInteger invisiblePoints = 0;
    if (hasLeft) {
        invisiblePoints += (![self isPointVisible:NSMakePoint(point.x - 1, point.y)]);
    }
    if (hasLeft&&hasTop) {
        invisiblePoints += (![self isPointVisible:NSMakePoint(point.x - 1, point.y + 1)]);
    }
    if (hasTop) {
        invisiblePoints += (![self isPointVisible:NSMakePoint(point.x, point.y + 1)]);
    }
    if (hasTop&&hasRight) {
        invisiblePoints += (![self isPointVisible:NSMakePoint(point.x + 1, point.y + 1)]);
    }
    if (hasRight) {
        invisiblePoints += (![self isPointVisible:NSMakePoint(point.x + 1, point.y)]);
    }
    if (hasRight&&hasBottom) {
        invisiblePoints += (![self isPointVisible:NSMakePoint(point.x + 1, point.y - 1)]);
    }
    if (hasBottom) {
        invisiblePoints += (![self isPointVisible:NSMakePoint(point.x, point.y - 1)]);
    }
    if (hasBottom&&hasLeft) {
        invisiblePoints += (![self isPointVisible:NSMakePoint(point.x - 1, point.y - 1)]);
    }
    return invisiblePoints;
}

- (void)setVisible:(BOOL)isVisible atPoint:(NSPoint)point{
    [self fieldAtPoint:point].isVisible = isVisible;
    
    if ([self minesAroundPoint:point] < 1) {
        BOOL hasLeft = (point.x > 0);
        BOOL hasTop = (point.y < size.height - 1);
        BOOL hasRight = (point.x < size.width - 1);
        BOOL hasBottom = (point.y > 0);
        if (hasLeft) {
            NSPoint leftPoint = NSMakePoint(point.x - 1, point.y);
            if (![self isPointVisible:leftPoint]) {
                [self setVisible:YES atPoint:leftPoint];
            }
        }
        if (hasLeft&&hasTop) {
            NSPoint topLeftPoint = NSMakePoint(point.x - 1, point.y + 1);
            if (![self isPointVisible:topLeftPoint]) {
                [self setVisible:YES atPoint:topLeftPoint];
            }
        }
        if (hasTop) {
            NSPoint topPoint = NSMakePoint(point.x, point.y + 1);
            if (![self isPointVisible:topPoint]) {
                [self setVisible:YES atPoint:topPoint];
            }
        }
        if (hasTop&&hasRight) {
            NSPoint topRightPoint = NSMakePoint(point.x + 1, point.y + 1);
            if (![self isPointVisible:topRightPoint]) {
                [self setVisible:YES atPoint:topRightPoint];
            }
        }
        if (hasRight) {
            NSPoint rightPoint = NSMakePoint(point.x + 1, point.y);
            if (![self isPointVisible:rightPoint]) {
                [self setVisible:YES atPoint:rightPoint];
            }
        }
        if (hasRight&&hasBottom) {
            NSPoint bottomRightPoint = NSMakePoint(point.x + 1, point.y - 1);
            if (![self isPointVisible:bottomRightPoint]) {
                [self setVisible:YES atPoint:bottomRightPoint];
            }
        }
        if (hasBottom) {
            NSPoint bottomPoint = NSMakePoint(point.x, point.y - 1);
            if (![self isPointVisible:bottomPoint]) {
                [self setVisible:YES atPoint:bottomPoint];
            }
        }
        if (hasBottom&&hasLeft) {
            NSPoint bottomLeftPoint = NSMakePoint(point.x - 1, point.y - 1);
            if (![self isPointVisible:bottomLeftPoint]) {
                [self setVisible:YES atPoint:bottomLeftPoint];
            }
        }
    }
}

- (BOOL)noPointVisible{
    __block BOOL noneVisible = YES;
    [fields enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop){
         Field *field = obj;
         if (field.isVisible) {
             noneVisible = NO;
             BOOL stp = YES;
             stop = &stp;
         }
     }];
    return noneVisible;
}

- (BOOL)allPointsVisible{
    __block BOOL allVisible = YES;
    [fields enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop){
         Field *field = obj;
         if (!field.isVisible) {
             allVisible = NO;
             BOOL stp = YES;
             stop = &stp;
         }
     }];
    return allVisible;
}

- (NSUInteger)numberOfVisiblePoints{
    NSUInteger c = 0;
    
    for (int i = 0; i < fields.count; i++) {
        if ([((Field *) fields[i]) isVisible]) {
            c++;
        }
    }
    
    return c;
}

- (void)makeAllPointsVisible{
    [fields enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop){
         Field *field = obj;
         field.isVisible = YES;
    }];
}

- (BOOL)isPointFlagged:(NSPoint)point{
    return [self fieldAtPoint:point].isFlagged;
}

- (NSUInteger)flaggedPointsArroundPoint: (NSPoint)point{
    if (point.x < 0||point.x >= size.width||point.y < 0||point.y >= size.height) {
        @throw NSInvalidArgumentException;
        return 0;
    }
    BOOL hasLeft = (point.x > 0);
    BOOL hasTop = (point.y < size.height - 1);
    BOOL hasRight = (point.x < size.width - 1);
    BOOL hasBottom = (point.y > 0);
    NSUInteger flaggedPoints = 0;
    if (hasLeft) {
        flaggedPoints += ([self isPointFlagged:NSMakePoint(point.x - 1, point.y)]);
    }
    if (hasLeft&&hasTop) {
        flaggedPoints += ([self isPointFlagged:NSMakePoint(point.x - 1, point.y + 1)]);
    }
    if (hasTop) {
        flaggedPoints += ([self isPointFlagged:NSMakePoint(point.x, point.y + 1)]);
    }
    if (hasTop&&hasRight) {
        flaggedPoints += ([self isPointFlagged:NSMakePoint(point.x + 1, point.y + 1)]);
    }
    if (hasRight) {
        flaggedPoints += ([self isPointFlagged:NSMakePoint(point.x + 1, point.y)]);
    }
    if (hasRight&&hasBottom) {
        flaggedPoints += ([self isPointFlagged:NSMakePoint(point.x + 1, point.y - 1)]);
    }
    if (hasBottom) {
        flaggedPoints += ([self isPointFlagged:NSMakePoint(point.x, point.y - 1)]);
    }
    if (hasBottom&&hasLeft) {
        flaggedPoints += ([self isPointFlagged:NSMakePoint(point.x - 1, point.y - 1)]);
    }
    return flaggedPoints;
}

- (NSUInteger)unflaggedPointsArroundPoint: (NSPoint)point{
    if (point.x < 0||point.x >= size.width||point.y < 0||point.y >= size.height) {
        @throw NSInvalidArgumentException;
        return 0;
    }
    BOOL hasLeft = (point.x > 0);
    BOOL hasTop = (point.y < size.height - 1);
    BOOL hasRight = (point.x < size.width - 1);
    BOOL hasBottom = (point.y > 0);
    NSUInteger unflaggedPoints = 0;
    if (hasLeft) {
        unflaggedPoints += (![self isPointFlagged:NSMakePoint(point.x - 1, point.y)]);
    }
    if (hasLeft&&hasTop) {
        unflaggedPoints += (![self isPointFlagged:NSMakePoint(point.x - 1, point.y + 1)]);
    }
    if (hasTop) {
        unflaggedPoints += (![self isPointFlagged:NSMakePoint(point.x, point.y + 1)]);
    }
    if (hasTop&&hasRight) {
        unflaggedPoints += (![self isPointFlagged:NSMakePoint(point.x + 1, point.y + 1)]);
    }
    if (hasRight) {
        unflaggedPoints += (![self isPointFlagged:NSMakePoint(point.x + 1, point.y)]);
    }
    if (hasRight&&hasBottom) {
        unflaggedPoints += (![self isPointFlagged:NSMakePoint(point.x + 1, point.y - 1)]);
    }
    if (hasBottom) {
        unflaggedPoints += (![self isPointFlagged:NSMakePoint(point.x, point.y - 1)]);
    }
    if (hasBottom&&hasLeft) {
        unflaggedPoints += (![self isPointFlagged:NSMakePoint(point.x - 1, point.y - 1)]);
    }
    return unflaggedPoints;
}

- (void)setFlagged:(BOOL)isFlagged atPoint:(NSPoint)point{
    [self fieldAtPoint:point].isFlagged = isFlagged;
}

@end
