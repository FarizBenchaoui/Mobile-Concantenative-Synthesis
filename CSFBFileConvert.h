//
//  CSFBFileConvert++.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 29/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <Accelerate/Accelerate.h>

#include <AudioToolbox/AudioToolbox.h>


@interface CSFBFileConvert: NSObject

-(id)init;
-(void) convertAndProcess:(CFURLRef) myFile trackName:(NSString *)trackName;
@end
