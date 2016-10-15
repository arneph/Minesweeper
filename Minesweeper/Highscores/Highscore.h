//
//  Highscore.h
//  Minesweeper
//
//  Created by Programmieren on 25.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Highscore : NSObject <NSCoding>

- (id)initWithNickname: (NSString*)nickname
                fields: (NSUInteger)fields
                 mines: (NSUInteger)mines
                  time: (NSUInteger)time
                 turns: (NSUInteger)turns;

- (id)initWithNickname: (NSString*)nickname
                fields: (NSUInteger)fields
                 mines: (NSUInteger)mines
                  time: (NSUInteger)time
                 turns: (NSUInteger)turns
                  date: (NSDate*)date;

@property (readonly) NSString *nickname;
@property (readonly) NSUInteger fields;
@property (readonly) NSUInteger mines;
@property (readonly) NSUInteger time;
@property (readonly) NSUInteger turns;
@property (readonly) NSDate *date;

@end
