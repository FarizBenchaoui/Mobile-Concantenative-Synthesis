//
//  CSFBAudioMixer.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 11/08/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@protocol AudioManagerDelegate
@required
@end
@interface CSFBAudioMixer : NSObject
{
@public
    AudioBufferList bufferList;
}
@property (readwrite) BOOL input, output;
@property (nonatomic, readwrite) float sampleRate;
@property (nonatomic, assign) AudioStreamBasicDescription audioFormat;
@property (readwrite) AUGraph   audioGraph;
@property (readwrite) AudioUnit samplerUnit;
@property (readwrite) AudioUnit mixerUnit;
@property (readwrite) AudioUnit ioUnit;
@property (nonatomic, assign) id<AudioManagerDelegate> delegate;

+ (CSFBAudioMixer*) sharedAudioManager;
- (void) playNote:(int) notenum;
- (void) stopNote:(int) notenum;
- (OSStatus) loadSynthFromPresetURL: (NSURL *) presetURL;
- (OSStatus) loadFromDLSOrSoundFontName: (NSString *)name withPatch: (int)presetNumber;

@end
