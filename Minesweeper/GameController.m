//
//  GameController.m
//  Minesweeper
//
//  Created by Programmieren on 23.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import "GameController.h"

@interface GameController ()

@property IBOutlet NSWindow *enterHighscoreNameSheet;

@property IBOutlet NSTextField *lblFields;
@property IBOutlet NSTextField *lblMines;
@property IBOutlet NSTextField *lblTime;
@property IBOutlet NSTextField *lblTurns;

@property IBOutlet NSTextField *txtNickname;

@property IBOutlet NSButton *chkAlwaysUseThisNickname;

@property IBOutlet NSButton *btnOkay;

- (IBAction)pushedOkay:(id)sender;

@end

@implementation GameController{
    NSPoint failurePoint;
    NSTimer *timer;
    
    GameSolver *solver;
}

@synthesize map = _map;
@synthesize activeGame = _activeGame;
@synthesize pausedGame = _pausedGame;

- (id)init{
    self = [super init];
    if (self) {
        [self startNewGame];
    }
    return self;
}

- (void)awakeFromNib{
    CGFloat squareWidth = [Preferences sharedPreferences].squareSize;
    if (squareWidth == SmallSquareSize){
        _itmSmallSquareSize.state = NSOnState;
        _itmMediumSquareSize.state = NSOffState;
        _itmLargeSquareSize.state = NSOffState;
    }else if (squareWidth == MediumSquareSize) {
        _itmSmallSquareSize.state = NSOffState;
        _itmMediumSquareSize.state = NSOnState;
        _itmLargeSquareSize.state = NSOffState;
    }else if (squareWidth == LargeSquareSize) {
        _itmSmallSquareSize.state = NSOffState;
        _itmMediumSquareSize.state = NSOffState;
        _itmLargeSquareSize.state = NSOnState;
    }else{
        squareWidth = MediumSquareSize;
        _itmSmallSquareSize.state = NSOffState;
        _itmMediumSquareSize.state = NSOnState;
        _itmLargeSquareSize.state = NSOffState;
    }
    _mapView.squareWidth = squareWidth;
    [self resizeForMapSize];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferencesChanged:)
                                                 name:PreferencesChangedNotification
                                               object:nil];
}

#pragma mark MapSizeChanges

- (void)preferencesChanged: (NSNotification*)notification{
    if (_map.size.width != MapSize.width||_map.size.height != MapSize.height||_map.numberOfMines != MinesPerMap) {
        [self resizeForMapSize];
        [self startNewGame];
    }
}

- (void)resizeForMapSize{
    NSSize newContentSize;
    newContentSize = NSMakeSize(MapSize.width * _mapView.squareWidth, (MapSize.height * _mapView.squareWidth) + 28);
    [_window setContentSize:newContentSize];
}

#pragma mark Game Controlling

- (void)startNewGame{
    [self newMap];
    [self setActiveGame:YES];
    [self setPausedGame:NO];
    _turns = 0;
    _time = 0;
    failurePoint = NSMakePoint(-1, -1);
    [self startTimer];
    [_mapView refresh];
}

- (void)newMap{
    solver = nil;
    _map = [Map mapWithSize:MapSize andMines:MinesPerMap];
    [_mapView setBlockUserEvents:NO];
}

- (BOOL)hasWon{
    for (NSUInteger x = 0; x < _map.size.width; x++) {
        for (NSUInteger y = 0; y < _map.size.height; y++) {
            NSPoint point = NSMakePoint(x, y);
            BOOL isMine = [_map mineAtPoint:point];
            BOOL isVisible = [_map isPointVisible:point];
            if (isMine == isVisible) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)endGameWinning{
    [self endGame];
    if (UseStandardNameForHighscores) {
        [self addHighscoreToHighscores];
    }else{
        if (!_enterHighscoreNameSheet) {
            [[NSBundle mainBundle] loadNibNamed: @"EnterHighscoreNameSheet"
                                          owner: self
                                topLevelObjects: nil];
        }
        
        _lblFields.stringValue =
        [NSNumberFormatter localizedStringFromNumber:@(_map.size.width*_map.size.height)
                                         numberStyle:NSNumberFormatterNoStyle];
        _lblMines.stringValue = @(_map.numberOfMines).stringValue;
        _lblTime.stringValue = [NSString stringWithFormat:@"%@ %@",
                                [NSNumberFormatter localizedStringFromNumber: @(_time)
                                                                 numberStyle: NSNumberFormatterDecimalStyle],
                                NSLocalizedStringFromTable (@"seconds",
                                                            @"Localizable",
                                                            @"Seconds")];
        _lblTurns.stringValue = @(_turns).stringValue;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChange:)
                                                     name:NSControlTextDidChangeNotification
                                                   object:_txtNickname];
        
        [NSApp beginSheet:_enterHighscoreNameSheet
           modalForWindow:_window
            modalDelegate:self
           didEndSelector:NULL
              contextInfo:NULL];
    }
}

- (void)addHighscoreToHighscores{
    if (solver) return;
    NSString *nickname = (UseStandardNameForHighscores) ? StandardNameForHighscores : _txtNickname.stringValue;
    Highscore *highscore;
    highscore = [[Highscore alloc] initWithNickname:nickname
                                             fields:(NSUInteger)(_map.size.width*_map.size.height)
                                              mines:_map.numberOfMines
                                               time:_time
                                              turns:_turns];
    [[Highscores sharedHighscores] addHighscore:highscore];
}

- (void)endGameLosing{
    [self endGame];
}

- (void)endGame{
    [self setActiveGame:NO];
    [self setPausedGame:NO];
    [self stopTimer];
    [_map makeAllPointsVisible];
    [_mapView refresh];
}

#pragma mark Timer Controlling

- (void)startTimer{
    [timer invalidate];
    timer = nil;
    timer = [NSTimer timerWithTimeInterval:.1
                                    target:self
                                  selector:@selector(timerDidFire)
                                  userInfo:nil
                                   repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer{
    [timer invalidate];
    timer = nil;
}

- (void)timerDidFire{
    _time += (double).1;
}

#pragma mark MapViewDelegate

- (Map *)map{
    return _map;
}

- (void)setMap:(Map *)map{
    _map = map;
}

- (BOOL)activeGame{
    return _activeGame;
}

- (void)setActiveGame:(BOOL)activeGame{
    _activeGame = activeGame;
    if (!_activeGame) {
        [self setPausedGame:NO];
    }
}

- (BOOL)pausedGame{
    return _pausedGame;
}

- (void)setPausedGame:(BOOL)pausedGame{
    if (!_activeGame) {
        _pausedGame = NO;
        return;
    }
    BOOL redraw = (_pausedGame != pausedGame);
    _pausedGame = pausedGame;
    if (_pausedGame) {
        [self stopTimer];
    }else{
        [self startTimer];
    }
    if (redraw) [_mapView refresh];
}

- (void)clickedPoint:(NSPoint)mapPoint{
    if (!_activeGame||_pausedGame||[_map isPointFlagged:mapPoint]) {
        return;
    }
    if ([_map mineAtPoint:mapPoint]) {
        if (_turns > 0) {
            failurePoint = mapPoint;
            [self endGameLosing];
        }else{
            BOOL restartSolver = (solver != nil);
            [self newMap];
            while ([_map mineAtPoint:mapPoint]) {
                [self newMap];
            }
            [_map setVisible:YES atPoint:mapPoint];
            if ([_map minesAroundPoint:mapPoint] > 0) {
                [_mapView refreshPoint:mapPoint];
            }else{
                [_mapView refresh];
            }
            _turns++;
            if ([self hasWon]) {
                [self endGameWinning];
            }else if (restartSolver) {
                [self startSolver];
            }
            return;
        }
    }else{
        [_map setVisible:YES atPoint:mapPoint];
        if ([_map minesAroundPoint:mapPoint] > 0) {
            [_mapView refreshPoint:mapPoint];
        }else{
            [_mapView refresh];
        }
        _turns++;
        if ([self hasWon]) {
            [self endGameWinning];
        }
    }    
}

- (void)markedPoint:(NSPoint)mapPoint{
    if (!_activeGame||_pausedGame) {
        return;
    }
    BOOL isFlagged = [_map isPointFlagged:mapPoint];
    [_map setFlagged:!isFlagged atPoint:mapPoint];
    [_mapView refreshPoint:mapPoint];
    _turns++;
}

- (NSPoint)failurePoint{
    return failurePoint;
}

- (void)startSolver{
    if (solver) return;
    solver = [StandardSolver gameSolverForMap:_map
                               andWithMapView:_mapView];
    [solver startSolving];
}

#pragma mark NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification{
    [[Preferences sharedPreferences] save];
    [NSApp terminate:self];
}

- (void)windowDidResignKey:(NSNotification *)notification{
    if (_activeGame&&PauseOnDeactivate) [self setPausedGame:YES];
}

#pragma mark Public Actions

- (void)pushedNewGame:(id)sender{
    [self startNewGame];
    [_window makeKeyWindow];
    [_window orderFront:self];
}

- (void)pushedPause:(id)sender{
    if (_activeGame) {
        [self setPausedGame:!_pausedGame];
    }
}

- (void)pushedSmallSquareSize:(id)sender{
    if (_mapView.squareWidth != SmallSquareSize) {
        _mapView.squareWidth = SmallSquareSize;
        [self resizeForMapSize];
        [Preferences sharedPreferences].squareSize = SmallSquareSize;
    }
    _itmSmallSquareSize.state = NSOnState;
    _itmMediumSquareSize.state = NSOffState;
    _itmLargeSquareSize.state = NSOffState;
}

- (void)pushedMediumSquareSize:(id)sender{
    if (_mapView.squareWidth != MediumSquareSize) {
        _mapView.squareWidth = MediumSquareSize;
        [self resizeForMapSize];
        [Preferences sharedPreferences].squareSize = MediumSquareSize;
    }
    _itmSmallSquareSize.state = NSOffState;
    _itmMediumSquareSize.state = NSOnState;
    _itmLargeSquareSize.state = NSOffState;
}

- (void)pushedLargeSquareSize:(id)sender{
    if (_mapView.squareWidth != LargeSquareSize) {
        _mapView.squareWidth = LargeSquareSize;
        [self resizeForMapSize];
        [Preferences sharedPreferences].squareSize = LargeSquareSize;
    }
    _itmSmallSquareSize.state = NSOffState;
    _itmMediumSquareSize.state = NSOffState;
    _itmLargeSquareSize.state = NSOnState;
}

#pragma mark EnterHighscoreNameSheet Actions

- (void)textDidChange:(NSNotification *)aNotification{
    [_btnOkay setEnabled:(_txtNickname.stringValue.length > 0)];
}

- (void)pushedOkay:(id)sender{
    [NSApp endSheet:_enterHighscoreNameSheet];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSControlTextDidChangeNotification
                                                  object:_txtNickname];
    [self addHighscoreToHighscores];
    if (_chkAlwaysUseThisNickname.state == YES) {
        [[Preferences sharedPreferences] setUseStandardNameForHighscores:YES];
        [[Preferences sharedPreferences] setStandardNameForHighscroes:_txtNickname.stringValue];
        [[Preferences sharedPreferences] save];
    }
    [_enterHighscoreNameSheet close];
    _enterHighscoreNameSheet = nil;
}

@end
