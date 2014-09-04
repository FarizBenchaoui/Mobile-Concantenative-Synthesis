//
//  CSFBCoreDataInterface.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 02/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreData/CoreData.h>
#import "CSFBTrackList.h"


@interface CSFBCoreDataInterface : NSObject
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
-(void) addTrackName :(NSString *)trackName addTrackAddress: (NSString *) trackPath;
-(CSFBTrackList *) fetchTrackDetails;
-(void) deleteTrack:(NSString *)trackName;
-(void) saveFFTResults:(NSMutableArray *)fftResults trackName:(NSString *)trackName;
-(CSFBTrackList *) fetchResults;
-(void) saveTopEight:(NSString *)trackName;
-(NSMutableArray *) fetchTopEight;
-(void) deleteTopEight;
@end
