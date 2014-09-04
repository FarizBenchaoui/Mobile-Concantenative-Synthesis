//
//  CSFBSynthViewController.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 21/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#include "CSFBCoreDataInterface.h"

@interface CSFBSynthViewController : UIViewController
@property (strong,nonatomic) NSMutableArray *trackNames;
- (IBAction)mpcPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
@property (weak, nonatomic) IBOutlet UIButton *buttonSix;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeven;
@property (weak, nonatomic) IBOutlet UIButton *buttonEight;
@property (strong,nonatomic) NSURL *outputFileURL;




@end
