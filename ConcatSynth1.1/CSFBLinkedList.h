//
//  CSFBLinkedList.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 08/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSFBNode.h"
#import "CSFBCoreDataInterface.h"
@interface CSFBLinkedList : NSObject

@property (strong,nonatomic)CSFBNode *head;
@property (strong,nonatomic)CSFBNode *tail;
@property (strong,nonatomic)NSMutableArray *comparisonArray;

-(id)init:(NSString *)trackName array:(NSMutableArray *)fftArray;
-(void)insertNewNode:(NSString *)trackName array:(NSMutableArray *)array;
-(void)saveTopEight;
@end
