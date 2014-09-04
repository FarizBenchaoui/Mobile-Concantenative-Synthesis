//
//  CSFBFFTProcessing.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 29/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <Accelerate/Accelerate.h>
#include "CSFBCoreDataInterface.h"

@interface CSFBFFTProcessing : NSObject

@property (strong, nonatomic) NSMutableArray* fftResultsArray;
-(id)init;
-(void) runFFT:(NSMutableArray *)sample trackName:(NSString *)trackName;

@end
