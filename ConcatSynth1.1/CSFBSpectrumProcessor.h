//
//  CSFBSpectrumProcessor.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 29/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#ifndef __ConcatSynth1_1__CSFBSpectrumProcessor__
#define __ConcatSynth1_1__CSFBSpectrumProcessor__
#import <Foundation/Foundation.h>
#include <Accelerate/Accelerate.h>
#include <AudioToolbox/AudioToolbox.h>
#include "PublicUtility/CAAutoDisposer.h"

#include <iostream>

#endif /* defined(__ConcatSynth1_1__CSFBSpectrumProcessor__) */
class CSFBSpectrumProcessor{
public:
    enum Window (Rectangular=1, Hann =2,Hamming = 3, Blackman = 4);
private:
    UInt32 mNumChannels;
    UInt32 mRingBufferCapacity;
    UInt32 mRingBufferPosRead;
    UInt32 mRingBufferPosWrite;
    UInt32 mRingBufferCount;
    UInt32 mFFTSize;
    FFTSetup mFFTSetup;
    bool mFFTSetupCreated;
    
    struct ChannelBuffers {
        CAAutoFree<float32> mRingBufferData;
        CAAutoFree<float32> mInputData;
        CAAutoFree<float32> mSplitdata;
        CAAutoFree<float32> mOutputData;
        CAAutoFree<DSPSplitComplex> mDSPSplitComlex;
    };
    CAAutoArrayDelete<ChannelBuffers> mChannels;
    CAAutoFree<Float32> mWindowData;

protected:
    void InitFFT(UInt32 FFTSize, UInt32 log2FFTSize, UInt32 bins);
    void ExtractRingBufferToFFTInput (UInt32 inNumFrames);
    void ApplyWindow (Window w);

public:
    CSFBSpectrumProcessor();
    virtual ~CSFBSpectrumProcessor();
    void Allocate(UInt32 inNumChannels, UInt32 ringBufferCapacity);
    bool CopyInputToRingBuffer (UInt32 inNumFrames, AudioBufferList* inInput);
    bool TryFFT (UInt32  inFFTSIze, Window w = Rectangular);
    CAAytoFree<Float32> GetMagnitudes (Window w , UInt32 channelSelect = 3);
    
};
