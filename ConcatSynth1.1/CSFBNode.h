//
//  CSFBNode.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 08/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSFBNode : NSObject
@property (strong,nonatomic)CSFBNode *previous;
@property (strong,nonatomic)CSFBNode *next;
@property (strong,nonatomic)NSString *trackName;
@property (strong,nonatomic)NSMutableArray *fftArray;
@property (nonatomic,readwrite)float distance;

-(id)init:(NSString *)trackName array:(NSMutableArray *)fftArray;
-(void) setDistance:(float)distance;
-(Boolean)equals:(CSFBNode *)node;
-(Boolean)lessThan:(CSFBNode *)node;
-(Boolean)greaterThan:(CSFBNode *)node;
-(float)getDistance;

@end
