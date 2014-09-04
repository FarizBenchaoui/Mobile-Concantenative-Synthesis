//
//  CSFBCoreDataInterface.m
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 02/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import "CSFBCoreDataInterface.h"


@implementation CSFBCoreDataInterface
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSString* errorMessage = [NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]];
            [self alert:errorMessage];
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
   NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"dataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"concatSynth1.1.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
     
        NSString* errorMessage = [NSString stringWithFormat:@"Unresolved error %@, %@",  error, [error userInfo]];
        [self alert:errorMessage];
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void) addTrackName :(NSString *)trackName addTrackAddress: (NSString *) trackPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *entity = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"TrackList"
                                       inManagedObjectContext:context];
   
        [entity setValue:trackName forKey:@"trackName"];

        [entity setValue:trackPath forKey:@"trackPath"];
    
    NSError * error;
        if (![context save:&error]) {
            NSString* errorMessage = [NSString stringWithFormat:@"there was an errror: %@",[error localizedDescription]];
            [self alert:errorMessage];
         }
  
}
-(CSFBTrackList *) fetchTrackDetails
{
    CSFBTrackList* trackList = [[CSFBTrackList alloc]init];
    NSMutableArray* trackNameArray = [[NSMutableArray alloc]init];
    NSMutableArray* trackPathArray = [[NSMutableArray alloc]init];
    
    int i = 0;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError * error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TrackList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects) {
    
        trackNameArray[i] =[info valueForKey:@"trackName"];
        trackPathArray[i] =[info valueForKey:@"trackPath"];
    
        i+=1;
    }
    [trackList setTrackNameArray:trackNameArray];
    [trackList settrackAddressArray:trackPathArray];
    
    return trackList;
}

-(void) deleteTrack:(NSString *)trackName
{

    NSManagedObjectContext *context = [self managedObjectContext];
    NSError * error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TrackList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects) {
        
        if ([[info valueForKey:@"trackName" ] isEqualToString:trackName]) {
            
            [context deleteObject:info];
            [context save:&error];
            break;
        }
    }
}
-(void) saveFFTResults:(NSMutableArray *)fftResults trackName:(NSString *)TrackName
{

    NSString *trackName = [TrackName
                                     stringByReplacingOccurrencesOfString:@".caf" withString:@""];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError * error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"TrackList" inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trackName == %@", trackName];
    [request setPredicate:predicate];
    NSArray *results = [context executeFetchRequest:request error:&error];
    NSManagedObject* objectGrabbed = [results objectAtIndex:0];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:fftResults];
    [objectGrabbed setValue:arrayData  forKey:@"fftResult"];
    [context save:&error];
    
}

-(CSFBTrackList *) fetchResults
{
    CSFBTrackList* resultList = [[CSFBTrackList alloc]init];
    NSMutableArray* trackNameArray = [[NSMutableArray alloc]init];
    NSMutableArray* fftResultsArray = [[NSMutableArray alloc]init];
    int i = 0;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError * error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TrackList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects) {
        NSData *arrayData =[info  valueForKey:@"fftResult"];
        if (arrayData != NULL) {
        trackNameArray[i] =[info valueForKey:@"trackName"];
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
        fftResultsArray[i] = array;
            i+=1;
        }
        
    }
    
    [resultList setTrackNameArray:trackNameArray];
    [resultList setfftResultArray:fftResultsArray];
    return resultList;
}

-(void) saveTopEight:(NSString *)trackName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *fftEntity = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"TopEight"
                                  inManagedObjectContext:context];
    NSError * error;
    [fftEntity setValue:trackName forKey:@"trackName"];
    [context save:&error];
    
}
-(NSMutableArray *) fetchTopEight
{
    NSMutableArray* topEight = [[NSMutableArray alloc]init];
    int i = 0;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError * error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TopEight" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects) {
        topEight[i] =[info valueForKey:@"trackName"];
        i+=1;
    }
       return  topEight;
}
-(void) deleteTopEight
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError * error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TopEight" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects) {
        [context  deleteObject:info];
      
    }
    [context save:&error];
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
