//
//  NeuralNetSolver.m
//  Minesweeper
//
//  Created by A Philipeit on 13/09/2016.
//  Copyright © 2016 Arne Philipeit Software. All rights reserved.
//

#import "NeuralNetSolver.h"
#import <CoreAI/CoreAI.h>

const NSMutableArray *sizes;
const NSMutableArray *neuralNets;

@implementation NeuralNetSolver{
    NeuralNet *neuralNet;
}

- (instancetype)initForMap: (Map *)map
            andWithMapView: (MapView *)mapView {
    self = [super initForMap: map
              andWithMapView: mapView];
    
    if (self) {
        neuralNet = [NeuralNetSolver neuralNetForSize: map.size];
    }
    
    return self;
}

+ (NeuralNet *)neuralNetForSize: (NSSize)size {
    if (!sizes || !neuralNets) {
        sizes = [[NSMutableArray alloc] init];
        neuralNets = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < sizes.count; i++) {
        NSArray *sizeArray = sizes[0];
        
        NSUInteger w = ((NSNumber *) sizeArray[0]).unsignedIntegerValue;
        NSUInteger h = ((NSNumber *) sizeArray[1]).unsignedIntegerValue;
        
        if (w == size.width && h == size.height) {
            return neuralNets[i];
        }
    }
    
    NSUInteger w = size.width;
    NSUInteger h = size.height;
    NSUInteger c = w * h;
    
    NeuralNet *neuralNet = [NeuralNet neuralNetWithLayerWidths: @[@(c), @(c), @(c), @(c), @(c), @(c)]];
    
    [NeuralNetSolver trainNeuralNet: neuralNet
                               size: size];
    
    [sizes addObject: @[@(w), @(h)]];
    [neuralNets addObject: neuralNet];
    
    return neuralNet;
}

+ (void)trainNeuralNet: (NeuralNet *)neuralNet size: (NSSize)size {
    NSUInteger improvements = 0;
    double performance = -30.0;
    
    for (int i = 0; i < 1000; i++) {
        Map *map = [Map mapWithSize: size
                           andMines: size.width * size.height / 3.0];
        
        while (map.numberOfVisiblePoints < map.size.width * map.size.height - map.numberOfMines) {
            NSPoint p = NSMakePoint(-1, -1);
            
            while (p.x == -1 || p.y == -1 ||
                   [map isPointVisible: p] ||
                   [map mineAtPoint: p]) {
                p.x = arc4random() % (NSUInteger)map.size.width;
                p.y = arc4random() % (NSUInteger)map.size.height;
            }
            
            [map setVisible: YES atPoint: p];
            
            if (map.numberOfVisiblePoints < 20) continue;
            
            NSUInteger w = map.size.width;
            NSUInteger h = map.size.height;
            NSUInteger c = w * h;
            
            NSMutableArray *input = [NSMutableArray arrayWithCapacity: c];
            NSMutableArray *desiredOutput = [NSMutableArray arrayWithCapacity: c];
            
            for (NSUInteger i = 0; i < w; i++) {
                for (NSUInteger j = 0; j < h; j++) {
                    NSPoint point = NSMakePoint(i, j);
                    
                    double a, b;
                    
                    if (![map isPointVisible: point]) {
                        a = 1.0;
                        b = ([map mineAtPoint: point] ||
                             [map visiblePointsArroundPoint: point] < 1) ? 0.0 : 1.0;
                    }else{
                        a = [map minesAroundPoint: point] / 9.0;
                        b = 0.0;
                    }
                    
                    [input addObject: @(a)];
                    [desiredOutput addObject: @(b)];
                }
            }
            
            [neuralNet improveWithInput: input
                          desiredOutput: desiredOutput
                            andStepSize: 0.1];
            improvements++;
            
            NSArray *output = [neuralNet calculateOutputForInput: input];
            
            performance = [NeuralNet calculatePerformanceOfOutput: (NSArray *)output
                                          comparedToDesiredOutput: (NSArray *)desiredOutput];
            
            //if (improvements % 1000 == 0)
            printf("Improvements: %lu Performance: %f\n", (unsigned long)improvements, performance);
        }
    }
}

- (void)performNextMove{
    NSUInteger w = self.map.size.width;
    NSUInteger h = self.map.size.height;
    NSUInteger c = w * h;
    
    NSMutableArray *input = [NSMutableArray arrayWithCapacity: c];
    
    for (NSUInteger i = 0; i < w; i++) {
        for (NSUInteger j = 0; j < h; j++) {
            NSPoint point = NSMakePoint(i, j);
            
            if (![self.map isPointVisible: point]) {
                [input addObject: @1.0];
            }else{
                [input addObject: @([self.map minesAroundPoint: point] / 9.0)];
            }
        }
    }
    
    NSArray *output = [neuralNet calculateOutputForInput: input];
    
    NSUInteger bestIndex = 0;
    double bestOutput = ((NSNumber *) output[0]).doubleValue;
    
    for (NSUInteger i = 1; i < c; i++) {
        if (((NSNumber *) output[i]).doubleValue > bestOutput) {
            bestIndex = i;
            bestOutput = ((NSNumber *) output[i]).doubleValue;
        }
    }
    
    NSUInteger x = bestIndex / w;
    NSUInteger y = bestIndex % h;
    
    [self clickPoint: NSMakePoint(x, y)];
}

@end
