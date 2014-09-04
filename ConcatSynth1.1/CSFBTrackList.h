//
//  CSFBTrackList.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 03/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSFBTrackList : NSObject

@property (strong,nonatomic) NSMutableArray* trackArray;
@property (strong, nonatomic) NSMutableArray* trackAddressArray;
@property (strong, nonatomic) NSMutableArray* fftResultArray;


-(id)init;
-(id)init: (CSFBTrackList *)trackList;
-(void) setTrackNameArray:(NSMutableArray *)trackArray;
-(NSMutableArray *) getTrackNameArray;
-(void)settrackAddressArray:(NSMutableArray *)trackAddressArray;
-(NSMutableArray *)getTrackAddressArray;
-(void)setfftResultArray:(NSMutableArray *)fftResultArray;
-(NSMutableArray *)getfftResultArray;

@end
