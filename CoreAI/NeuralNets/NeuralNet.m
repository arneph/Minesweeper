//
//  NeuralNet.m
//  Minesweeper
//
//  Created by A Philipeit on 18/09/2016.
//  Copyright © 2016 Arne Philipeit Software. All rights reserved.
//

#import "NeuralNet.h"

double sigmoid(double alpha) {
    return 1.0 / (1.0 + exp(-alpha));
}

NSUInteger * unsignedIntegerArrayFromNSArray(NSArray * a) {
    if (!a) {
        return NULL;
    }
    
    NSUInteger * b = malloc(a.count * sizeof(double));
    
    for (int i = 0; i < a.count; i++) {
        if (![a[i] isKindOfClass: [NSNumber class]]) {
            free(b);
            
            return NULL;
            
        }else{
            b[i] = ((NSNumber *) a[i]).unsignedIntegerValue;
        }
    }
    
    return b;
}

double * doubleArrayFromNSArray(NSArray * a) {
    if (!a) {
        return NULL;
    }
    
    double * b = malloc(a.count * sizeof(double));
    
    for (int i = 0; i < a.count; i++) {
        if (![a[i] isKindOfClass: [NSNumber class]]) {
            free(b);
            
            return NULL;
            
        }else{
            b[i] = ((NSNumber *) a[i]).doubleValue;
        }
    }
    
    return b;
}

NSArray * NSArrayFromDoubleArray(double * a, NSUInteger length) {
    NSMutableArray *b = [NSMutableArray arrayWithCapacity: length];
    
    for (int i = 0; i < length; i++) {
        [b addObject: @(a[i])];
    }
    
    return b.copy;
}

@implementation NeuralNet{
    NSUInteger numberLayers;
    NSUInteger * layerWidths;
    double * weights;
}

+ (NeuralNet *)neuralNetWithLayerWidths: (NSArray *)layerWidths {
    return [[NeuralNet alloc] initWithLayerWidths: layerWidths];
}

- (instancetype)initWithLayerWidths: (NSArray *)widths {
    if (!widths || widths.count < 2) {
        @throw NSInvalidArgumentException;
    }
    
    self = [super init];
    
    if (self) {
        numberLayers = widths.count;
        layerWidths = unsignedIntegerArrayFromNSArray(widths);
        
        if (layerWidths == NULL) {
            @throw NSInvalidArgumentException;
        }
        
        //Determining data size:
        size_t contentSize = 0;
        
        for (int i = 0; i < numberLayers; i++) {
            NSUInteger layerWidth = layerWidths[i];
            NSUInteger numberInputs;
            NSUInteger numberWeights;
            
            if (i == 0) {
                numberInputs = 1;
            }else{
                numberInputs = layerWidths[i - 1];
            }
            
            numberWeights = numberInputs + 1;
            
            if (layerWidth == 0) {
                @throw NSInvalidArgumentException;
            }
            
            contentSize += layerWidth * numberWeights * sizeof(double);
        }
        
        weights = malloc(contentSize);
        
        NSUInteger weightIndex = 0;
        
        for (int i = 0; i < numberLayers; i++) {
            NSUInteger layerWidth = layerWidths[i];
            NSUInteger numberInputs;
            
            if (i == 0) {
                numberInputs = 1;
            }else{
                numberInputs = layerWidths[i - 1];
            }
            
            for (int j = 0; j < layerWidth; j++) {
                weights[weightIndex] = numberInputs * ((double)rand() / (double)RAND_MAX);
                weightIndex++;
                
                for (int k = 0; k < numberInputs; k++) {
                    weights[weightIndex] = (double)rand() / (double)RAND_MAX;
                    weightIndex++;
                }
            }
        }
    }
    
    return self;
}

- (NSUInteger)totalNumberOfOutputs{
    NSUInteger numberOutputs = 0;
    
    for (int i = 0; i < numberLayers; i++) {
        numberOutputs += layerWidths[i];
    }
    
    return numberOutputs;
}

- (NSUInteger)numberOfInputsOfLayerAtIndex: (NSUInteger)layerIndex {
    if (layerIndex == 0) {
        return layerWidths[0];
    }else{
        return layerWidths[layerIndex - 1];
    }
}

- (NSUInteger)totalNumberOfInputs{
    NSUInteger numberInputs = 0;
    
    for (int i = 0; i < numberLayers; i++) {
        numberInputs += [self numberOfInputsOfLayerAtIndex: i];
    }
    
    return numberInputs;
}

- (NSUInteger)numberOfWeightsOfNeuronsInLayerAtIndex: (NSUInteger)layerIndex {
    if (layerIndex == 0) {
        return 2;
    }else{
        return 1 + layerWidths[layerIndex - 1];
    }
}

- (NSUInteger)numberOfWeightsInLayerAtIndex: (NSUInteger) layerIndex {
    return layerWidths[layerIndex] * [self numberOfWeightsOfNeuronsInLayerAtIndex: layerIndex];
}

- (NSUInteger)totalNumberOfWeights{
    NSUInteger numberWeights = 0;
    
    for (int i = 0; i < numberLayers; i++) {
        numberWeights += [self numberOfWeightsInLayerAtIndex: i];
    }
    
    return numberWeights;
}

- (NSUInteger)indexOfFirstWeightInLayerAtIndex: (NSUInteger) layerIndex {
    NSUInteger index = 0;
    
    for (int i = 0; i < layerIndex; i++) {
        index += [self numberOfWeightsInLayerAtIndex: i];
    }
    
    return index;
}

- (NSUInteger)indexOfFirstWeightOfNeuronAtIndex: (NSUInteger)neuronIndex
                                 inLayerAtIndex: (NSUInteger)layerIndex {
    NSUInteger index = 0;
    
    for (int i = 0; i < layerIndex; i++) {
        index += [self numberOfWeightsInLayerAtIndex: i];
    }
    
    index += neuronIndex * [self numberOfWeightsOfNeuronsInLayerAtIndex: layerIndex];
    
    return index;
}

- (void)calculateOutput: (double *)output
         ofLayerAtIndex: (NSUInteger) layerIndex
               forInput: (double *)input {
    NSUInteger layerWidth = layerWidths[layerIndex];
    NSUInteger numberWeights = [self numberOfWeightsOfNeuronsInLayerAtIndex: layerIndex];
    NSUInteger firstWeightIndex = [self indexOfFirstWeightInLayerAtIndex: layerIndex];
    
    for (int i = 0; i < layerWidth; i++) {
        double alpha = 0.0;
        
        for (int j = 0; j < numberWeights; j++) {
            double inputValue, weight;
            
            if (j == 0) {
                inputValue = -1.0;
            }else{
                inputValue = input[j - 1];
            }
            
            weight = weights[firstWeightIndex + i * numberWeights + j];
            
            alpha += inputValue * weight;
        }
        
        double beta = sigmoid(alpha);
        
        output[i] = beta;
    }
}

- (NSArray *)calculateOutputForInput: (NSArray *)inputArray {
    size_t inputSize = layerWidths[0] * sizeof(double);
    double * input = doubleArrayFromNSArray(inputArray);
    
    for (int i = 0; i < numberLayers; i++) {
        NSUInteger layerWidth = layerWidths[i];
        
        size_t outputSize = layerWidth * sizeof(double);
        double *output = malloc(outputSize);
        
        [self calculateOutput: output
               ofLayerAtIndex: i
                     forInput: input];
        
        free(input);
        
        inputSize = outputSize;
        input = malloc(inputSize);
        
        memcpy(input, output, inputSize);
        
        free(output);
    }
    
    NSArray *outputArray = NSArrayFromDoubleArray(input, inputSize / sizeof(double));
    
    free(input);
    
    return outputArray;
}

+ (double)calculatePerformanceOfOutput: (NSArray *)output
               comparedToDesiredOutput: (NSArray *)desiredOutput {
    double p = 0.0;
    
    for (int i = 0; i < output.count; i++) {
        double z = ((NSNumber *) output[i]).doubleValue;
        double d = ((NSNumber *) desiredOutput[i]).doubleValue;
        
        p += -0.5 * pow(d - z, 2);
    }
    
    return p;
}

- (void)improveWithInput: (NSArray *)inputArray
           desiredOutput: (NSArray *)desiredOutputArray
             andStepSize: (double)stepSize {
    //Run through and data gathering:
    NSUInteger numberInputs = [self totalNumberOfInputs];
    double * inputs = malloc(numberInputs * sizeof(double));
    NSUInteger inputIndex = 0;
    
    NSUInteger numberOutputs = [self totalNumberOfOutputs];
    double * outputs = malloc(numberOutputs * sizeof(double));
    NSUInteger outputIndex = 0;
    
    double * desiredOutput = doubleArrayFromNSArray(desiredOutputArray);
    
    size_t inputSize = layerWidths[0] * sizeof(double);
    double * input = malloc(inputSize);
    
    input = doubleArrayFromNSArray(inputArray);
    
    for (int i = 0; i < numberLayers; i++) {
        NSUInteger a = [self numberOfInputsOfLayerAtIndex: i];
        for (int j = 0; j < a; j++) {
            inputs[inputIndex + j] = input[j];
        }
        inputIndex += a;
        
        NSUInteger layerWidth = layerWidths[i];
        
        size_t outputSize = layerWidth * sizeof(double);
        double *output = malloc(outputSize);
        
        [self calculateOutput: output
               ofLayerAtIndex: i
                     forInput: input];
        
        
        free(input);
        
        for (int j = 0; j < layerWidth; j++) {
            outputs[outputIndex + j] = output[j];
        }
        outputIndex += layerWidth;
        
        inputSize = outputSize;
        input = malloc(inputSize);
        
        memcpy(input, output, inputSize);
        
        free(output);
    }
    
    free(input);
    
    //Computing general derivates:
    NSUInteger numberFinalOutputs = layerWidths[numberLayers - 1];
    
    double dP_dFinalOutput = 0.0;
    double dP_dFinalOutputs[numberFinalOutputs];
    
    for (int i = 0; i < numberFinalOutputs; i++) {
        double d = desiredOutput[i];
        double z = outputs[numberOutputs - numberFinalOutputs + i];
        
        double dP_dz = z * (d - z);
        
        dP_dFinalOutput += dP_dz;
        dP_dFinalOutputs[i] = dP_dz;
    }
    
    double dBeta_dAlphas[numberOutputs];
    
    for (int i = 0; i < numberOutputs; i++) {
        double beta = outputs[i];
        
        dBeta_dAlphas[i] = beta * (1.0 - beta);
    }
    
    double dLayer_dPreviousLayers[numberLayers - 2];
    
    outputIndex = 0;
    for (int i = 0; i < numberLayers; i++) {
        NSUInteger a = [self numberOfInputsOfLayerAtIndex: i];
        NSUInteger b = layerWidths[i];
        
        if (i < 2) {
            outputIndex += b;
            
            continue;
        }
        
        NSUInteger firstWeightIndex = [self indexOfFirstWeightInLayerAtIndex: i];
        
        double dOutputs_dInputs = 0.0;
        
        for (int j = 0; j < b; j++) {
            double dBeta_dAlpha = dBeta_dAlphas[outputIndex];
            
            double dAlpha_dInputs = 0.0;
            
            for (int k = 0; k < a; k++) {
                double weight = weights[firstWeightIndex + j * (1 + a) + 1 + k];
                
                dAlpha_dInputs += weight;
            }
            
            dOutputs_dInputs += dBeta_dAlpha * dAlpha_dInputs;
        }
        
        dLayer_dPreviousLayers[i - 2] = dOutputs_dInputs;
        
        outputIndex += b;
    }
    
    inputIndex = 0;
    outputIndex = 0;
    for (int i = 0; i < numberLayers - 1; i++) {
        NSUInteger a = [self numberOfWeightsOfNeuronsInLayerAtIndex: i];
        NSUInteger b = layerWidths[i];
        NSUInteger c = layerWidths[i + 1];
        
        double dP_dNextLayer = dP_dFinalOutput;
        for (int j = i + 2; j < numberLayers; j++) {
            dP_dNextLayer *= dLayer_dPreviousLayers[j - 2];
        }
        
        NSUInteger firstWeightIndex = [self indexOfFirstWeightInLayerAtIndex: i];
        
        for (int j = 0; j < b; j++) {
            double dBeta_dAlpha = dBeta_dAlphas[outputIndex + j];
            
            for (int k = 0; k < a; k++) {
                double weight = weights[firstWeightIndex + j * a + k];
                double dAlpha_dw;
                
                if (k == 0) {
                    dAlpha_dw = -1.0;
                }else{
                    dAlpha_dw = inputs[inputIndex + k - 1];
                }
                
                double dNextLayer_dBeta = 0.0;
                
                for (int l = 0; l < c; l++) {
                    double dA_dIn = weights[firstWeightIndex + b * a + 1 + j];
                    double dB_dA = dBeta_dAlphas[outputIndex + b + l];
                    
                    dNextLayer_dBeta += dB_dA * dA_dIn;
                }
                
                double dP_dw = dP_dNextLayer * dNextLayer_dBeta * dBeta_dAlpha * dAlpha_dw;
                
                double newWeight = weight + dP_dw * stepSize;
                
                weights[firstWeightIndex + j * a + k] = newWeight;
            }
            
        }
        
        inputIndex += a - 1;
        outputIndex += b;
    }
    
    NSUInteger a = [self numberOfWeightsOfNeuronsInLayerAtIndex: numberLayers - 1];
    NSUInteger firstWeightIndex = [self indexOfFirstWeightInLayerAtIndex: numberLayers - 1];
    
    for (int i = 0; i < numberFinalOutputs; i++) {
        double dBeta_dAlpha = dBeta_dAlphas[outputIndex + i];
        
        double dP_dBeta = dP_dFinalOutputs[i];
        
        for (int j = 0; j < a; j++) {
            double weight = weights[firstWeightIndex + i * a + j];
            double dAlpha_dw;
            
            if (j == 0) {
                dAlpha_dw = -1.0;
            }else{
                dAlpha_dw = inputs[inputIndex + j - 1];
            }
            
            double dP_dw = dP_dBeta * dBeta_dAlpha * dAlpha_dw;
            
            double newWeight = weight + dP_dw * stepSize;
            
            weights[firstWeightIndex + i * a + j] = newWeight;
        }
    }
    
    free(inputs);
    free(outputs);
}

@end
