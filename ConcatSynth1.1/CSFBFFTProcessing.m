//
//  CSFBFFTProcessing.m
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 29/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import "CSFBFFTProcessing.h"


int windowLength;
FFTSetup fftSetup;
DSPSplitComplex  A;

@implementation CSFBFFTProcessing

-(id)init
{
    //initiate object
    self = [super init];
    return self;
}

-(void) runFFT:(NSMutableArray *)sample trackName:(NSString *)trackName
{//
   
    /*Builds a data structure that contains precalculated data for use by single-precision FFT functions.
     This function returns a filled-in FFTSetup data structure for use by FFT functions that operate on single-precision vectors.*/
    fftSetup = vDSP_create_fftsetup(16,
                                    FFT_RADIX2);
    
  
    windowLength = pow(2,ceil(log([sample count])/log(2)));
    //set sample to float array
    float samples[windowLength ];
   for (int i=0; i<windowLength ; i++) {

       if (i<[sample count]) {
       samples[i] = [sample[i] floatValue];
       }else{
       samples[i]=0;
       }

       
    }
    
    // Populate *window with the values for a hamming window function
  float *window = (float *)malloc(sizeof(float) * windowLength );
    //Creates a single-precision Hanning window.
    vDSP_hann_window(window, windowLength , vDSP_HANN_NORM);
    // multiply our audio data by our window
    vDSP_vmul(samples, 1, window, 1, samples, 1,windowLength );
    
    //here we define our complex vector
    float splitReal[windowLength /2];
    float splitImag[windowLength /2];
    A.realp = splitReal;
    A.imagp = splitImag;
    //we then copy our audio data to split complex vector
    vDSP_ctoz((const DSPComplex*)samples,
              2,
              &A,
              1,
              (windowLength /2));
    //perform a forward fft, storing the results in our complex vector
    vDSP_fft_zrip(fftSetup,
                  &A,
                  1,
                  (vDSP_Length)lround(log2(windowLength)),
                  kFFTDirection_Forward);
  
    //The power Spectral density from the fft is computed, no scaling is performed, as we are only interested in the relative values of the Power Spectral Density
   float powerSpectralDensity[windowLength /2+1];
    //move the nyquist component to the end of the array
    powerSpectralDensity[windowLength /2]=A.imagp[0]*A.imagp[0];
    //set the dc component to zero, the dc component is the mean value of the waveform
    A.imagp[0]=0.0;
    //calculating the square magnitude of our complex vector
    //results are then stored in an the powerSpectral array
    vDSP_zvmags(&A,
                1,
                powerSpectralDensity,
                1,
            (windowLength /2));

    self.fftResultsArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<=windowLength /2; i++) {
        
        NSNumber *value = [NSNumber numberWithFloat:powerSpectralDensity[i]];
     
        [self.fftResultsArray addObject:value];
    }
    

    vDSP_destroy_fftsetup(fftSetup);
    
    CSFBCoreDataInterface  *coreDataInterface = [[CSFBCoreDataInterface alloc]init];
      
    [coreDataInterface saveFFTResults:self.fftResultsArray trackName:trackName];
  
    
}

@end

