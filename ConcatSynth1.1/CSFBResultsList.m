//
//  CSFBResultsList.m
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 08/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import "CSFBResultsList.h"

@implementation CSFBResultsList

@synthesize trackArray = _trackArray;
@synthesize fftResultArray = _fftResultArray;
-(id)init
{
    self = [super init];
    NSLog(@"initialisation of trackList successful");
    return self;
}
-(id)init: (CSFBResultsList *)resultsList
{
    self = [resultsList init];
    return self;
}

-(void) setTrackNameArray:(NSMutableArray *)trackArray
{
    NSLog(@"in setTrackNameArray");
    
    _trackArray = [[NSMutableArray alloc]initWithArray:trackArray];
    
}
-(NSMutableArray *) getTrackNameArray
{
    NSLog(@"in getTrackNameArray");
    return _trackArray;
}
-(void)setfftResultArray:(NSMutableArray *)fftResultArray
{
    NSLog(@"in setTrackAddressArray");
    
    NSLog(@"size %lu",(long)[fftResultArray count]);
    _fftResultArray = [[NSMutableArray alloc]initWithArray:fftResultArray];
}
-(NSMutableArray *)getfftResultArray
{
    NSLog(@"in fftResultArray");
    return _fftResultArray;
}
@end
