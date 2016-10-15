//
//  NeuralNet.m
//  Minesweeper
//
//  Created by A Philipeit on 13/09/2016.
//  Copyright © 2016 Arne Philipeit Software. All rights reserved.
//

#import "NeuralNet.h"

@interface Neuron : NSObject

+ (instancetype)neuronWithInputs: (NSUInteger)numberOfInputs;
- (instancetype)initWithInputs: (NSUInteger)numberOfInputs;

- (NSUInteger)numberOfInputs;

- (double)weightAtIndex: (NSUInteger)index;
- (void)setWeidht: (double)w atIndex: (NSUInteger)index;

- (double)calculateSum: (NSArray *)inputs;
- (double)calculateOutput: (NSArray *)inputs;

@end

@implementation Neuron{
    NSMutableArray *weights;
}

+ (instancetype)neuronWithInputs: (NSUInteger)n{
    return [[Neuron alloc] initWithInputs: n];
}

- (instancetype)initWithInputs: (NSUInteger)n {
    if (n < 1) {
        @throw NSInvalidArgumentException;
    }
    
    self = [super init];
    
    if (self){
        weights = [NSMutableArray arrayWithCapacity: n + 1];
        
        [weights addObject: @(randomDouble() * n)];
        
        for (int i = 1; i < n + 1; i++) {
            [weights addObject: @(randomDouble())];
        }
    }
    
    return self;
}

- (NSUInteger)numberOfInputs{
    return weights.count - 1;
}

- (double)weightAtIndex: (NSUInteger)index{
    if (index > weights.count) {
        @throw NSInvalidArgumentException;
    }
    
    return ((NSNumber *) weights[index]).doubleValue;
}

- (void)setWeidht: (double)w atIndex: (NSUInteger)index {
    if (index > weights.count) {
        @throw NSInvalidArgumentException;
    }
    
    weights[index] = @(w);
}

- (double)calculateSum: (NSArray *)inputs {
    if (inputs.count != weights.count - 1) {
        @throw NSInvalidArgumentException;
    }
    
    double alpha = ((NSNumber *) weights[0]).doubleValue;
    
    for (int i = 0; i < inputs.count; i++) {
        double x = ((NSNumber *) inputs[i]).doubleValue;
        double w = ((NSNumber *) weights[i + 1]).doubleValue;
        
        alpha += x * w;
    }
    
    return alpha;
}

- (double)calculateOutput: (NSArray *)inputs {
    if (inputs.count != weights.count - 1) {
        @throw NSInvalidArgumentException;
    }
    
    double alpha = ((NSNumber *) weights[0]).doubleValue;
    
    for (int i = 0; i < inputs.count; i++) {
        double x = ((NSNumber *) inputs[i]).doubleValue;
        double w = ((NSNumber *) weights[i + 1]).doubleValue;
        
        alpha += x * w;
    }
    
    double beta = sigmoid(alpha);
    
    return beta;
}

double randomDouble() {
    return ((double)arc4random() / 0x100000000);
}

double sigmoid(double x) {
    return 1.0 / (1.0 + exp(-x));
}

@end

@interface NeuronLayer : NSObject

+ (instancetype)neuronLayerWithSize: (NSUInteger)size
                          andInputs: (NSUInteger)inputs;
- (instancetype)initWithSize: (NSUInteger)n
                   andInputs: (NSUInteger)m;

- (NSUInteger)numberOfNeurons;
- (Neuron *)getNeuronAtIndex: (NSUInteger)index;

- (NSArray *)calculateSumsForFirstLayer: (NSArray *)input;
- (NSArray *)calculateSums: (NSArray *)input;
- (NSArray *)calculateOutputForFirstLayer: (NSArray *)input;
- (NSArray *)calculateOutput: (NSArray *)input;

@end

@implementation NeuronLayer{
    NSArray *neurons;
}

+ (instancetype)neuronLayerWithSize: (NSUInteger)size
                          andInputs: (NSUInteger)inputs {
    return [[NeuronLayer alloc] initWithSize: size
                                   andInputs: inputs];
}

- (instancetype)initWithSize: (NSUInteger)n
                   andInputs: (NSUInteger)m {
    if (n < 1 || m < 1) {
        @throw NSInvalidArgumentException;
    }
    
    self = [super init];
    
    if (self) {
        NSMutableArray *tNeurons = [NSMutableArray arrayWithCapacity: n];
        
        for (int i = 0; i < n; i++) {
            [tNeurons addObject: [Neuron neuronWithInputs: m]];
        }
        
        neurons = tNeurons.copy;
    }
    
    return self;
}

- (NSUInteger)numberOfNeurons{
    return neurons.count;
}

- (Neuron *)getNeuronAtIndex: (NSUInteger)index {
    if (index >= neurons.count) {
        @throw NSInvalidArgumentException;
    }
    
    return neurons[index];
}

- (NSArray *)calculateSumsForFirstLayer: (NSArray *)input {
    if (input.count != neurons.count) {
        @throw NSInvalidArgumentException;
    }
    
    NSMutableArray *tOuput = [NSMutableArray arrayWithCapacity: neurons.count];
    
    for (int i = 0; i < neurons.count; i++) {
        Neuron *neuron = neurons[i];
        double output = [neuron calculateSum: @[input[i]]];
        
        [tOuput addObject: @(output)];
    }
    
    return tOuput.copy;
}

- (NSArray *)calculateSums: (NSArray *)input {
    NSMutableArray *tOuput = [NSMutableArray arrayWithCapacity: neurons.count];
    
    for (int i = 0; i < neurons.count; i++) {
        Neuron *neuron = neurons[i];
        double output = [neuron calculateSum: input];
        
        [tOuput addObject: @(output)];
    }
    
    return tOuput.copy;
}

- (NSArray *)calculateOutputForFirstLayer: (NSArray *)input {
    if (input.count != neurons.count) {
        @throw NSInvalidArgumentException;
    }
    
    NSMutableArray *tOuput = [NSMutableArray arrayWithCapacity: neurons.count];
    
    for (int i = 0; i < neurons.count; i++) {
        Neuron *neuron = neurons[i];
        double output = [neuron calculateOutput: @[input[i]]];
        
        [tOuput addObject: @(output)];
    }
    
    return tOuput.copy;
}

- (NSArray *)calculateOutput: (NSArray *)input {
    NSMutableArray *tOuput = [NSMutableArray arrayWithCapacity: neurons.count];
    
    for (int i = 0; i < neurons.count; i++) {
        Neuron *neuron = neurons[i];
        double output = [neuron calculateOutput: input];
        
        [tOuput addObject: @(output)];
    }
    
    return tOuput.copy;
}

@end

@implementation NeuralNet{
    NSArray *neuronLayers;
}

+ (instancetype)neuralNetWithLayerSizes: (NSArray *)layerSizes {
    return [[NeuralNet alloc] initWithLayerSizes: layerSizes];
}

- (instancetype)initWithLayerSizes: (NSArray *)layerSizes {
    if (layerSizes.count < 2) {
        @throw NSInvalidArgumentException;
    }
    
    self = [super init];
    
    if (self) {
        NSMutableArray *tNeuronLayers = [NSMutableArray arrayWithCapacity: layerSizes.count];
        
        for (int i = 0; i < layerSizes.count; i++) {
            NSUInteger inputs = (i == 0) ? 1 : ((NSNumber *) layerSizes[i - 1]).unsignedIntegerValue;
            NSUInteger size = ((NSNumber *) layerSizes[i]).unsignedIntegerValue;
            
            [tNeuronLayers addObject: [NeuronLayer neuronLayerWithSize: size
                                                             andInputs: inputs]];
        }
        
        neuronLayers = tNeuronLayers.copy;
    }
    
    return self;
}

- (NSArray *)calculateOutput: (NSArray *)input {
    NeuronLayer *firstLayer = neuronLayers[0];
    
    NSArray *output = [firstLayer calculateOutputForFirstLayer: input];
    
    for (int i = 1; i < neuronLayers.count; i++) {
        NeuronLayer *neuronLayer = neuronLayers[i];
        
        output = [neuronLayer calculateOutput: input];
    }
    
    return output;
}


- (void)improveWithInput: (NSArray *)input
           desiredOutput: (NSArray *)desiredOutput
              stepFactor: (double)stepFactor {
    NSArray *outputsFromLayers = [self calculateOutputsFromLayers: input];
    NSArray *finalOutput = outputsFromLayers.lastObject;
    
    //Calculating reusable partial derivates:
    NSMutableArray *tdDesiredOutput_dFinalOutput = [NSMutableArray arrayWithCapacity: finalOutput.count];
    for (int i = 0; i < finalOutput.count; i++) {
        double d = ((NSNumber *) desiredOutput[i]).doubleValue;
        double z = ((NSNumber *) finalOutput[i]).doubleValue;
        
        [tdDesiredOutput_dFinalOutput addObject: @(d - z)];
    }
    
    NSMutableArray *tdOutputsFromLayers_dSumsFromLayers = [NSMutableArray arrayWithCapacity: neuronLayers.count];
    for (int i = 0; i < neuronLayers.count; i++) {
        NeuronLayer *neuronLayer = neuronLayers[i];
        NSMutableArray *tdOutputFromLayer_dSumFromLayer = [NSMutableArray arrayWithCapacity: neuronLayer.numberOfNeurons];
        
        for (int j = 0; j < neuronLayer.numberOfNeurons; j++) {
            double beta = ((NSNumber *) outputsFromLayers[i][j]).doubleValue;
            
            [tdOutputFromLayer_dSumFromLayer addObject: @(beta * (1.0 - beta))];
        }
    }
    
    NSMutableArray *tdDesiredOutput_dOutputsFromLayers = [NSMutableArray arrayWithCapacity: neuronLayers.count];
    [tdDesiredOutput_dOutputsFromLayers addObject: tdDesiredOutput_dFinalOutput.copy];
    
    for (int i = neuronLayers.count - 2; i >= 0; i--) {
        NeuronLayer *neuronLayer = neuronLayers[i];
        NSMutableArray *tdDesiredOutput_dOutputFromLayer = [NSMutableArray arrayWithCapacity: neuronLayer.numberOfNeurons];
        
        for (int j = 0; j < neuronLayer.numberOfNeurons; j++) {
            
        }
    }
    
    NSArray *dDesiredOutput_dOutputsFromLayers = tdDesiredOutput_dOutputsFromLayers.copy;
    
    //Improving weights:
    for (int i = 0; i < neuronLayers.count; i++) {
        NeuronLayer *neuronLayer = neuronLayers[i];
        
        for (int j = 0; j < neuronLayer.numberOfNeurons; j++) {
            Neuron *neuron = [neuronLayer getNeuronAtIndex: j];
            
            for (int k = 0; k < neuron.numberOfInputs + 1; k++) {
                double a = ((NSNumber *) ((i == 0) ? input[j] : outputsFromLayers[i][j])).doubleValue;
                double b = ((NSNumber *) dOutputsFromLayers_dSumsFromLayers[i][j]).doubleValue;
                
                
            }
        }
    }
}

- (NSArray *)calculateSumsFromLayers: (NSArray *)input {
    NSMutableArray *tOutputs = [NSMutableArray arrayWithCapacity: neuronLayers.count];
    
    NeuronLayer *firstLayer = neuronLayers[0];
    
    NSArray *output = [firstLayer calculateOutputForFirstLayer: input];
    
    [tOutputs addObject: output];
    
    for (int i = 1; i < neuronLayers.count; i++) {
        NeuronLayer *neuronLayer = neuronLayers[i];
        
        output = [neuronLayer calculateSums: input];
        
        [tOutputs addObject: output];
    }
    
    return tOutputs.copy;
}

- (NSArray *)calculateOutputsFromLayers: (NSArray *)input {
    NSMutableArray *tOutputs = [NSMutableArray arrayWithCapacity: neuronLayers.count];
    
    NeuronLayer *firstLayer = neuronLayers[0];
    
    NSArray *output = [firstLayer calculateOutputForFirstLayer: input];
    
    [tOutputs addObject: output];
    
    for (int i = 1; i < neuronLayers.count; i++) {
        NeuronLayer *neuronLayer = neuronLayers[i];
        
        output = [neuronLayer calculateOutput: input];
        
        [tOutputs addObject: output];
    }
    
    return tOutputs.copy;
}

@end
