//
//  GameController.h
//  Minesweeper
//
//  Created by Programmieren on 23.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "MapView.h"
#import "StandardSolver.h"
#import "NeuralNetSolver.h"
#import "Preferences.h"
#import "Highscores.h"

@interface GameController : NSObject <MapViewDelegate, NSWindowDelegate>

@property (readonly) Map *map;
@property (readonly) BOOL activeGame;
@property (readonly) BOOL pausedGame;
@property (readonly) NSUInteger turns;
@property (readonly) double time;

@property IBOutlet NSWindow *window;
@property IBOutlet MapView *mapView;

@property IBOutlet NSMenuItem *itmSmallSquareSize;
@property IBOutlet NSMenuItem *itmMediumSquareSize;
@property IBOutlet NSMenuItem *itmLargeSquareSize;

- (IBAction)pushedNewGame:(id)sender;
- (IBAction)pushedPause:(id)sender;

- (IBAction)pushedSmallSquareSize:(id)sender;
- (IBAction)pushedMediumSquareSize:(id)sender;
- (IBAction)pushedLargeSquareSize:(id)sender;

@end
