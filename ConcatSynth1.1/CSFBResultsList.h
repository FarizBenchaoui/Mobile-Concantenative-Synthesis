//
//  CSFBResultsList.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 08/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSFBResultsList : NSObject

@property (strong,nonatomic) NSMutableArray* trackArray;
@property (strong, nonatomic) NSMutableArray* fftResultArray;


-(id)init;
-(id)init: (CSFBResultsList *)resultsList;
-(void) setTrackNameArray:(NSMutableArray *)trackArray;
-(NSMutableArray *) getTrackNameArray;
-(void)setfftResultArray:(NSMutableArray *)fftResultArray;
-(NSMutableArray *)getfftResultArray;

@end
