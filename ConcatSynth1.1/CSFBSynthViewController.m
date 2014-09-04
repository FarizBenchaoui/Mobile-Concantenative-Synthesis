//
//  CSFBSynthViewController.m
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 21/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import "CSFBSynthViewController.h"

@implementation CSFBSynthViewController
NSArray *pathComponents;
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.buttonOne.tag = 1;
    [self.buttonOne setEnabled:YES];
    self.buttonTwo.tag = 2;
    [self.buttonTwo setEnabled:YES];
    self.buttonThree.tag = 3;
    [self.buttonThree setEnabled:YES];
    self.buttonFour.tag = 4;
    [self.buttonFour setEnabled:YES];
    self.buttonFive.tag = 5;
    [self.buttonFive setEnabled:YES];
    self.buttonSix.tag = 6;
    [self.buttonSix setEnabled:YES];
    self.buttonSeven.tag = 7;
    [self.buttonSeven setEnabled:YES];
    self.buttonEight.tag = 8;
    [self.buttonEight setEnabled:YES];
    CSFBCoreDataInterface *coreDataInterface = [[CSFBCoreDataInterface alloc]init];
    self.trackNames = [[NSMutableArray alloc]initWithArray:[coreDataInterface fetchTopEight]];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}


- (IBAction)mpcPressed:(id)sender {
 
    int tag = ((UIView *)sender).tag;

    switch (tag) {
        case 1:
            if (!([self.trackNames count] < 1)) {
                [self updatePath:self.trackNames[0]];
                [self play];

            }else{
                [self.buttonOne setEnabled:NO];
                [self.buttonOne setTitle:@"empty" forState:UIControlStateDisabled];
            }
            
            break;
        case 2:
            if (!([self.trackNames count] < 2)) {
                [self updatePath:self.trackNames[1]];
                [self play];

                
            }else{
                [self.buttonTwo setEnabled:NO];
                [self.buttonTwo setTitle:@"empty" forState:UIControlStateDisabled];
            }
            break;
        case 3:
            if (!([self.trackNames count] < 3)) {
                [self updatePath:self.trackNames[2]];
                [self play];

              
            }else{
                [self.buttonThree setEnabled:NO];
                [self.buttonThree setTitle:@"empty" forState:UIControlStateDisabled];
            }
            break;
        case 4:
            if (!([self.trackNames count] < 4)) {
                [self updatePath:self.trackNames[3]];
                [self play];

              
            }else{
                [self.buttonFour setEnabled:NO];
                [self.buttonFour setTitle:@"empty" forState:UIControlStateDisabled];
            }
            break;
        case 5:
           
            if (!([self.trackNames count] < 5)) {
                [self updatePath:self.trackNames[4]];
                [self play];

           
            }else{
                [self.buttonFive setEnabled:NO];
                [self.buttonFive setTitle:@"empty" forState:UIControlStateDisabled];
            }
            
            break;
        case 6:
          
            if (!([self.trackNames count] < 6)) {
                [self updatePath:self.trackNames[5]];
                [self play];

      
            }else{
                [self.buttonSix setEnabled:NO];
                [self.buttonSix setTitle:@"empty" forState:UIControlStateDisabled];
            }
            break;
        case 7:
        
            if (!([self.trackNames count] < 7)) {
                [self updatePath:self.trackNames[6]];
                [self play];


            }else{
                [self.buttonSeven setEnabled:NO];
                [self.buttonSeven setTitle:@"empty" forState:UIControlStateDisabled];
            }
            break;
        case 8:
      
            if (!([self.trackNames count] < 8)) {
                [self updatePath:self.trackNames[7]];
                [self play];

            }else{
                [self.buttonEight setEnabled:NO];
                [self.buttonEight setTitle:@"empty" forState:UIControlStateDisabled];
            }
            break;
        default:break;
            
    }
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
-(void) play
{
    UInt32 soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(_outputFileURL), &soundID);
    AudioServicesPlaySystemSound(soundID);
}
@end
