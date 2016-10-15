//
//  PreferencesController.h
//  Minesweeper
//
//  Created by Programmieren on 25.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Preferences.h"

@interface PreferencesController : NSObject

@property IBOutlet NSWindow *preferencesWindow;

@property IBOutlet NSMatrix *mtxMapSize;
@property IBOutlet NSTextField *txtCustomMapWidth;
@property IBOutlet NSTextField *txtCustomMapHeight;
@property IBOutlet NSTextField *txtCustomMinesPerMap;
@property IBOutlet NSNumberFormatter *fmtCustomMinesPerMap;
@property IBOutlet NSStepper *stpCustomMapWidth;
@property IBOutlet NSStepper *stpCustomMapHeight;
@property IBOutlet NSStepper *stpCustomMinesPerMap;

@property IBOutlet NSButton *chkUseStandardNickname;
@property IBOutlet NSTextField *txtStandardNickName;

@property IBOutlet NSButton *chkPlaySounds;

@property IBOutlet NSButton *chkPauseOnDeactivate;

- (IBAction)showPreferences:(id)sender;

- (IBAction)pushedOkay:(id)sender;
- (IBAction)pushedCancel:(id)sender;

- (IBAction)selectedMapSize:(id)sender;
- (IBAction)txtCustomMapSizeChanged:(id)sender;
- (IBAction)stpCustomMapSizeChanged:(id)sender;
- (IBAction)txtCustomMinesPerMapChanged:(id)sender;
- (IBAction)stpCustomMinesPerMapChanged:(id)sender;

- (IBAction)chkUseStandardNicknameChanged:(id)sender;

@end
