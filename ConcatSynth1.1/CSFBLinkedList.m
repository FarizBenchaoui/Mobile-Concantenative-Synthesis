//
//  CSFBLinkedList.m
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 08/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import "CSFBLinkedList.h"

@implementation CSFBLinkedList
-(id)init:(NSString *)trackName array:(NSMutableArray *)fftArray
{
    self = [self init];
  
     _tail=_head =[[CSFBNode alloc]init:trackName array:fftArray];
    self.comparisonArray = [[NSMutableArray alloc]initWithArray:fftArray];

     [_head setDistance:0];
    return self;
}
-(void)insertNewNode:(NSString *)trackName array:(NSMutableArray *)array
{
  
    CSFBNode *newNode = [[CSFBNode alloc]init:trackName array:array];
    newNode.distance = [self calculateDistance:newNode];
    [self compareNewNode:newNode rootNode:_head];
   
    
}
-(void)compareNewNode:(CSFBNode *)newNode rootNode:(CSFBNode *)root{
 
    if ([newNode equals:root]) {
     
        if ([root.trackName isEqual:_tail.trackName]) {
            root.next = newNode;
            _tail = newNode;
            newNode.previous = root;
        }else{
            CSFBNode *oldNode = root.next;
            root.next = newNode;
            newNode.previous = root;
            newNode.next = oldNode;
            oldNode.previous = newNode;
        }

    }else if([newNode lessThan:root]){
  
        if ([root.trackName isEqual:_head.trackName]) {
            root.previous = newNode;
            _head = newNode;
            newNode.next = root;
        }else{
            CSFBNode *oldNode = root.previous;
            root.previous = newNode;
            newNode.next = root;
            newNode.previous = oldNode;
            oldNode.next = newNode;
        }
        
    }else if([newNode greaterThan:root]){
        if (root.next != NULL) {
        [self compareNewNode:newNode rootNode:root.next];
        }else{
            root.next = newNode;
            newNode.previous = root;
        }
    }else{
        [self alert:@"error occured in inserting a new object to linkedlist"];
    }
}
-(float)calculateDistance:(CSFBNode *)newNode
{
   float distance;
   float loopOperation = 0.0;
  
    for (int i = 0; i<[_comparisonArray count]-1; i++) {
        float a = [_comparisonArray[i] floatValue];
        float b = [newNode.fftArray[i] floatValue];
        float c=powf((b-a), 2);
        loopOperation = loopOperation + c;
    }
    distance = sqrt(loopOperation);
    return distance;
}
-(void)saveTopEight
{
    CSFBCoreDataInterface *coreDataInterface = [[CSFBCoreDataInterface alloc]init];
    [coreDataInterface deleteTopEight];
    NSMutableArray *topEight = [NSMutableArray arrayWithCapacity:8];
    CSFBNode *populateNode = _head;
    int i = 0;
    while (populateNode!= NULL) {
        topEight[i]= populateNode.trackName;
        [coreDataInterface saveTopEight:topEight[i]];
        populateNode = populateNode.next;
        i++;
    }
}
-(void) alert:(NSString *) error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"warning"
                          message:error
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
}
@end
