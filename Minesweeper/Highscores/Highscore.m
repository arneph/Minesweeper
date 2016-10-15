//
//  Highscore.m
//  Minesweeper
//
//  Created by Programmieren on 25.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import "Highscore.h"

@implementation Highscore

- (id)init{
    self = [super init];
    if (self) {
        _nickname = @"";
        _fields = 0;
        _mines = 0;
        _time = 0;
        _turns = 0;
        _date = [NSDate date];
    }
    return self;
}

- (id)initWithNickname:(NSString *)n
                fields:(NSUInteger)f
                 mines:(NSUInteger)m
                  time:(NSUInteger)t
                 turns:(NSUInteger)tn{
    self = [super init];
    if (self) {
        _nickname = n;
        _fields = f;
        _mines = m;
        _time = t;
        _turns = tn;
        _date = [NSDate date];
    }
    return self;
}

- (id)initWithNickname:(NSString *)n
                fields:(NSUInteger)f
                 mines:(NSUInteger)m
                  time:(NSUInteger)t
                 turns:(NSUInteger)tn
                  date:(NSDate *)d{
    self = [super init];
    if (self) {
        _nickname = n;
        _fields = f;
        _mines = m;
        _time = t;
        _turns = tn;
        _date = d;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _nickname = [aDecoder decodeObjectForKey:@"nickname"];
        _fields = [aDecoder decodeIntegerForKey:@"fields"];
        _mines = [aDecoder decodeIntegerForKey:@"mines"];
        _time = [aDecoder decodeIntegerForKey:@"time"];
        _turns = [aDecoder decodeIntegerForKey:@"turns"];
        _date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeInteger:_fields forKey:@"fields"];
    [aCoder encodeInteger:_mines forKey:@"mines"];
    [aCoder encodeInteger:_time forKey:@"time"];
    [aCoder encodeInteger:_turns forKey:@"turns"];
    [aCoder encodeObject:_date forKey:@"date"];
}

@end
