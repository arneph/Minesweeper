//
//  MapView.m
//  Minesweeper
//
//  Created by Programmieren on 21.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import "MapView.h"

#define SquareWidth _squareWidth

@implementation MapView{
    NSPoint lastCursorNavigationPoint;
    
    BOOL shiftPressed;
    BOOL alternatePressed;
}

@synthesize squareWidth = _squareWidth;

- (id)init{
    self = [super init];
    if (self) {
        lastCursorNavigationPoint = NSMakePoint(-1, -1);
        _blockUserEvents = NO;
    }
    return self;
}

-(id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self) {
        lastCursorNavigationPoint = NSMakePoint(-1, -1);
        _blockUserEvents = NO;
    }
    return self;
}

- (void)awakeFromNib{
    [self updateTrackingAreas];
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    [self.trackingAreas.copy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [self removeTrackingArea:obj];
    }];
    [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.bounds
                                                       options:NSTrackingActiveAlways|NSTrackingMouseMoved
                                                         owner:self
                                                      userInfo:nil]];
    [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.bounds
                                                       options:NSTrackingActiveAlways|NSTrackingMouseEnteredAndExited
                                                         owner:self
                                                      userInfo:nil]];
}

#pragma mark Public Methods

- (CGFloat)squareWidth{
    return _squareWidth;
}

- (void)setSquareWidth:(CGFloat)squareWidth{
    _squareWidth = squareWidth;
    [self setNeedsDisplay:YES];
    [self updateTrackingAreas];
}

- (void)refresh{
    [self setNeedsDisplay:YES];
}

- (void)refreshPoint:(NSPoint)point{
    NSRect screenRect = NSMakeRect(point.x * SquareWidth - 3,
                             point.y * SquareWidth - 3,
                             SquareWidth + 6,
                             SquareWidth + 6);
    [self setNeedsDisplayInRect:screenRect];
}

- (void)refreshPointsInRect:(NSRect)rect{
    NSRect screenRect = NSMakeRect(rect.origin.x * SquareWidth - 3,
                                   rect.origin.y * SquareWidth - 3,
                                   rect.size.width * SquareWidth + 6,
                                   rect.size.height * SquareWidth + 6);
    [self setNeedsDisplayInRect:screenRect];
}

- (void)clickPoint: (NSPoint)point{
    if (point.x < 0||point.y < 0||
        point.x >= _delegate.map.size.width||point.y >= _delegate.map.size.height) {
        return;
    }
    [_delegate clickedPoint:point];
}

- (void)markPoint: (NSPoint)point{
    if (point.x < 0||point.y < 0||
        point.x >= _delegate.map.size.width||point.y >= _delegate.map.size.height) {
        return;
    }
    [_delegate markedPoint:point];
}

#pragma mark Responding

- (BOOL)acceptsFirstResponder{
    return !_blockUserEvents;
}

- (void)mouseDown:(NSEvent *)theEvent{
    if (_blockUserEvents) return;
    if (!_delegate.map||_delegate.pausedGame) {
        return;
    }
    if (theEvent.modifierFlags&NSControlKeyMask) {
        [self rightMouseDown:theEvent];
        return;
    }
    NSPoint coordinate = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSUInteger x = (NSUInteger)coordinate.x / SquareWidth;
    NSUInteger y = (NSUInteger)coordinate.y / SquareWidth;
    NSPoint mapPoint = NSMakePoint(x, y);
    [self clickPoint:mapPoint];
}

- (void)rightMouseDown:(NSEvent *)theEvent{
    if (_blockUserEvents) return;
    if (!_delegate.map||_delegate.pausedGame) {
        return;
    }
    NSPoint coordinate = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSUInteger x = (NSUInteger)coordinate.x / SquareWidth;
    NSUInteger y = (NSUInteger)coordinate.y / SquareWidth;
    NSPoint mapPoint = NSMakePoint(x, y);
    [self markPoint:mapPoint];
}

- (void)mouseEntered:(NSEvent *)theEvent{
    NSPoint cursorPositionInView = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSPoint mapPoint = cursorPositionInView;
    mapPoint.x = (int)(mapPoint.x / SquareWidth);
    mapPoint.y = (int)(mapPoint.y / SquareWidth);
    lastCursorNavigationPoint = mapPoint;
}

- (void)mouseMoved:(NSEvent *)theEvent{
    NSPoint cursorPositionInView = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSPoint mapPoint = cursorPositionInView;
    mapPoint.x = (int)(mapPoint.x / SquareWidth);
    mapPoint.y = (int)(mapPoint.y / SquareWidth);
    lastCursorNavigationPoint = mapPoint;
}

- (void)mouseExited:(NSEvent *)theEvent{
    lastCursorNavigationPoint = NSMakePoint(-1, -1);
}

- (void)moveLeft:(id)sender{
    if (_blockUserEvents) return;
    if (lastCursorNavigationPoint.x < 0||
        lastCursorNavigationPoint.y < 0||
        lastCursorNavigationPoint.x >= _delegate.map.size.width||
        lastCursorNavigationPoint.y >= _delegate.map.size.height) {
        
        lastCursorNavigationPoint = NSMakePoint(0, _delegate.map.size.height - 1);
        [self moveMouseToPoint:lastCursorNavigationPoint];
        
    }else{
        if (lastCursorNavigationPoint.x == 0) {
            NSBeep();
        }else{
            lastCursorNavigationPoint.x = lastCursorNavigationPoint.x - 1;
            [self moveMouseToPoint:lastCursorNavigationPoint];
        }
    }
}

- (void)moveRight:(id)sender{
    if (_blockUserEvents) return;
    if (lastCursorNavigationPoint.x < 0||
        lastCursorNavigationPoint.y < 0||
        lastCursorNavigationPoint.x >= _delegate.map.size.width||
        lastCursorNavigationPoint.y >= _delegate.map.size.height) {
        
        lastCursorNavigationPoint = NSMakePoint(0, _delegate.map.size.height - 1);
        [self moveMouseToPoint:lastCursorNavigationPoint];
        
    }else{
        if (lastCursorNavigationPoint.x == _delegate.map.size.width - 1) {
            NSBeep();
        }else{
            lastCursorNavigationPoint.x = lastCursorNavigationPoint.x + 1;
            [self moveMouseToPoint:lastCursorNavigationPoint];
        }
    }
}

- (void)moveDown:(id)sender{
    if (_blockUserEvents) return;
    if (lastCursorNavigationPoint.x < 0||
        lastCursorNavigationPoint.y < 0||
        lastCursorNavigationPoint.x >= _delegate.map.size.width||
        lastCursorNavigationPoint.y >= _delegate.map.size.height) {
        
        lastCursorNavigationPoint = NSMakePoint(0, _delegate.map.size.height - 1);
        [self moveMouseToPoint:lastCursorNavigationPoint];
        
    }else{
        if (lastCursorNavigationPoint.y == 0) {
            NSBeep();
        }else{
            lastCursorNavigationPoint.y = lastCursorNavigationPoint.y - 1;
            [self moveMouseToPoint:lastCursorNavigationPoint animated:YES];
        }
    }
}

- (void)moveUp:(id)sender{
    if (_blockUserEvents) return;
    if (lastCursorNavigationPoint.x < 0||
        lastCursorNavigationPoint.y < 0||
        lastCursorNavigationPoint.x >= _delegate.map.size.width||
        lastCursorNavigationPoint.y >= _delegate.map.size.height) {
        
        lastCursorNavigationPoint = NSMakePoint(0, _delegate.map.size.height - 1);
        [self moveMouseToPoint:lastCursorNavigationPoint];
        
    }else{
        if (lastCursorNavigationPoint.y == _delegate.map.size.height - 1) {
            NSBeep();
        }else{
            lastCursorNavigationPoint.y = lastCursorNavigationPoint.y + 1;
            [self moveMouseToPoint:lastCursorNavigationPoint];
        }
    }
}

- (void)flagsChanged:(NSEvent *)theEvent{
    shiftPressed = theEvent.modifierFlags&NSShiftKeyMask;
    alternatePressed = theEvent.modifierFlags&NSAlternateKeyMask;
}

- (void)keyDown:(NSEvent *)theEvent{
    if (_blockUserEvents) {
        [super keyDown:theEvent];
        return;
    }
    if ([theEvent.charactersIgnoringModifiers.lowercaseString isEqualToString:@"o"]) {
        [_delegate clickedPoint:lastCursorNavigationPoint];
    }else if ([theEvent.charactersIgnoringModifiers.lowercaseString isEqualToString:@"f"]) {
        [_delegate markedPoint:lastCursorNavigationPoint];
    }else if ([theEvent.charactersIgnoringModifiers.lowercaseString isEqualToString:@"s"]&&
              theEvent.modifierFlags&NSControlKeyMask) {
        [_delegate startSolver];
    }else{
        [super keyDown:theEvent];
    }
}

#pragma mark Moving the Mouse

- (void)moveMouseToPoint: (NSPoint)point{
    CGPoint pointInView = CGPointMake((point.x * SquareWidth) + (0.5 * SquareWidth),
                                      (point.y * SquareWidth) + (0.5 * SquareWidth));
    CGPoint pointInWindow = [self convertPointToBacking:pointInView];
    CGPoint pointOnScreen = [self.window convertBaseToScreen: pointInWindow];
    pointOnScreen.y = self.window.screen.frame.size.height - pointOnScreen.y;
    CGDirectDisplayID displayID = (CGDirectDisplayID)[[self.window.screen deviceDescription][@"NSScreenNumber"] intValue];
    CGDisplayMoveCursorToPoint(displayID, pointOnScreen);
}

- (void)moveMouseToPoint: (NSPoint)point animated: (BOOL)animate{
    if (!animate) [self moveMouseToPoint:point];
    CGPoint oldPointOnScreen = [self.window convertBaseToScreen: [self.window mouseLocationOutsideOfEventStream]];
    oldPointOnScreen.y = self.window.screen.frame.size.height - oldPointOnScreen.y;
    CGPoint pointInView = CGPointMake((point.x * SquareWidth) + (0.5 * SquareWidth),
                                      (point.y * SquareWidth) + (0.5 * SquareWidth));
    CGPoint pointInWindow = [self convertPointToBacking:pointInView];
    CGPoint pointOnScreen = [self.window convertBaseToScreen:pointInWindow];
    pointOnScreen.y = self.window.screen.frame.size.height - pointOnScreen.y;
    __block CGDirectDisplayID displayID = (CGDirectDisplayID)[[self.window.screen deviceDescription][@"NSScreenNumber"] intValue];
    
    for (NSUInteger i = 0; i < 25; i++) {
        CGFloat deltaX = (pointOnScreen.x - oldPointOnScreen.x) / 25 * (i + 1);
        CGFloat deltaY = (pointOnScreen.y - oldPointOnScreen.y) / 25 * (i + 1);
        __block CGPoint stepPoint = CGPointMake(oldPointOnScreen.x + deltaX, oldPointOnScreen.y + deltaY);
        __block BOOL lastMove = (i == 25 - 1);
        __block id target = _targetForMouseMoveFinished;
        __block SEL selector = _selectorForMouseMoveFinished;
        
        double delayInSeconds = 0.25 / 25 * i;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            CGDisplayMoveCursorToPoint(displayID, stepPoint);
            if (lastMove) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [target performSelector:selector];
#pragma clang diagnostic pop
            }
        });
    }
}

#pragma mark Drawing

- (BOOL)isOpaque{
    return (_delegate.map&&!_delegate.pausedGame);
}

- (void)drawRect:(NSRect)dirtyRect{
    if (!_delegate.map||_delegate.pausedGame) {
        [[NSColor colorWithSRGBRed:.8 green:.8 blue:.8 alpha:1] set];
        [NSBezierPath fillRect:dirtyRect];
        //Draw Grid
        [[NSColor darkGrayColor] set];
        for (NSUInteger x = 0; x <= _delegate.map.size.width; x++) {
            NSBezierPath *gridLine;
            gridLine = [[NSBezierPath alloc] init];
            [gridLine moveToPoint:NSMakePoint(x * SquareWidth, 0)];
            [gridLine lineToPoint:NSMakePoint(x * SquareWidth, _delegate.map.size.height * SquareWidth)];
            [gridLine stroke];
        }
        for (NSUInteger y = 0; y <= _delegate.map.size.height; y++) {
            NSBezierPath *gridLine;
            gridLine = [[NSBezierPath alloc] init];
            [gridLine moveToPoint:NSMakePoint(0, y * SquareWidth)];
            [gridLine lineToPoint:NSMakePoint(_delegate.map.size.width * SquareWidth, y * SquareWidth)];
            [gridLine stroke];
        }
        return;
    }
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:dirtyRect];
    
    NSImage *flagImage = [NSImage imageNamed:@"Flag"];
    NSImage *mineImage = [NSImage imageNamed:@"Mine"];
    for (NSUInteger x = 0; x < _delegate.map.size.width; x++) {
        for (NSUInteger y = 0; y < _delegate.map.size.height; y++) {
            NSPoint point = NSMakePoint(x, y);
            NSRect rect = NSMakeRect(x * SquareWidth,
                                     y * SquareWidth,
                                     SquareWidth,
                                     SquareWidth);
            
            if ([_delegate.map isPointVisible: point]) {
                [[NSColor grayColor] set];
                [NSBezierPath fillRect:rect];
                if ([_delegate.map mineAtPoint: point]) {
                    NSPoint failurePoint = [_delegate failurePoint];
                    if (!_delegate.activeGame&&failurePoint.x == x&&failurePoint.y == y) {
                        [[NSColor redColor] set];
                        [NSBezierPath fillRect:rect];
                        [mineImage drawInRect: rect
                                     fromRect: NSZeroRect
                                    operation: NSCompositeSourceOver
                                     fraction: 1];
                    }else{
                        [mineImage drawInRect:rect
                                 fromRect:NSZeroRect
                                operation:NSCompositeSourceOver
                                 fraction:1];
                    }
                }else if ([_delegate.map minesAroundPoint:point] > 0) {
                    if (!_delegate.activeGame&&[_delegate.map isPointFlagged:point]) {
                        [mineImage drawInRect: rect
                                     fromRect: NSZeroRect
                                    operation: NSCompositeSourceOver
                                     fraction: 1];
                        [[NSColor redColor] set];
                        NSBezierPath *line = [[NSBezierPath alloc] init];
                        [line setLineWidth:2];
                        [line moveToPoint:NSMakePoint(rect.origin.x + 6, rect.origin.y + 3)];
                        [line lineToPoint:NSMakePoint(rect.origin.x + rect.size.width - 6, rect.origin.y + rect.size.height - 3)];
                        [line stroke];
                        line = [[NSBezierPath alloc] init];
                        [line setLineWidth:2];
                        [line moveToPoint:NSMakePoint(rect.origin.x + rect.size.width - 6, rect.origin.y + 3)];
                        [line lineToPoint:NSMakePoint(rect.origin.x + 6, rect.origin.y + rect.size.height - 3)];
                        [line stroke];
                    }else{
                        NSUInteger mines = [_delegate.map minesAroundPoint:point];
                        NSMutableAttributedString *drawingString;
                        drawingString = [[NSMutableAttributedString alloc] initWithString:@(mines).stringValue];
                        [drawingString addAttribute: NSFontAttributeName
                                              value: [NSFont fontWithName:@"Helvetica Bold" size:24]
                                              range: NSMakeRange(0, 1)];
                        [drawingString addAttribute: NSForegroundColorAttributeName
                                              value: [self colorForNumber:mines]
                                              range: NSMakeRange(0, 1)];
                        
                        NSSize size = drawingString.size;
                        NSPoint point = NSMakePoint(rect.origin.x + ((SquareWidth - size.width) / 2),
                                                    rect.origin.y + ((SquareWidth - size.height) / 2));
                        [drawingString drawAtPoint:point];
                    }
                }
            }else{
                [[NSColor colorWithSRGBRed:.8 green:.8 blue:.8 alpha:1] set];
                [NSBezierPath fillRect:rect];
                if ([_delegate.map isPointFlagged: point]) {
                    [flagImage drawInRect: rect
                                 fromRect: NSZeroRect
                                operation: NSCompositeSourceOver
                                 fraction: 1];
                }
            }
        }
    }
    
    //Draw Grid
    [[NSColor darkGrayColor] set];
    for (NSUInteger x = 0; x <= _delegate.map.size.width; x++) {
        NSBezierPath *gridLine;
        gridLine = [[NSBezierPath alloc] init];
        [gridLine moveToPoint:NSMakePoint(x * SquareWidth, 0)];
        [gridLine lineToPoint:NSMakePoint(x * SquareWidth, _delegate.map.size.height * SquareWidth)];
        [gridLine stroke];
    }
    for (NSUInteger y = 0; y <= _delegate.map.size.height; y++) {
        NSBezierPath *gridLine;
        gridLine = [[NSBezierPath alloc] init];
        [gridLine moveToPoint:NSMakePoint(0, y * SquareWidth)];
        [gridLine lineToPoint:NSMakePoint(_delegate.map.size.width * SquareWidth, y * SquareWidth)];
        [gridLine stroke];
    }
}

- (NSColor*)colorForNumber: (NSUInteger)number{
    if (number == 1) {
        return [NSColor colorWithSRGBRed:0 green:.8 blue:0 alpha:1];
    }else if (number == 2) {
        return [NSColor colorWithSRGBRed:.9 green:.9 blue:0 alpha:1];
    }else if (number == 3) {
        return [NSColor colorWithSRGBRed:.2 green:.2 blue:1 alpha:1];
    }else if (number == 4) {
        return [NSColor colorWithSRGBRed:.5 green:0 blue:.5 alpha:1];
    }else if (number == 5) {
        return [NSColor colorWithSRGBRed:1 green:.6 blue:0 alpha:1];
    }else if (number == 6) {
        return [NSColor colorWithSRGBRed:.7 green:.3 blue:0 alpha:1];
    }else if (number == 7) {
        return [NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:1];
    }else if (number == 8) {
        return [NSColor colorWithSRGBRed:.8 green:0 blue:0 alpha:1];
    }else{
        return 0;
    }
}

@end
