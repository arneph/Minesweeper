//
//  NeuralNet.h
//  Minesweeper
//
//  Created by A Philipeit on 13/09/2016.
//  Copyright © 2016 Arne Philipeit Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeuralNet : NSObject

+ (instancetype)neuralNetWithLayerSizes: (NSArray *)layerSizes;
- (instancetype)initWithLayerSizes: (NSArray *)layerSizes;

- (NSArray *)calculateOutput: (NSArray *)input;

- (void)improveWithInput: (NSArray *)input
           desiredOutput: (NSArray *)desiredOutput
              stepFactor: (double)stepFactor;

@end
