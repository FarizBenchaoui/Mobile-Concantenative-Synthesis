//
//  CSFBViewController.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 20/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#include <Accelerate/Accelerate.h>
#include "CSFBTrackList.h"
#include "CSFBFileConvert.h"
#include "CSFBCoreDataInterface.h"



@interface CSFBViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong,nonatomic) NSMutableArray* pickerArray;
@property (strong, nonatomic) NSMutableArray* trackAddressArray;
@property (weak, nonatomic) NSString* pickerObject;
@property (strong,nonatomic) NSURL *outputFileURL;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteTrack;
@property (weak, nonatomic) IBOutlet UIProgressView *recordPlayProgress;

@property (weak, nonatomic) IBOutlet UITextField *textInput;




@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSTimer *recordTimer;

- (IBAction)deleter:(id)sender;

- (IBAction)saveNew:(id)sender;

@end
