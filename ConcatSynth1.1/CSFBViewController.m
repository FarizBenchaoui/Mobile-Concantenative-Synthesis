//
//  CSFBViewController.m
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 20/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import "CSFBViewController.h"





NSString *newInputName;
NSArray *pathComponents;
NSMutableDictionary *recordSetting;
CFURLRef sendRef;
NSFileManager *fileManager;
AVAudioSession *session;
CSFBCoreDataInterface *coreDataInterface;


@interface CSFBViewController ()

@end

@implementation CSFBViewController

- (void)playUpdateProgress
{
    
    
    float playTimeLeft = self.player.currentTime/self.player.duration;
    self.recordPlayProgress.progress= playTimeLeft;
    if (self.player.currentTime == 0.00) {
        [session setActive:NO error:nil];
        [self.recordTimer invalidate];
        self.recordTimer = nil;
        [self activate];
        sendRef = (__bridge CFURLRef)(_outputFileURL);
        
        CSFBFileConvert* myTrackProcess = [[CSFBFileConvert alloc]init];
        
        [myTrackProcess
         convertAndProcess:sendRef
         trackName:self.pickerObject];
    }
    
    
}

- (void)recordUpdateProgress
{
    
    self.recordPlayProgress.progress= self.recorder.currentTime/5;
    
    if (self.recorder.currentTime == 0.00) {
        [session setActive:NO error:nil];
        [self activate];
        [self.recordTimer invalidate];
        self.recordTimer = nil;
        
        sendRef = (__bridge CFURLRef)(_outputFileURL);
        
        CSFBFileConvert* myTrackProcess = [[CSFBFileConvert alloc]init];
        
        [myTrackProcess
         convertAndProcess:sendRef
         trackName:self.pickerObject];
        
        
    }
    
    
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    //init coredatainterface Object
    coreDataInterface = [[CSFBCoreDataInterface alloc]init];
    
    //hide progress bar
    [self.recordPlayProgress setHidden:YES];
    
    //set the progress bar value to zero
    self.recordPlayProgress.progress= 0;
    
    // init tracklist object containing track details
    CSFBTrackList *trackList=[[CSFBTrackList alloc] init:[coreDataInterface fetchTrackDetails]];
    if ([trackList getTrackNameArray].count > 0) {
        
        //set pickerarray to tracknameArray
        self.pickerArray  = [[NSMutableArray alloc]initWithArray:[trackList getTrackNameArray]];
        self.trackAddressArray =[[NSMutableArray alloc]initWithArray:[trackList getTrackAddressArray]];
        //set the leading pickerobject to first object in array
        self.pickerObject = [self.pickerArray objectAtIndex:0];
        
    }else{
        //if returned values from core data are emtpy, init the array empty
        self.pickerArray = [[NSMutableArray alloc]init];
        self.trackAddressArray =[[NSMutableArray alloc]init];
        self.pickerObject= nil;
        [self.recordButton setEnabled:NO];
        [self.playButton setEnabled:NO];
        [self.deleteTrack setEnabled:NO];
        
    }
        
    // [self updatePath:self.pickerObject];
    pathComponents = [NSArray arrayWithObjects:
                      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                      self.pickerObject,
                      nil];
    _outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber
                             numberWithInt:kAudioFormatAppleIMA4]
                     forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber
                             numberWithFloat:44100.0]
                     forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber
                             numberWithInt: 2]
                     forKey:AVNumberOfChannelsKey];
    
    // Initiate  the audio player
    
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:_outputFileURL  error:nil];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    fileManager = [NSFileManager defaultManager];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//disable rotation
- (BOOL)shouldAutorotate
{
    return NO;
}
//make sure it doesn't rotate upside down
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
    //if I wanted to orientate upside down as well uncomment this
    //+ UIInterfaceOrientationMaskPortraitUpsideDown;
}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    self.pickerObject = [self.pickerArray objectAtIndex:row];
    
    pathComponents = [NSArray arrayWithObjects:
                      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                      self.pickerObject,
                      nil];
    _outputFileURL = [NSURL fileURLWithPathComponents:pathComponents ];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:_outputFileURL settings:recordSetting error:nil];
    
}
- (IBAction)record:(id)sender {
    [self updatePath:self.pickerObject];
    if(self.pickerObject!=nil){
        if (self.player.playing) {
            [self.player stop];
        }
        
        if (!self.recorder.recording) {
            [self deActivate];
            self.recorder = [[AVAudioRecorder alloc]
                             initWithURL:_outputFileURL
                             settings:recordSetting
                             error:nil];
            self.recorder.delegate = self;
            [self.recorder prepareToRecord];
            
            [session setActive:YES error:nil];
            [self.recorder recordForDuration:(NSTimeInterval)5];
            if ([self.recorder recordForDuration:(NSTimeInterval)5]) {
           
            self.recordTimer = [NSTimer
                                scheduledTimerWithTimeInterval:0.30
                                target:self
                                selector:@selector(recordUpdateProgress)
                                userInfo:nil
                                repeats:YES];
            
            [self.recordPlayProgress setHidden:NO];
            }
            else
            {
                [self alert:@"recording cannot be performend"];
            }
            
        }
        
    }else{
        [self alert:@"no track selected to record to"];
    }
}

- (IBAction)play:(id)sender {
    
    if (!self.recorder.recording){
        [self updatePath:self.pickerObject];
        [session setActive:YES error:nil];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_outputFileURL error:nil];
        
        if ([fileManager fileExistsAtPath:_outputFileURL.path]) {
           
            [self deActivate];
            
            [self.player setDelegate:self];
            
            [self.player play];
            
            
            self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.30
                                                                target:self
                                                              selector:@selector(playUpdateProgress)
                                                              userInfo:nil
                                                               repeats:YES];
            [self.recordPlayProgress setHidden:NO];
        }else{
            [self alert:@"no recording exists for track"];
        
        }
        
    }
    
}



- (IBAction)deleter:(id)sender {
    
    
    
    if ([self.pickerArray count]!=0) {
        NSString * deleteFile = self.pickerObject;
        //delete object from  array
       
        [self.pickerArray removeObject:deleteFile];
    
        //delete file
        
        [self updatePath:self.pickerObject];
        
        if ([fileManager fileExistsAtPath:_outputFileURL.path])
            
        {
           
            [self deleteFile:_outputFileURL.path];
        }
        
        //delete from picker
        [coreDataInterface deleteTrack:self.pickerObject];
        if ([self.pickerArray count]!=0) {
            self.pickerObject = [self.pickerArray objectAtIndex:0];
            
        }else{
            [self.recordButton setEnabled:NO];
            [self.playButton setEnabled:NO];
            [self.deleteTrack setEnabled:NO];
        }
        [self.picker reloadAllComponents];
    }
    
}

- (IBAction)saveNew:(id)sender {
    
    [self.textInput resignFirstResponder];
    [self activate];
    
    if ([self.textInput.text length] != 0) {
        
        if (![self.pickerArray containsObject:[self.textInput text]]) {
            
            newInputName = [self.textInput text];
            [self.pickerArray addObject:newInputName];
            [self.picker reloadAllComponents];
            [self.picker selectRow:self.pickerArray.count-1 inComponent:0 animated:YES];
            self.pickerObject = [self.pickerArray lastObject];
            [self updatePath:self.pickerObject];
            [self.trackAddressArray insertObject:_outputFileURL.path atIndex: self.pickerArray.count-1];
            
            //add items to database using coreData, change this so that you're sending one item instead of area
            [coreDataInterface addTrackName:newInputName addTrackAddress:_outputFileURL.path];
            
            
        }else{
            [self alert:@"no duplicates are allowed, write something different please!"];
    
        }
    }
}



-(void) deleteFile:(NSString *)deleteFileURL
{
   NSError *error;
    
    BOOL success = [fileManager removeItemAtPath:deleteFileURL error:&error];
    if (!success){[self alert:[error localizedDescription]] ;}
 
}
-(void)updatePath:(NSString *)newFileName
{
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@",newFileName,@".caf"];
    pathComponents = [NSArray arrayWithObjects:
                      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                      fileName,
                      nil];
    _outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
}
-(void)dismissKeyboard {
    [self.textInput resignFirstResponder];
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
-(void) activate
{
    [self.recordButton setEnabled:YES];
    [self.playButton setEnabled:YES];
    [self.deleteTrack setEnabled:YES];
    [self.saveButton setEnabled:YES];
    [self.recordPlayProgress setHidden:YES];
    self.textInput.enabled = YES;
}
-(void) deActivate
{
    [self.recordButton setEnabled:NO];
    [self.playButton setEnabled:NO];
    [self.deleteTrack setEnabled:NO];
    [self.saveButton setEnabled:NO];
    [self.recordPlayProgress setHidden:NO];
    self.textInput.enabled = NO;
    
}
@end
