//
//  PreferencesController.m
//  Minesweeper
//
//  Created by Programmieren on 25.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import "PreferencesController.h"

@implementation PreferencesController

#pragma mark Show Preferences

- (void)showPreferences:(id)sender{
    if (!_preferencesWindow) {
        [[NSBundle mainBundle] loadNibNamed: @"PreferencesWindow"
                                      owner: self
                            topLevelObjects: nil];
        
        if (MapSize.width == 8&&MapSize.height == 8&&MinesPerMap == 10) {
            [_mtxMapSize selectCellAtRow:0 column:0];
        }else if (MapSize.width == 16&&MapSize.height == 16&&MinesPerMap == 40) {
            [_mtxMapSize selectCellAtRow:1 column:0];
        }else if (MapSize.width == 30&&MapSize.height == 16&&MinesPerMap == 99) {
            [_mtxMapSize selectCellAtRow:2 column:0];
        }else{
            [_mtxMapSize selectCellAtRow:3 column:0];
            [_txtCustomMapWidth setEnabled:YES];
            [_stpCustomMapWidth setEnabled:YES];
            [_txtCustomMapHeight setEnabled:YES];
            [_stpCustomMapHeight setEnabled:YES];
            [_txtCustomMinesPerMap setEnabled:YES];
            [_stpCustomMinesPerMap setEnabled:YES];
            _txtCustomMapWidth.integerValue = MapSize.width;
            _stpCustomMapWidth.integerValue = MapSize.width;
            _txtCustomMapHeight.integerValue = MapSize.height;
            _stpCustomMapHeight.integerValue = MapSize.height;
            _txtCustomMinesPerMap.integerValue = MinesPerMap;
            _stpCustomMinesPerMap.integerValue = MinesPerMap;
        }
        
        _chkUseStandardNickname.state = UseStandardNameForHighscores;
        [_txtStandardNickName setEnabled:UseStandardNameForHighscores];

        _txtStandardNickName.stringValue = StandardNameForHighscores;
        
        _chkPlaySounds.state = PlaySounds;
        
        _chkPauseOnDeactivate.state = PauseOnDeactivate;
    }
    [_preferencesWindow makeKeyWindow];
    [_preferencesWindow orderFront:self];
}

#pragma mark Hide Preferences

- (void)pushedOkay:(id)sender{
    NSSize mapSize;
    NSUInteger minesPerMap;
    if (_mtxMapSize.selectedRow == 0) {
        mapSize = NSMakeSize(8, 8);
        minesPerMap = 10;
    }else if (_mtxMapSize.selectedRow == 1) {
        mapSize = NSMakeSize(16, 16);
        minesPerMap = 40;
    }else if (_mtxMapSize.selectedRow == 2) {
        mapSize = NSMakeSize(30, 16);
        minesPerMap = 99;
    }else if (_mtxMapSize.selectedRow == 3) {
        mapSize = NSMakeSize(_stpCustomMapWidth.integerValue,
                             _stpCustomMapHeight.integerValue);
        minesPerMap = _stpCustomMinesPerMap.integerValue;
    }else{
        mapSize = NSMakeSize(8, 8);
        minesPerMap = 10;
    }
    
    Preferences *preferences = [Preferences sharedPreferences];
    [preferences stopSendingNotifications];
    [preferences setMapSize:mapSize];
    [preferences setMinesPerMap:minesPerMap];
    [preferences setUseStandardNameForHighscores:_chkUseStandardNickname.state];
    [preferences setStandardNameForHighscroes:_txtStandardNickName.stringValue];
    [preferences setPlaySounds:_chkPlaySounds.state];
    [preferences setPauseOnDeactivate:_chkPauseOnDeactivate.state];
    [preferences save];
    [preferences continueSendingNotificationsWithChangedNotification];
    
    [_preferencesWindow close];
    _preferencesWindow = nil;
}

- (void)pushedCancel:(id)sender{
    [_preferencesWindow close];
    _preferencesWindow = nil;
}

#pragma mark MapSize Actions

- (IBAction)selectedMapSize:(id)sender{
    BOOL enableCustomMapControlls = (_mtxMapSize.selectedRow == 3);
    
    [_txtCustomMapWidth setEnabled:enableCustomMapControlls];
    [_stpCustomMapWidth setEnabled:enableCustomMapControlls];
    [_txtCustomMapHeight setEnabled:enableCustomMapControlls];
    [_stpCustomMapHeight setEnabled:enableCustomMapControlls];
    [_txtCustomMinesPerMap setEnabled:enableCustomMapControlls];
    [_stpCustomMinesPerMap setEnabled:enableCustomMapControlls];
}

- (IBAction)txtCustomMapSizeChanged:(id)sender{
    _stpCustomMapWidth.stringValue = _txtCustomMapWidth.stringValue;
    _stpCustomMapHeight.stringValue = _txtCustomMapHeight.stringValue;
    
    NSUInteger maxMines = (_stpCustomMapWidth.integerValue * _stpCustomMapHeight.integerValue * .93) - 1;
    if (_txtCustomMinesPerMap.integerValue > maxMines) {
        _txtCustomMinesPerMap.integerValue = maxMines;
    }
    if (_stpCustomMinesPerMap.integerValue > maxMines) {
        _stpCustomMinesPerMap.integerValue = maxMines;
    }
    _fmtCustomMinesPerMap.maximum = @(maxMines);
    _stpCustomMinesPerMap.maxValue = (double)maxMines;
}

- (IBAction)stpCustomMapSizeChanged:(id)sender{
    _txtCustomMapWidth.stringValue = _stpCustomMapWidth.stringValue;
    _txtCustomMapHeight.stringValue = _stpCustomMapHeight.stringValue;
    
    NSUInteger maxMines = (_stpCustomMapWidth.integerValue * _stpCustomMapHeight.integerValue * .93) - 1;
    if (_txtCustomMinesPerMap.integerValue > maxMines) {
        _txtCustomMinesPerMap.integerValue = maxMines;
    }
    if (_stpCustomMinesPerMap.integerValue > maxMines) {
        _stpCustomMinesPerMap.integerValue = maxMines;
    }
    _fmtCustomMinesPerMap.maximum = @(maxMines);
    _stpCustomMinesPerMap.maxValue = (double)maxMines;
}

- (IBAction)txtCustomMinesPerMapChanged:(id)sender{
    _stpCustomMinesPerMap.stringValue = _txtCustomMinesPerMap.stringValue;
}

- (IBAction)stpCustomMinesPerMapChanged:(id)sender{
    _txtCustomMinesPerMap.stringValue = _stpCustomMinesPerMap.stringValue;
}

#pragma mark DefaultNickname Actions

- (IBAction)chkUseStandardNicknameChanged:(id)sender{
    [_txtStandardNickName setEnabled:_chkUseStandardNickname.state];
}

@end
