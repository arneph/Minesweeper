//
//  HighscoresController.m
//  Minesweeper
//
//  Created by Programmieren on 25.03.13.
//  Copyright (c) 2013 Arne Philipeit Software. All rights reserved.
//

#import "HighscoresController.h"

@implementation HighscoresController

- (void)showHighscores:(id)sender{
    if (!_highscoresWindow) {
        [[NSBundle mainBundle] loadNibNamed: @"HighscoresWindow"
                                      owner: self
                            topLevelObjects: nil];
    }
    [_highscoresWindow makeKeyWindow];
    [_highscoresWindow orderFront:self];
}

- (void)windowWillClose:(NSNotification *)notification{
    _highscoresWindow = nil;
}

- (void)awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(highscoresChanged:)
                                                 name:HighscoresChangedNotification
                                               object:nil];
}

- (void)highscoresChanged: (NSNotification*)notification{
    [_tableHighscores reloadData];
}

- (void)clearHighscoreList:(id)sender{
    [[Highscores sharedHighscores] clearHighscores];
}

#pragma mark NSTableView Delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [Highscores sharedHighscores].highscoresArray.count;
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row{
    Highscore *highscore = [Highscores sharedHighscores].highscoresArray[row];
    if ([tableColumn.identifier isEqualToString:@"nickname"]) {
        return highscore.nickname;
    }else if([tableColumn.identifier isEqualToString:@"fields"]) {
        return @(highscore.fields);
    }else if([tableColumn.identifier isEqualToString:@"mines"]) {
        return @(highscore.mines);
    }else if([tableColumn.identifier isEqualToString:@"time"]) {
        return @(highscore.time);
    }else if([tableColumn.identifier isEqualToString:@"turns"]) {
        return @(highscore.turns);
    }else if([tableColumn.identifier isEqualToString:@"date"]) {
        return highscore.date;
    }else{
        return nil;
    }
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors{
    [[Highscores sharedHighscores] sortHighscoresArrayUsingSortDescriptors:_tableHighscores.sortDescriptors];
    [_tableHighscores reloadData];
}

@end
