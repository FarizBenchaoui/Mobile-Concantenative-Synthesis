//
//  CSFBNode.m
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 08/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import "CSFBNode.h"

@implementation CSFBNode

-(id)init:(NSString *)trackName array:(NSMutableArray *)fftArray
{
    self = [self init];
    _trackName = trackName;
    _fftArray = [[NSMutableArray alloc]initWithArray:fftArray];
    _next = NULL;
    _previous = NULL;
    return self;

}

-(void) setDistance:(float)distance
{
    _distance = distance;
}
-(Boolean)equals:(CSFBNode *)node
{
    return (_distance== node.distance);
}
-(Boolean)lessThan:(CSFBNode *)node
{
    return (_distance < node.distance);
}
-(Boolean)greaterThan:(CSFBNode *)node
{
    return (_distance > node.distance);
}
-(float)getDistance
{
    return _distance;
}
@end
