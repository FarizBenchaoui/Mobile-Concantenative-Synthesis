//
//  CSFBFileConvert++.cpp
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 29/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

/*Code remixed from content from Learning Learning Core Audio: A Hands-On Guide to Audio Programming for Mac and IOS
 Authors: Chris Adamson and Kevin Avila
 */
#include "CSFBFileConvert.h"
#include "CSFBFFTProcessing.h"


NSMutableArray *analysisResults;
char* myFile;
static CSFBFileConvert *globalSelf;
@implementation CSFBFileConvert

static void CheckError(OSStatus error, const char *operation){
    /*Method from Learning Learning Core Audio: A Hands-On Guide to Audio Programming for Mac and IOS
     Authors: Chris Adamson and Kevin Avila
     */
    if (error == noErr) return;
    
    char errorString[20];
    //see if it appears to be a 4-char-code
    *(UInt32 *)(errorString +1) = CFSwapInt32HostToBig(error);
    if( isprint(errorString[1])
       && isprint(errorString[2])
       && isprint(errorString[3])
       && isprint(errorString[4]) ){
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    }else{
        sprintf(errorString,"%d",(int) error);
        fprintf(stderr,"Error:%s(%s)\n",operation, errorString);
        NSString* errorMessage = [NSString stringWithFormat:@"%s", errorString];
        [globalSelf alert:errorMessage];
        exit(1);
    }
}
-(id)init{
    self = [super init];
    globalSelf = self;
    return self;
}
-(void) convertAndProcess:(CFURLRef) myFile trackName:(NSString *)trackName
{


    //Opens an existing audio file for reading, and associates it with a new extended audio file object.
    ExtAudioFileRef fileRef;
  
    ExtAudioFileOpenURL(myFile, &fileRef);
    CheckError(ExtAudioFileOpenURL(myFile, &fileRef), "ExtAudioFileOpenURL failed");
    //define the audio format's we want to apply to our audio file
    AudioStreamBasicDescription audioFormat;
 
    audioFormat.mSampleRate = 44100;
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kLinearPCMFormatFlagIsFloat;
    audioFormat.mChannelsPerFrame = 1;
    audioFormat.mBitsPerChannel = 32;
    audioFormat.mBytesPerFrame = 4;
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mBytesPerPacket = 4;
    
    CheckError(
    ExtAudioFileSetProperty(
                            fileRef,
                            kExtAudioFileProperty_ClientDataFormat,
                            sizeof (AudioStreamBasicDescription),
                            &audioFormat),"error setting property");
    
    int numSamples = 1024;
    UInt32 sizePerPacket = audioFormat.mBytesPerPacket;
    UInt32 packetsPerBuffer =numSamples;
    UInt32 outputBufferSize = numSamples * sizePerPacket;
    

    UInt8 *outputBuffer = (UInt8 *)malloc(sizeof(UInt8 *) * outputBufferSize);
   // UInt32 outPutFilePacketPosition =0;
    NSMutableArray *samples = [[NSMutableArray alloc]init];
    
    int index = 0;
    AudioBufferList bufferList;
    while (1) {
       
        bufferList.mNumberBuffers = 1;
        bufferList.mBuffers[0].mNumberChannels = audioFormat.mChannelsPerFrame;
        bufferList.mBuffers[0].mDataByteSize = outputBufferSize;
        bufferList.mBuffers[0].mData = outputBuffer;
        UInt32 frameCount = packetsPerBuffer;
        CheckError(ExtAudioFileRead(fileRef, &frameCount, &bufferList), "cound;t read from input file");
        if (frameCount==0) {
            break;
        }
       AudioBuffer audioBuffer = bufferList.mBuffers[0];
        float *frames = (float *)audioBuffer.mData;
        NSNumber *number = [NSNumber numberWithFloat:*frames];
        [samples addObject:number];
     
        index++;
        
    }
 
    CheckError(ExtAudioFileDispose(fileRef), "couldn't dispose of file ref");
    CSFBFFTProcessing* myFft = [[CSFBFFTProcessing alloc]init];
    [myFft runFFT:samples trackName:trackName];
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
