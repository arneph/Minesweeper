//
//  NeuralNet.h
//  Minesweeper
//
//  Created by A Philipeit on 18/09/2016.
//  Copyright © 2016 Arne Philipeit Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeuralNet : NSObject

+ (NeuralNet *)neuralNetWithLayerWidths: (NSArray *)layerWidths;

- (NSArray *)calculateOutputForInput: (NSArray *)input;

+ (double)calculatePerformanceOfOutput: (NSArray *)output
               comparedToDesiredOutput: (NSArray *)desiredOutput;

- (void)improveWithInput: (NSArray *)input
           desiredOutput: (NSArray *)desiredOutput
             andStepSize: (double)stepSize;

@end
