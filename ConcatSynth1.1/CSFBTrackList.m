//
//  CSFBTrackList.m
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 03/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import "CSFBTrackList.h"

@implementation CSFBTrackList

@synthesize trackArray = _trackArray;
@synthesize trackAddressArray = _trackAddressArray;

-(id)init
{
    self = [super init];
    return self;
}
-(id)init: (CSFBTrackList *)trackList
{
    self = [trackList init];
    return self;
}

-(void) setTrackNameArray:(NSMutableArray *)trackArray
{
   
    _trackArray = [[NSMutableArray alloc]initWithArray:trackArray];
    
}
-(NSMutableArray *) getTrackNameArray
{
    return _trackArray;
}
-(void)settrackAddressArray:(NSMutableArray *)trackAddressArray
{
    
   _trackAddressArray = [[NSMutableArray alloc]initWithArray:trackAddressArray];
}
-(NSMutableArray *)getTrackAddressArray
{
    return _trackAddressArray;
}
-(void)setfftResultArray:(NSMutableArray *)fftResultArray
{

    _fftResultArray = [[NSMutableArray alloc]initWithArray:fftResultArray];
}
-(NSMutableArray *)getfftResultArray
{
    return _fftResultArray;
}

@end
