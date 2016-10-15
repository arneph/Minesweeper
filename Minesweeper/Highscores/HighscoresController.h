//
//  HighscoresController.h
//  Minesweeper
//
//  Created by Programmieren on 25.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Highscores.h"

@interface HighscoresController : NSObject <NSWindowDelegate, NSTableViewDataSource>

@property IBOutlet NSWindow *highscoresWindow;
@property IBOutlet NSTableView *tableHighscores;

- (IBAction)showHighscores:(id)sender;

- (IBAction)clearHighscoreList:(id)sender;

@end
